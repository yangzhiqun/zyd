class StatisticsController < ApplicationController

  require 'food/download_statistics'
  skip_before_filter :session_expiry, :verify_authenticity_token, :authenticate_user!,:only => [:particulars,:company_particulars,:hccz_particulars,:spyy_particulars]

  def statistics
  end

  #任务统计
  #[{name: "合肥",sampling:"500",test:"250",unqualified:"12",qualified:"238",Disposed:"7",Disposal:"5"}]
  def task_statistics
    @q = SpBsb.ransack(params[:q])
    @products = @q.result(distinct: true)
    @data = []
    power = region_power
    sp_bsbs = @products.admin_select(power[0])
    wtyp_czb_p = WtypCzbPart.where(sp_bsb_id:sp_bsbs.unqualified.map{ |p| p.id }).group_by{ |wt| wt.sp_bsb_id }
    sp_bsbs = sp_bsbs.group_by{ |sp| sp.send(power[1]) }
    sp_bsbs.each do |city_name,city_arr| #sp_arr:每个市
      county_sp = power[1]=="sp_s_4" ? city_arr.group_by{ |sp| sp.sp_s_5 } : sp_bsbs
      county_result = []
      county_sp.each do |count_name,county_arr| #arr:每个县
        #0地区,1抽样数,2检验数,3不合格数,4合格数,5已处置,6处置中
        num0,num1,num2,num3,num4,num5,num6='',[],[],[],[],[],[]
        num0 = count_name
        num1 = county_arr.map(&:id)
        county_arr.each do |sp| 
          if sp.sp_i_state == 9
            num2 << sp.id
            num3 << sp.id if sp.sp_s_71 =~ /不合格样品|问题样品/
            wtyp_czb_p[sp.id].each do |w|
              if [1,2].include? w.current_state
                num6 << w.id
              elsif w.current_state == 3
                num5 << w.id 
              end
            end if wtyp_czb_p.has_key?(sp.id)
          end
          num4 << sp.id if (/^((?!监测问题样品).)*$/ =~ sp.sp_s_71) && (/([^不]合格)/ =~ sp.sp_s_71) #合格批次
        end
        county_result << {name: num0,sampling:num1,test:num2,unqualified:num3,qualified:num4,Disposed:num5,Disposal:num6}
      end
      #如果是省市管理员:合计该市的信息
      if power[1]=="sp_s_4"
        num1,num2,num3,num4,num5,num6 = [],[],[],[],[],[]
        p county_result
        county_result.each do |c| 
          num1.concat c[:sampling]
          num2.concat c[:test]
          num3.concat c[:unqualified]
          num4.concat c[:qualified]
          num5.concat c[:Disposed]
          num6.concat c[:Disposal]
        end
        @data << {name: city_name,sampling:num1,test:num2,unqualified:num3,qualified:num4,Disposed:num5,Disposal:num6,children:county_result}
      else
        @data = county_result
      end
    end
    if params["is_export"] == "1"
      send_file(DownloadStatistics.composite("Statistic::Task",@data), :disposition => "attachment") and return
    end
    @data = @data.to_json
  end

  #食品类别统计
  #[{"name"=>"报送分类a1", "sampling"=>"128","test"=>"80","unqualified"=>"15","qualified"=>"65","Disposed"=>"13","Disposal"=>"2"}]
  def food_statistics
    if params.has_key?(:q) && params[:q]["time"].present?
      time = params[:q]["time"].gsub(/\s/,"").split("/")
      @q = SpBsb.where(sp_d_38:Statistic.time_slot(time[0],time[1])).ransack(params[:q])
    else
      @q = SpBsb.ransack(params[:q])
    end
    power = region_power
    @products = @q.result(distinct: true).admin_select(power[0])
    @data = Statistic.food(@products,"sp_s_70")
    if params["is_export"] == "1"
      send_file(DownloadStatistics.food("Statistic::Food",@data), :disposition => "attachment") and return
    end
    @data = @data.to_json
  end

  def food_subset_statistics
    time = params["time"].gsub(/\s/,"").split("/")
    category = eval(params["params"])
    sp_bsbs = SpBsb.where(category)
    sp_bsbs = sp_bsbs.where(sp_d_38:Statistic.time_slot(time[0],time[1])) if params["time"].present?
    sp_bsbs = sp_bsbs.where(sp_s_70:params["baosongA"]) if params["baosongA"].present?
    @data = Statistic.food(sp_bsbs,Statistic::Corr[category.length])
    render json: @data
  end

  #不合格项目统计
  def nonconformity_statistics
    #{"合肥"=>[{"area":"合肥","dh":"SC1002134432","ypmc":"茶叶","jyxm":"xxxx","dl":"食用农产品","yl":"茶","cyl":"茶","xl":"茶"}]}
    #@data_arr:各市不合格批次数量 @data_items:各市不合格项目统计 @nonconformity 各市不合格项目详细
    arr = nonconformity_power 
    @q = SpBsb.ransack(params[:q])
    power = region_power
    @products = @q.result(distinct: true).admin_select(power[0])
    @data_arr,@data_items,@nonconformity = Statistic.nonconformity(@products)
    if params["is_export"] == "1"
      sheng = SysConfig.get(SysConfig::Key::PROV)+"省"
      @nonconformity.delete(sheng)
      send_file(DownloadStatistics.nonconformity("Statistic::Nonconformity",@nonconformity), :disposition => "attachment") and return
    end
    @data_arr = @data_arr.to_json
    @data_items = @data_items.to_json
    @nonconformity = @nonconformity.to_json
    @region = arr[0].to_json
    @super = arr[1].to_json
  end

  #不合格项目-县
  def nonconformity_county_statistics
    data_items = {}
    detailed = []
    county  = params["county"]
    county_g= params["county"].gsub(/[县区市]/,"")
    city = SpBsb.unqualified.where("sp_s_5='#{county}' or sp_s_5='#{county_g}'").includes(:spdata)
    city.group_by{ |c| c.sp_s_5 }.each do |key,sp_bsbs|
      name = key
      sp_bsbs.each do |sp|
        sp.spdata.each do |data| 
          if data.spdata_2 == "不合格项" or data.spdata_2 == "问题项"
            data_items.has_key?(data.spdata_0) ? data_items[data.spdata_0]<< sp.id : data_items[data.spdata_0]=[sp.id] 
            hash = {"area"=>name,"dh"=>sp.sp_s_16,"bcydw"=>sp.sp_s_1,"scqy"=>sp.sp_s_64,"rwly"=>sp.sp_s_2_1,"ypmc"=>sp.sp_s_14,"jyxm"=>data.spdata_0,"dl"=>sp.sp_s_17,"yl"=>sp.sp_s_18,"cyl"=>sp.sp_s_19,"xl"=>sp.sp_s_20}
            detailed << hash
          end
        end
      end
    end
    render json: {"data_items"=>data_items,"detailed"=>detailed}
  end

  def nonconformity_statistics_data
    data = File.open("#{Rails.root.to_s}/app/assets/javascripts/statistics/map/china-main-city/#{params["id"]}.json").read
    render json: data 
  end

  #承检单位统计
  def unit_statistics
    #@data_test = [{name: "合肥", code: "1",task:"22",sampling:"15",qualified:"10",unqualified:"12",Disposed:"20",Disposeing:"2",children:[]},{name: "黄山", code: "5", task:"20",sampling:"15",qualified:"11",unqualified:"1",Disposed:"1",Disposeing:"1",}]
    @data = []
    @chart = {}
    power = unit_power
    jg_bsbs = JgBsb.where(power[0])
    if params.has_key?(:q) && params[:q]["time"].present?
      time = params[:q]["time"].gsub(/\s/,"").split("/")
      @q = SpBsb.where(sp_d_38:Statistic.time_slot(time[0],time[1])).ransack(params[:q])
    else
      @q = SpBsb.ransack(params[:q])
    end
    jg_names = {}
    JgBsbName.where(jg_bsb_id:jg_bsbs.map(&:id)).group_by{ |jg| jg.jg_bsb_id }.each{ |id,names| jg_names[id] = names.last.name }
    sp_bsbs = @q.result(distinct: true).where(sp_s_43:jg_names.values).group_by{ |sp_bsb| sp_bsb.sp_s_43 }
    wtyp_czb_p = WtypCzbPart.all.group_by{ |wt| wt.sp_bsb_id }
    jg_bsbs.group_by{|j|j.send(power[1])}.each do |key,value|
      hash = {name: key,sampling:[],qualified:[],unqualified:[],dcisposed:[],disposeing:[],children:[]}
      value.each do |jg|
        #1接样数,2合格数,3不合格数,4已处置,5处置中
        num1,num2,num3,num4,num5 = [],[],[],[],[]
        if jg_names.has_key?(jg.id) && sp_bsbs.has_key?(jg_names[jg.id])
          sp_bsb = sp_bsbs[jg_names[jg.id]]
          num1 = sp_bsb.map(&:id)
          sp_bsb.each do |s| 
            num2 << s.id if (/^((?!监测问题样品).)*$/ =~ s.sp_s_71) && (/([^不]合格)/ =~ s.sp_s_71)
            num3 << s.id if s.sp_s_71 =~ /不合格样品|问题样品/
            wtyp_czb_p[s.id].each do |w|
              if [1,2].include? w.current_state
                num5 << w.id
              elsif w.current_state == 3
                num4 << w.id 
              end
            end if wtyp_czb_p.has_key?(s.id)
          end
        end
        hash[:sampling].concat    num1
        hash[:qualified].concat   num2
        hash[:unqualified].concat num3
        hash[:dcisposed].concat   num4 
        hash[:disposeing].concat  num5
        hash[:children] << {name: jg_names[jg.id],sampling:num1,qualified:num2,unqualified:num3,dcisposed:num4,disposeing:num5}
      end
      #把数值转换为字符串,否则0会不显示
      @data << hash
    end
    if params["is_export"] == "1"
      send_file(DownloadStatistics.composite("Statistic::Unit",@data), :disposition => "attachment") and return
    end
    bao_a = SpBsb.all.group_by{ |sp| sp.sp_s_70 } 
    @data.each do |data|
      #{"cgtj":{"x":['合肥承检1','合肥承检2'],"jys":[600,400],"hgs":[180,600],"bhgs":[100,100],"yczs":[80,70],"czzs":[40,20]},"cjrw":{"x":['抽检监测（市级本级）','抽检监测（省级专项）','抽检监测（省级转移）'],"y":[12,23,7]}}
      x,jys,hgs,bhgs,yczs,czzs = [],[],[],[],[],[]
      name = data[:name] #市区名称
      data[:children].each do |d| 
        x    << d[:name]
        jys  << d[:sampling].length
        hgs  << d[:qualified].length
        bhgs << d[:unqualified].length
        yczs << d[:dcisposed].length
        czzs << d[:disposeing].length
      end
      cjrw_x,cjrw_y = [],[]
      bao_a.each do |name,arr|
        cjrw_x << name
        jg_name = arr.map{|s|s.sp_s_43}
        num = 0
        x.each{ |n| num+=1 if jg_name.include?(n)}
        cjrw_y << num
      end
      @chart[data[:name]] = {"cgtj"=>{"x"=>x,"jys"=>jys,"hgs"=>hgs,"bhgs"=>bhgs,"yczs"=>yczs,"czzs"=>czzs},"ccjrw"=>{"x"=>cjrw_x,"y"=>cjrw_y}}
    end
    @data = @data.to_json 
    @chart = @chart.to_json
  end

  #抽样及检验超期统计
  def overtime_statistics
    #@data = {:合肥=>[{:xAxis=>[{:data=>["抽样单位1", "抽样单位2", "抽样单位3", "抽样单位4", "抽样单位5", "抽样单位6", "抽样单位7"]}], :series=>[{:data=>[2, 4, 5, 4, 3, 1, 6]}]}, {:xAxis=>[{:data=>["抽样单位1", "抽样单位2", "抽样单位3", "抽样单位4", "抽样单位5", "抽样单位6", "抽样单位7"]}], :series=>[{:data=>[2, 4, 5, 4, 3, 1, 6]}]}]}
    @data = {}
    @overdue = {}
    power = region_power
    sp_bsbs = SpBsb.admin_select(power[0])
    city = power[2] == 0 ? "sp_s_4" : "sp_s_5"
    sp_bsbs.group_by{ |sp| sp.send(city) }.each do |city_name,city_arr|
      chou_data,chou_series,jian_data,jian_series = [],[],[],[]
      sampling_num,examine_num = 0,0
      city_arr.group_by{ |a| a.sp_s_35 }.each do |jg_name,jg_arr|
        chou_data << jg_name
        jg_arr.each do |obj|
          sampling_num +=1 if obj.sp_i_state == 2 && Statistic.time_ranges(obj.sp_d_38,Time.now) > 5
        end
        chou_series << sampling_num
        sampling_num = 0
      end
      city_arr.group_by{ |a| a.sp_s_43 }.each do |jg_name,jg_arr|
        jian_data << jg_name
        jg_arr.each do |obj|
          examine_num += 1 if [2,3,4,5,6,7,8,16].include?(obj.sp_i_state) && Statistic.time_ranges(obj.sp_d_86,Time.now) > 20
        end
        jian_series << examine_num
        examine_num = 0
      end
      @data[city_name] = [{:xAxis=>[{:data=>chou_data}],:series=>[{:data=>chou_series}]},{:xAxis=>[{:data=>jian_data}],:series=>[{:data=>jian_series}]}]
    end
    #{"x":['合肥','芜湖','蚌埠','淮南','马鞍山','淮北','铜陵','安庆','黄山','滁州','阜阳','宿州','六安市'],"y":{"hclq":[200, 140, 170, 230, 245, 176, 135, 162, 132, 120, 160, 130,140],"hcwc":[63, 35, 52, 88, 84, 43, 56, 50, 35, 73, 37, 94,42],"yycq":[6, 5, 5, 8, 4, 3, 6, 0, 5, 7, 17, 4,14]}}
    unqualified = sp_bsbs.unqualified
    wtyp_czb_p = WtypCzbPart.where(sp_bsb_id:unqualified.map(&:id)).group_by{ |wt| wt.sp_bsb_id } 
    sp_logs = SpLog.where(sp_bsb_id:unqualified.map(&:id)).group_by{ |sp| sp.sp_bsb_id } 
    x,y = [],{"hclq"=>[],"hcwc"=>[],"yycq"=>[]}
    unqualified.group_by{ |sp| sp.send(city) }.each do |city_name,city_arr|
      hclq,hcwc,yycq = 0,0,0
      x << city_name
      city_arr.each do |sp_chaoqi|
        #核查领取超期
        wtyp_czb_p[sp_chaoqi.id].reverse_each do |wty|
          if wty.current_state == 1
            sp_logs[sp_chaoqi.id].reverse_each do |log|
              if log.sp_i_state == 9 && days_between(Time.now,log.created_at)>7
                hclq+=1
                break 
              end
            end
            break
          end
        end 
      end
    end
    @data = @data.to_json
  end

  #核查处置统计
  def disposal_statistics
    @data = [] #[{"czdw":"处置单位","bhgczs":[],"bhgczl":"不合格处置率","bhgczwcs":[],"yys":[],"fjs":[],"fjbhgs":[],"las":[]}]
    sp_bsbs = SpBsb.where("sp_s_71 like '%不合格样品%' or sp_s_71 like '%问题样品%'").where(disposal_power)
    if params["time"].present? 
      time = params["time"].split("/")
      sp_bsbs = sp_bsbs.where(sp_d_38:Statistic.time_slot(time[0],time[1])).where(disposal_power(params["area"]))
    end
    sp_bsb_ids = sp_bsbs.map{|s| s.id }
    sp_yydjbs = {}
    wtyp_czb_p = WtypCzbPart.where(sp_bsb_id:sp_bsb_ids).group_by{ |wt| wt.sp_bsb_id }
    SpYydjb.where(id:sp_bsb_ids).each{ |spyy| sp_yydjbs[spyy.id] = spyy }
    sp_bsbs.group_by{ |sp| sp.sp_s_35 }.each do |name,sp_bsb_arr|  
      #1不合格处置数,2不合格处置率,3不合格处置完成数,4异议数,5复检数,6复检不合格数,7立案数
      num1,num2,num3,num4,num5,num6,num7 = [],'',[],[],[],[],[]
      sp_bsb_arr.each do |sp_bsb|
        if wtyp_czb_p.has_key?(sp_bsb.id)
          wtyp_czb_p[sp_bsb.id].each do |wp|
            if params["hj"].blank? 
              if wp.current_state == 1
                num1 << wp.id
              elsif wp.current_state == 3
                num3 << wp.id
              end
              num7 << wp.id if wp.xzcfqk_1 == "是"
            else
              pan = wp.wtyp_czb_type == 1 if params["hj"]=="SC"    
              pan = [2,3].include?(wp.wtyp_czb_type) if params["hj"]=="JY"    
              pan = wp.wtyp_czb_type == 4 if params["hj"]=="WC"    
              if pan
                if wp.current_state == 1
                  num1 << wp.id
                elsif wp.current_state == 3
                  num3 << wp.id
                end
                num7 << wp.id if wp.xzcfqk_1 == "是"
              end
            end
          end
        end
        if sp_yydjbs.has_key?(sp_bsb.id)
          num4 << sp_bsb.id
          if sp_yydjbs[sp_bsb.id] == 0
            num6 << sp_bsb.id 
          elsif sp_yydjbs[sp_bsb.id] == 1
            num5 << sp_bsb.id
          end
        end
      end
      num2 = ((num1.length.to_f/sp_bsb_arr.length)*100).to_i.to_s #不合格处置率
      @data << {"czdw"=>name,"bhgczs"=>num1,"bhgczl"=>num2,"bhgczwcs"=>num3,"yys"=>num4,"fjs"=>num5,"fjbhgs"=>num6,"las"=>num7}
    end
    send_file(DownloadStatistics.enterprise("Statistic::Disposal",@data), :disposition => "attachment") and return if params["is_export"] == "1"
    if params["flag"].blank?
      @data = @data.to_json
    else
      render json: @data
    end
  end

  #核查处置月份统计
  def disposal_month_statistics 
    @chart = {"s"=>[],"x"=>[],"datas"=>[]} #{"s"=>[[不合格处置数,不合格处置完成数]],"x"=>[名称],"datas"=>[]}
    sp_bsbs = SpBsb.where("sp_s_71 like '%不合格样品%' or sp_s_71 like '%问题样品%'").where(disposal_power)
    if params["time"].present? 
      time = params["time"].split("/")
      sp_bsbs = sp_bsbs.where(sp_d_38:Statistic.time_slot(time[0],time[1])).where(disposal_power(params["area"]))
    end
    sp_bsb_ids = sp_bsbs.map{|s| s.id }
    sp_yydjbs = {}
    wtyp_czb_p = WtypCzbPart.where(sp_bsb_id:sp_bsb_ids).group_by{ |wt| wt.sp_bsb_id }
    SpYydjb.where(id:sp_bsb_ids).each{ |spyy| sp_yydjbs[spyy.id] = spyy }
    sp_bsbs.group_by{ |sp| sp.sp_s_35 }.each do |name,sp_bsb_arr|  
      #1不合格处置数,2不合格处置率,3不合格处置完成数,4异议数,5复检数,6复检不合格数,7立案数
      num1,num2,num3,num4,num5,num6,num7 = [],'',[],[],[],[],[]
      sp_bsb_arr.each do |sp_bsb|
        if wtyp_czb_p.has_key?(sp_bsb.id)
          wtyp_czb_p[sp_bsb.id].each do |wp|
            if params["hj"].blank? 
              if wp.current_state == 1
                num1 << wp.id
              elsif wp.current_state == 3
                num3 << wp.id
              end
              num7 << wp.id if wp.xzcfqk_1 == "是"
            else
              pan = wp.wtyp_czb_type == 1 if params["hj"]=="SC"    
              pan = [2,3].include?(wp.wtyp_czb_type) if params["hj"]=="JY"    
              pan = wp.wtyp_czb_type == 4 if params["hj"]=="WC"    
              if pan
                if wp.current_state == 1
                  num1 << wp.id
                elsif wp.current_state == 3
                  num3 << wp.id
                end
                num7 << wp.id if wp.xzcfqk_1 == "是"
              end
            end
          end
        end
        if sp_yydjbs.has_key?(sp_bsb.id)
          num4 << sp_bsb.id
          if sp_yydjbs[sp_bsb.id] == 0
            num6 << sp_bsb.id 
          elsif sp_yydjbs[sp_bsb.id] == 1
            num5 << sp_bsb.id
          end
        end
      end
      num2 = ((num1.length.to_f/sp_bsb_arr.length)*100).to_i.to_s #不合格处置率
      @chart["s"] << [num1,num3]
      @chart["x"] << [name]
    end
    render json: @chart
  end


  #不合格样品及问题样品预警
  def early_warning
    @data_arr,@data_items,@nonconformity = Statistic.nonconformity.map{ |d| d.to_json }
  end

  #核查处置详情页
  def hccz_particulars
    @data = []
    arr = params["opid"].split(",")
    WtypCzbPart.where(id:arr).each do |wty_czb|
      @data << {"id"=>wty_czb.id,"sp_bsb_id"=>wty_czb.sp_bsb_id,"cjbh"=>wty_czb.cjbh,"present"=>wty_czb.czfzr_desc,"blbm"=>wty_czb.blbm,"blsj"=>wty_czb.blsj.blank? ? "":wty_czb.blsj.strftime("%Y-%m-%d"),"wtyp_czb_type_desc"=>wty_czb.wtyp_czb_type_desc,"ypmc"=>wty_czb.ypmc,"bsscqy_sheng"=>wty_czb.bsscqy_sheng,"bsscqy_shi"=>(wty_czb.sp_s_220 or wty_czb.bsscqy_shi),"bsscqy_xian"=>(wty_czb.sp_s_221 or wty_czb.bsscqy_xian),"bcydw_sheng"=>wty_czb.bcydw_sheng,"bcydw_shi"=>(wty_czb.bcydw_shi or wty_czb.sp_s_4),"bcydw_xian"=>(wty_czb.bcydw_xian or wty_czb.sp_s_5),"bsscqymc"=>wty_czb.bsscqymc,"jyjl"=>wty_czb.jyjl,"yyczzt"=>wty_czb.yydjb.nil? ? "":wty_czb.yydjb.yyczzt,"yyczjg"=>wty_czb.yydjb.blank? ? "未提出异议" : wty_czb.yydjb.yyczjg,"wtyp_date"=>wty_czb.wtyp_date,"qdhcczrq"=>wty_czb.qdhcczrq}
    end
    @data = @data.to_json
    render layout: false
  end

  #异议详情页
  def spyy_particulars
    @data = []
    arr = params["opid"].split(",")
    SpYydjb.where(id:arr).each do |yycz|
      @data << {"id"=>yycz.id,"cjbh"=>yycz.cjbh,"ypmc"=>yycz.ypmc,"scrq"=>yycz.scrq.blank? ? "":(yycz.scrq + 8.hours).strftime("%Y-%m-%d"),"bsscqy"=>yycz.bsscqy,"bsscqysf"=>yycz.bsscqysf,"bsscqys"=>SpBsb.find_by_sp_s_16(yycz.cjbh).blank? ? "" : SpBsb.find_by_sp_s_16(yycz.cjbh).sp_s_220,"bcydw"=>yycz.bcydw,"bcydwsf"=>yycz.bcydwsf,"bcydws"=>SpBsb.find_by_sp_s_16(yycz.cjbh).blank? ? "" : SpBsb.find_by_sp_s_16(yycz.cjbh).sp_s_4,"jyjl"=>yycz.jyjl,"yyczbm"=>yycz.yyczbm,"yyczqk"=>yycz.yyczqk,"yyczjg"=>yycz.yyczjg,"yyfl"=>yycz.yyfl,"jyjl"=>yycz.jyjl,"yyczbm"=>yycz.yyczbm,"yyczfzr"=>yycz.yyczfzr}
    end
    @data = @data.to_json
    render layout: false
  end

  #检验信息详细页
  #[{"id"=>"1","sf"=>"安徽","bcydws"=>"阜阳","rwly"=>"安庆市食品药品监督管理局","cybh"=>"121903","ypmc"=>"大豆油","cydwmc"=>"安庆市食品药品监督管理局","jyjgmc"=>"安庆市检验检测机构01","ypsfqr"=>"样品未确认","tbzt"=>"2"}]
  def particulars
    @data = []
    arr = params["opid"].split(",")
    SpBsb.where(id:arr).each do |sp_bsb|
      @data << {"id"=>sp_bsb.id,"sf"=>sp_bsb.sp_s_3,"bcydws"=>sp_bsb.sp_s_4,"rwly"=>sp_bsb.sp_s_2_1,"cybh"=>sp_bsb.sp_s_16,"ypmc"=>sp_bsb.sp_s_14,"cydwmc"=>sp_bsb.sp_s_35,"jyjgmc"=>sp_bsb.sp_s_43,"ypsfqr"=>sp_bsb.sp_s_214,"tbzt"=>sp_bsb.sp_i_state}
    end
    @data = @data.to_json
    render layout: false
  end

  #生产企业详细页
  def company_particulars 
    @data = []
    arr = params["opid"].split(",")
    SpProductionInfo.where(id:arr).each do |company|
      @data << {"id"=>company.id,"xkzh"=>company.scbh,"fzdw"=>company.fzdw,"qymc"=>company.qymc,"province"=>company.sp_s_3,"city"=>company.sp_s_4,"county"=>company.sp_s_5}
    end
    @data = @data.to_json
    render layout: false
  end

  #单号查询统计
  def sampling_statistics
  end

  #企业覆盖率统计
  #sp_s_64:标示企业名称
  #[{"area":"合肥","zqys":[1,2,3,4,5],"bcqys":[1,2,3,4,5],"fgl":"12"}]
  #{"x":['合肥','芜湖','蚌埠','淮南'],"zqys":[200, 140, 170, 230],"bjqys":[126, 50, 90, 204],"fgl":[63.00, 35.71, 52.94, 88.70]}
  def enterprise_statistics
    @data,@chart = [],{"x"=>[],"zqys"=>[],"bjqys"=>[],"fgl"=>[]}
    power = region_power
    sp_type  = power[2] == 0 ? "sp_s_4":"sp_s_5"
    sp_name  = SpBsb.group("sp_s_64").count
    sp_scbh  = SpBsb.group("sp_s_13").count
    pro_info = SpProductionInfo.where(power[0])
    if params["area"].present?
      pro_info = pro_info.where("#{sp_type}"=>params["area"])
      sp_type = "sp_s_5"
    end
    pro_info.group_by{ |info| info.send(sp_type) }.each do |name,info|
      if name.present?
        sum_num  = info.map(&:id)
        bcqy_arr = []
        info.each do |i|
          if sp_name.has_key?(i.qymc)
            bcqy_arr << i.id
          elsif sp_scbh.has_key?(i.scbh)
            bcqy_arr << i.id
          end
        end
        fgl = ((bcqy_arr.length.to_f/sum_num.length)*100).to_i.to_s 
        @data << {"area"=>name,"zqys"=>sum_num,"bcqys"=>bcqy_arr,"fgl"=>fgl}  
        @chart["x"] << name
        @chart["zqys"] << sum_num.length
        @chart["bjqys"] << bcqy_arr.length
        @chart["fgl"] << fgl
      end
    end
    send_file(DownloadStatistics.enterprise("Statistic::Enterprise",@data), :disposition => "attachment") and return if params["is_export"] == "1"
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

  #退休统计
  #0 表格  1 图表
  def retirement_statistics
    @data = {"chouyang"=>[],"chengjian"=>[]} #{"chouyang" =>[{"area"=>"瑶海","cyjg"=>"zhangsan","txsl"=>"10","txl"=>"12"}]}
    power = region_power
    sp_type = power[2] == 0 ? "sp_s_4":"sp_s_5"
    sp_bsbs  = SpBsb.where(sp_i_state:9).admin_select(power[0])
    if params["time"].present? && params["area"].present?
      time = params["time"].split("/") 
      sp_bsbs = sp_bsbs.where(sp_d_38:Statistic.time_slot(time[0],time[1]),"#{sp_type}"=>params["area"])
      sp_type = "sp_s_5"
    end
    revision = RevisionLog.where(sp_bsb_id: sp_bsbs.map{|s|s.id}).group_by{ |r| r.sp_bsb_id}
    packet = sp_bsbs.group_by{ |sp| sp.send(sp_type) }
    @chart = Statistic.retirement(packet,revision) 
    packet.each do |county_name,sp_bsb_arr|
      region  = county_name   
      sp_bsb_arr.group_by{ |sp| sp.sp_s_35 }.each do |cy_jg,cy_arr| #抽样单位
        jg_name = cy_jg
        completely    = cy_arr.map(&:id)
        revision_num  = []
        cy_arr.each{ |spbsb| revision_num.concat revision[spbsb.id].map(&:sp_bsb_id) if revision.has_key?(spbsb.id) } 
        revision_rate = ((revision_num.length.to_f/completely.length)*100).to_i.to_s 
        @data["chouyang"] << {"area"=>region,"cyjg"=>jg_name,"txsl"=>revision_num,"txl"=>revision_rate}
      end
      sp_bsb_arr.group_by{ |sp| sp.sp_s_43 }.each do |cj_jg,cj_arr| #承检单位
        jg_name = cj_jg
        completely    = cj_arr.map(&:id)
        revision_num  = []
        cj_arr.each{ |spbsb| revision_num.concat revision[spbsb.id].map(&:sp_bsb_id) if revision.has_key?(spbsb.id) } 
        revision_rate = ((revision_num.length.to_f/completely.length)*100).to_i.to_s 
        @data["chengjian"] << {"area"=>region,"cyjg"=>jg_name,"txsl"=>revision_num,"txl"=>revision_rate}
      end
    end
    if params["is_export"] == "1"
      send_file(DownloadStatistics.retirement("Statistic::Retirement",@data), :disposition => "attachment")
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
      @q = SpBsb.send(params[:q]["sp_s_71"]=="合格" ? :qualified : :unqualified) if params[:q]["sp_s_71"].present?
      @q = (@q.nil? ? SpBsb : @q).where(sp_d_38:Statistic.time_slot(params[:q]["created_at_start"],params[:q]["created_at_end"])) if params[:q]["created_at_start"].present? 
      @q = @q.nil? ? SpBsb.ransack(params[:q]) : @q.ransack(params[:q])
    else
      @q = SpBsb.ransack(params[:q])
    end
    @products = @q.result(distinct: true)
    @data = []
    power = region_power
    sp_bsbs = @products.admin_select(power[0]).group_by{ |sp| sp.send(power[1]) }
    sp_bsbs.each do |city_name,city_arr| #sp_arr:每个市
      county_sp = power[1]=="sp_s_4" ? city_arr.group_by{ |sp| sp.sp_s_5 } : sp_bsbs
      county_result = []
      county_sp.each do |count_name,county_arr| #arr:每个县
        #0地区,1总批次,2监督抽检批次,3合格批次,4不合格批次,5不合格样品率,6风险检测批次,7问题样品批次,8问题样品率
        num0,num1,num2,num3,num4,num5,num6,num7,num8='',[],[],[],[],'',[],[],''
        num0 = count_name
        num1 = county_arr.map(&:id)
        county_arr.each do |sp| 
          if sp.sp_s_44 == "监督抽检"
            num2 << sp.id 
            num4 << sp.id if /不合格样品|问题样品/ =~ sp.sp_s_71 #不合格批次
          elsif sp.sp_s_44 == "风险监测"
            num6 << sp.id
            num7 << sp.id if /不合格样品|问题样品/ =~ sp.sp_s_71 #问题样品批次
          end
          num3 << sp.id if (/^((?!监测问题样品).)*$/ =~ sp.sp_s_71) && (/([^不]合格)/ =~ sp.sp_s_71) #合格批次
        end
        #num3 = (num1-num4)-num7 #合格批次
        num5 = ((num4.length.to_f/num1.length)*100).to_i.to_s+"%" #不合格样品率
        num8 = ((num7.length.to_f/num1.length)*100).to_i.to_s+"%" #问题样品率
        county_result << {name: num0,totalbat:num1,samplingbat:num2,qualifiedbat:num3,unqualifiedbat:num4,qualifiedsamp:num5,riskbat:num6,problembat:num7,problemsamp:num8}
      end
      #如果是省市管理员:合计该市的信息
      if power[1]=="sp_s_4"
        num1,num2,num3,num4,num5,num6,num7,num8 = [],[],[],[],'',[],[],''
        county_result.each do |c| 
          num1.concat c[:totalbat]
          num2.concat c[:samplingbat]
          num3.concat c[:qualifiedbat]
          num4.concat c[:unqualifiedbat]
          num6.concat c[:riskbat]
          num7.concat c[:problembat]
        end
        num5 = ((num4.length.to_f/num1.length)*100).to_i.to_s+"%"
        num8 = ((num7.length.to_f/num1.length)*100).to_i.to_s+"%"
        @data << {name: city_name,totalbat:num1,samplingbat:num2,qualifiedbat:num3,unqualifiedbat:num4,qualifiedsamp:num5,riskbat:num6,problembat:num7,problemsamp:num8,children:county_result}
      else
        @data = county_result
      end
    end
    if params["is_export"] == "1"
      send_file(DownloadStatistics.composite("Statistic::Composite",@data), :disposition => "attachment")
    end
    @data = @data.to_json
  end

  def region_power
    return "","sp_s_4",0 if is_sheng? 
    return "sp_s_4 = '#{current_user.prov_city}'","sp_s_4",1 if is_city? 
    return "sp_s_5 = '#{current_user.prov_country}'","sp_s_5",2 if is_county_level? 
  end

  def disposal_power(region=nil)
    if region.blank?
      return "" if is_sheng? 
      return "sp_s_4='#{current_user.prov_city}' or sp_s_wcshi='#{current_user.prov_city}' or sp_s_220='#{current_user.prov_city}'" if is_city? 
      return "sp_s_5='#{current_user.prov_country}' or sp_s_wcxian='#{current_user.prov_country}' or sp_s_221='#{current_user.prov_country}'" if is_county_level? 
    else
      return "sp_s_4='#{region}' or sp_s_wcshi='#{region}' or sp_s_220='#{region}'" if is_sheng?
      return "sp_s_5='#{region}' or sp_s_wcxian='#{region}' or sp_s_221='#{region}'" if is_city? or is_county_level? 
    end
  end

  def unit_power
    return "city != '-请选择-' and jg_province = '#{current_user.user_s_province}'","city" if is_sheng?
    return "city = '#{current_user.prov_city}'","city" if is_city?
    return "country = '#{current_user.prov_country}'","country" if is_county_level?
  end 

  def nonconformity_power
    region = {}
    code_h = Statistic::Daily["region"].to_h
    return code_h,code_h.first if is_sheng?
    name = code_h.has_key?(current_user.prov_city+"市") ? current_user.prov_city+"市" : current_user.prov_city
    region[name] = code_h[name] if code_h.has_key?(name)
    return region,region.first if is_city?
    region[current_user.prov_country] = ""
    return region,region.first
  end
end
