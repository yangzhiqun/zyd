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
    #{"合肥"=>[{"area":"合肥","dh":"SC1002134432","ypmc":"茶叶","jyxm":"xxxx","dl":"食用农产品","yl":"茶","cyl":"茶","xl":"茶"}]}
    #@data_arr:各市不合格批次数量 @data_items:各市不合格项目统计 @nonconformity 各市不合格项目详细
    @data_arr,@data_items,@nonconformity = Statistic.nonconformity.map{ |d| d.to_json }
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
        two = sp_bsb.where("sp_s_71 not like '%不合格样品%' or sp_s_71 not like '%问题样品%'").count
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
        #抽样超期
        sp_bsbs.where(sp_i_state:2).each { |sp| sampling_num +=1 if days_between(Time.now,sp.sp_d_38) > 5 }
        @data[city_name][0][:xAxis][0][:data] << jg_name
        @data[city_name][0][:series][0][:data] << sampling_num
        #检验超期
        examine_num = 0
        sp_bsbs.where(sp_i_state:[2..8,16]).includes(:sp_logs).each do |sp| 
          sp_log = nil
          sp.sp_logs.each{|log| sp_log = log if [2,3,4,5,6,7,8,16].include?(log.sp_i_state)}
          if sp_log
            time = sp_log.created_at.to_s
            examine_num += 1 if days_between(Time.now,time) > 40
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
    @data = {} #{"大众超市"=>[30,"5%",5,"5%",0,50,4,2],"人民食堂"=>[75,"9%",3,"7%",0,43,0,2]}
    city = params["city"] || "合肥"
    sp_bsbs = SpBsb.where("(sp_s_71 like '%不合格样品%' or sp_s_71 like '%问题样品%') and (sp_s_wcshi='#{city}' or sp_s_4='#{city}' or sp_s_220='#{city}')")
    sp_bsb_ids = sp_bsbs.map{|s| s.id }
    sp_yydjbs = {}
    wtyp_czb_p = WtypCzbPart.where(sp_bsb_id:sp_bsb_ids).group_by{ |wt| wt.sp_bsb_id }
    SpYydjb.where(id:sp_bsb_ids).each{ |spyy| sp_yydjbs[spyy.id] = spyy }
    sp_bsbs.group_by{ |sp| sp.sp_s_35 }.each do |name,sp_bsb_arr|  
      #不合格处置数,不合格处置率,不合格处置完成数,不合格处置完成率,异议数,复检数,复检不合格数,立案数
      num1,num2,num3,num4,num5,num6,num7,num8 = 0,'',0,'',0,0,0,0
      sp_bsb_arr.each do |sp_bsb|
        if wtyp_czb_p.has_key?(sp_bsb.id)
          wtyp_czb_p[sp_bsb.id].each do |wp|
            if wp.current_state == 1
              num1 += 1
            elsif wp.current_state == 3
              num3 += 1
            end
            num8 += 1 if wp.xzcfqk_1 == "是"
          end
        end
        if sp_yydjbs.has_key?(sp_bsb.id)
          num5 += 1
          if sp_yydjbs[sp_bsb.id] == 0
            num7 += 1 
          elsif sp_yydjbs[sp_bsb.id] == 1
            num6 += 1
          end
        end
      end
      num2 = ((num1.to_f/sp_bsb_arr.length)*100).to_i.to_s+"%" #不合格处置率
      num4 = ((num3.to_f/sp_bsb_arr.length)*100).to_i.to_s+"%" #不合格处置完成率
      @data[name] = ["经营",num1,num2,num3,num4,num5,num6,num7,num8]
    end
  end

  #企业覆盖率统计
  def enterprise_statistics
  end

  #不合格样品及问题样品预警
  def early_warning
    @data_arr,@data_items,@nonconformity = Statistic.nonconformity.map{ |d| d.to_json }
  end


  #退休统计
  #0 表格  1 图表
  def retirement_statistics
    @data = {"chouyang"=>[],"chengjian"=>[]} #{"chouyang" =>[{"area"=>"瑶海","cyjg"=>"zhangsan","txsl"=>"10","txl"=>"12"}]}
    sp_bsbs  = SpBsb.where(sp_s_3: "安徽")
    if params["time"].present?
      time = params["time"].split("/") 
      sp_bsbs = sp_bsbs.where(created_at:Statistic.time_slot(time[0],time[1]),sp_s_4:params["area"])
    end
    revision = RevisionLog.where(sp_bsb_id: sp_bsbs.map{|s|s.id}).group_by{ |r| r.sp_bsb_id}
    packet = sp_bsbs.group_by{ |sp| sp.send(params["time"].present? ? "sp_s_5":"sp_s_4") }
    @chart = Statistic.retirement(packet,revision) 
    packet.each do |county_name,sp_bsb_arr|
      region  = county_name   
      sp_bsb_arr.group_by{ |sp| sp.sp_s_35 }.each do |cy_jg,cy_arr| #抽样单位
        jg_name = cy_jg
        completely    = cy_arr.length
        revision_num  = 0
        cy_arr.each{ |spbsb| revision_num += revision[spbsb.id].length if revision.has_key?(spbsb.id) } 
        revision_rate = ((revision_num.to_f/completely)*100).to_i.to_s 
        @data["chouyang"] << {"area"=>region,"cyjg"=>jg_name,"txsl"=>completely,"txl"=>revision_rate}
      end
      sp_bsb_arr.group_by{ |sp| sp.sp_s_43 }.each do |cj_jg,cj_arr| #承检单位
        jg_name = cj_jg
        completely    = cj_arr.length
        revision_num  = 0
        cj_arr.each{ |spbsb| revision_num += revision[spbsb.id].length if revision.has_key?(spbsb.id) } 
        revision_rate = ((revision_num.to_f/completely)*100).to_i.to_s 
        @data["chengjian"] << {"area"=>region,"cyjg"=>jg_name,"txsl"=>completely,"txl"=>revision_rate}
      end
    end
    if params["flag"].blank?
      @data = @data.to_json
      @chart = @chart.to_json
    else
      if params["flag"] == "0"
        render json: @data
      else
        render json: @chart
      end
    end
  end

  #复合查询统计
  def composite_statistics
    #@data = [{name: "合肥",totalbat:"6574",samplingbat:"1232",qualifiedbat:"1200",unqualifiedbat:"193",qualifiedsamp:"4.263%",riskbat:"1222",problembat:"713",problemsamp:"1.24%",children:[{name: "长丰",totalbat:"22",samplingbat:"15",qualifiedbat:"10%",unqualifiedbat:"12",qualifiedsamp:"20",riskbat:"2",problembat:"713",problemsamp:"1.24%"}]}]
    if params.has_key?(:q)
      @q = SpBsb.send(params[:q]["sp_s_71"]=="合格批次" ? :qualified : :unqualified) if params[:q]["sp_s_71"].present?
      @q = (@q.nil? ? SpBsb : @q).where(created_at:Statistic.time_slot(params[:q]["created_at_start"],params[:q]["created_at_end"])) if params[:q]["created_at_start"].present? 
      @q = @q.nil? ? SpBsb.ransack(params[:q]) : @q.ransack(params[:q])
    else
      @q = SpBsb.ransack(params[:q])
    end
    @products = @q.result(distinct: true)
    @data = []
    sp_bsbs = @products.where("sp_s_4 != '请选择'").group_by{ |sp| sp.sp_s_4 }
    sp_bsbs.each do |city_name,city_arr| #sp_arr:每个市
      county_sp = city_arr.group_by{ |sp| sp.sp_s_5 }
      county_result = []
      county_sp.each do |count_name,county_arr| #arr:每个县
        #0地区,1总批次,2监督抽检批次,3合格批次,4不合格批次,5不合格样品率,6风险检测批次,7问题样品批次,8问题样品率
        num0,num1,num2,num3,num4,num5,num6,num7,num8='',0,0,0,0,'',0,0,''
        num0 = count_name
        num1 = county_arr.length
        county_arr.each do |sp| 
          if sp.sp_s_44 == "监督抽检"
            num2 += 1 
            num4 += 1 if /不合格样品|问题样品/ =~ sp.sp_s_71 #不合格批次
          elsif sp.sp_s_44 == "风险监测"
            num6 += 1
            num7 += 1 if /不合格样品|问题样品/ =~ sp.sp_s_71 #问题样品批次
          end
        end
        num3 = num1-num4 #合格批次
        num5 = ((num4.to_f/num1)*100).to_i.to_s+"%" #不合格样品率
        num8 = ((num7.to_f/num1)*100).to_i.to_s+"%" #问题样品率
        county_result << {name: num0,totalbat:num1.to_s,samplingbat:num2.to_s,qualifiedbat:num3.to_s,unqualifiedbat:num4.to_s,qualifiedsamp:num5,riskbat:num6.to_s,problembat:num7.to_s,problemsamp:num8}
      end
      #合计该市的信息
      num1,num2,num3,num4,num5,num6,num7,num8 = 0,0,0,0,'',0,0,''
      county_result.each do |c| 
        num1 += c[:totalbat].to_i
        num2 += c[:samplingbat].to_i
        num3 += c[:qualifiedbat].to_i
        num4 += c[:unqualifiedbat].to_i
        num6 += c[:riskbat].to_i
        num7 += c[:problembat].to_i
      end
      num5 = ((num4.to_f/num1)*100).to_i.to_s+"%"
      num8 = ((num7.to_f/num1)*100).to_i.to_s+"%"
      @data << {name: city_name,totalbat:num1.to_s,samplingbat:num2.to_s,qualifiedbat:num3.to_s,unqualifiedbat:num4.to_s,qualifiedsamp:num5,riskbat:num6.to_s,problembat:num7.to_s,problemsamp:num8,children:county_result}
    end
    @data = @data.to_json
  end
end
