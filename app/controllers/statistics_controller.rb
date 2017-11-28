class StatisticsController < ApplicationController

  require 'food/download_statistics'

  def statistics
  end

  #任务统计
  def task_statistics
    #names = ACategory.where.not(name:nil).distinct.pluck(:name)
    #@item_counts = SpBsb.where("sp_s_17 != ''").group(:sp_s_17).count.sort_by{ |key, value| value }.reverse.to_h
    #names.each{ |a| @item_counts[a]=0 unless @item_counts.has_key?(a) }
  end

  #任务统计-任务类型
  def statistics_task_type
    render layout: false
  end

  #任务统计-食品类型
  def statistics_food_type
    render layout: false
  end

  #任务统计-抽样地点
  def statistics_sampling_sites
    render layout: false
  end

  #任务统计-生产单位所在省
  def statistics_production_unit_province
    render layout: false
  end

  #食品类别统计
  def food_statistics
    @a_categories = ACategory.all
  end

  #不合格项目统计
  def nonconformity_statistics
    @sp_bsbs = SpBsb.where("sp_bsbs.sp_i_state = 9 AND (sp_bsbs.sp_s_71 like '%不合格样品%' or sp_bsbs.sp_s_71 like '%问题样品%')").includes(:spdata)
    @data_arr = []
    @data_items = {"安徽省"=>{}}
    city = @sp_bsbs.where("sp_s_4 != '请选择'")
    county = @sp_bsbs.where("sp_s_5 != '请选择'")
    #地图各省数据
    city.group(:sp_s_4).count.each{ |k,y| @data_arr << {"name" => k+"市","value" => y} } 
    county.group(:sp_s_5).count.each{ |k,y| @data_arr << {"name" => k,"value" => y}}
    p "1"*200
    p @data_arr
    p "2"*200
    @data_arr = @data_arr.to_json
    #各省不合格项目
    city.group_by{ |c| c.sp_s_4 }.each do |key,sp_bsbs|
      name = key+"市"
      @data_items[name] = {}
      sp_bsbs.each do |sp|
        sp.spdata.each do |data| 
          if data.spdata_2 == "不合格项"
            @data_items[name].has_key?(data.spdata_0) ? @data_items[name][data.spdata_0]+=1 : @data_items[name][data.spdata_0]=1   
            @data_items["安徽省"].has_key?(data.spdata_0) ? @data_items["安徽省"][data.spdata_0]+=1 : @data_items["安徽省"][data.spdata_0]=1   
          end
        end
      end
    end
    p @data_items
    @data_items = @data_items.to_json
    if params["is_export"].present?
      send_file(DownloadStatistics.start("Statistic::Nonconformity",["aa"]), :disposition => "attachment")
    end
  end

  def nonconformity_statistics_data
    data = File.open("#{Rails.root.to_s}/app/assets/javascripts/statistics/map/china-main-city/#{params["id"]}.json").read
    render json: data 
  end

  #承检单位统计
  def unit_statistics
    #@data_test = [{name: "合肥", code: "1",task:"22",sampling:"15",qualified:"10",unqualified:"12",Disposed:"20",Disposeing:"2",children:[{name: "合肥承检1", code: "2",task:"10",sampling:"5",qualified:"8",unqualified:"2",Disposed:"10",Disposeing:"0",},{name: "合肥承检2", code: "3",task:"5",sampling:"5",qualified:"5",unqualified:"0",Disposed:"4",Disposeing:"1",},{name: "合肥承检3", code: "4",task:"7",sampling:"5",qualified:"5",unqualified:"2",Disposed:"5",Disposeing:"2",}]},{name: "黄山", code: "5", task:"20",sampling:"15",qualified:"11",unqualified:"1",Disposed:"1",Disposeing:"1",},{name: "蚌埠", code: "6", task:"15",sampling:"15",qualified:"11",unqualified:"10",Disposed:"2",Disposeing:"2",},{name: "", code: "总计",task:"57",sampling:"45",qualified:"32",unqualified:"23",Disposed:"23",Disposeing:"5"}]
    #SpBsb.where(created_at:(Time.now.midnight - 1.year)..Time.now.midnight) sp_d_86 时间
    @data = []
    jg_bsbs = JgBsb.where("city != '-请选择-'").includes(:jg_bsb_names)
    jg_names = {}
    jg_bsbs.each{|jg| jg_names[jg.id] = jg.jg_name}
    jg_bsbs.group_by{|j|j.city}.each do |key,value|
      hash = {name: key, code: "无", task:"无",sampling:0,qualified:0,unqualified:0,dcisposed:0,disposeing:0,children:[]}
      value.each do |jg|
        sp_bsb = SpBsb.where(sp_s_43:jg_names[jg.id]).includes(:wtyp_czb_parts)
        #接样数
        one = sp_bsb.count
        #合格数
        two = sp_bsb.where("sp_s_71 not like '%不合格样品%' and sp_s_71 not like '%问题样品%'").count
        #不合格数
        three = one-two
        #处置结果
        num = WtypCzbPart.where(cydwmc:jg_names[jg.id]).group(:cydwmc).length
        #已处置
        four = WtypCzbPart.where(cydwmc:jg_names[jg.id],current_state:3).group(:cydwmc).length
        #处置中 
        five = num-four

        hash[:sampling]    += one
        hash[:qualified]   += two
        hash[:unqualified] += three
        hash[:dcisposed]   += four 
        hash[:disposeing]  += five

        hash[:children] << {name: jg_names[jg.id], code: "无", task:"无",sampling:one.to_s,qualified:two.to_s,unqualified:three.to_s,dcisposed: four.to_s,disposeing: five.to_s}
      end
      #把数值转换为字符串,否则0会不显示
      hash.each{ |key,value| hash[key] = value.to_s if key!=:children }
      @data << hash
    end
    @data = @data.to_json 
    if params["subpage"]
      render :partial => "subpage_unit_statistics", :locals => {:data => @data}
    end
  end

  #抽样及检验超期统计
  def overtime_statistics
    #@data = {:合肥=>[{:xAxis=>[{:data=>["抽样单位1", "抽样单位2", "抽样单位3", "抽样单位4", "抽样单位5", "抽样单位6", "抽样单位7"]}], :series=>[{:data=>[2, 4, 5, 4, 3, 1, 6]}]}, {:xAxis=>[{:data=>["抽样单位1", "抽样单位2", "抽样单位3", "抽样单位4", "抽样单位5", "抽样单位6", "抽样单位7"]}], :series=>[{:data=>[2, 4, 5, 4, 3, 1, 6]}]}]}
    @data = {}
    SysProvince.level1.each do |city|
      city_name = city.name
      jg_bsbs = JgBsb.where(city: city_name).includes(:jg_bsb_names)
      @data[city_name] = [{:xAxis=>[{:data=>[]}],:series=>[{:data=>[]}]},{:xAxis=>[{:data=>[]}],:series=>[{:data=>[]}]}] 
      jg_bsbs.each do |jg|
        sampling_num = 0 #单位抽样超期数量
        jg_name = jg.jg_bsb_names.last.name
        sp_bsbs = SpBsb.where(sp_s_43:jg_name)
        #sp_bsbs.where(sp_i_state:2).each { |sp| sampling_num +=1 if days_between(Time.now,sp.sp_d_38) < 5 }
        #抽样超期
        sp_bsbs.where(sp_i_state:2).each { |sp| p days_between(Time.now,sp.sp_d_38) }
        @data[city_name][0][:xAxis][0][:data] << jg_name
        @data[city_name][0][:series][0][:data] << sampling_num
        #检验超期
        examine_num = 0
        sp_bsbs.where(sp_i_state:[2..8,16]).includes(:sp_logs).each do |sp| 
          sp_log = nil
          sp.sp_logs.each{|log| sp_log = log if [2,3,4,5,6,7,8,16].include?(log.sp_i_state)}
          if sp_log
            time = sp_log.created_at.to_s
            examine_num += 1 if days_between(Time.now,time) < 40
          end
        end
        @data[city_name][1][:xAxis][0][:data] << jg_name
        @data[city_name][1][:series][0][:data] << examine_num
      end
    end
    @data = @data.to_json
  end

  #核查处置统计
  def disposal_statistics
    city = params["city"] || "合肥"
    sp_bsbs = SpBsb.where("sp_s_71 not like '%不合格样品%' and sp_s_71 not like '%问题样品%'").includes(:wtyp_czbs,:wtyp_czb_parts)
    #区域:sp_s_wcshi sp_s_4
    #不合格处置数 num = wtyp_czbs =1  状态
    #不合格处置率 :num/sp_bsbs
    #不合格处置完成数 :wtyp_czbs =3
    #:不合格处置完成率:wtyp_czbs/sp_bsbs
    # 异议数:sp_bsb.sp_yydjb
    # 复检数:sp_bsb.sp_yydjb.fjsqqk
    # 复检不合格数:sp_bsb.sp_yydjb.fjsqqk
    # 立案数:wtyp_czb_parts :spbsb. wtyp_czbs .wtyp_deal_fix3way  页面：行政立案
  end

  #企业覆盖率统计
  def enterprise_statistics
  end

  #不合格样品及问题样品预警
  def early_warning
    #同不合格项目统计
  end

  #复合查询统计
  def composite_statistics
    #地区 全部包含
    #总批次 ： sp_bsb.where(地区).count
    #监督抽检批次：sp_s_44
    #风险检测批次 :sp_s_44
    #合格批次 ：总数-不合格
    #不合格批次：SpBsb.where("sp_s_71 not like '%不合格样品%' and sp_s_71 not like '%问题样品%'")
    #不合格样品率:不合格/总数
    #问题样品批次 ： SpBsb.bgfl.count
    #问题样品批次/总数
  end

end
