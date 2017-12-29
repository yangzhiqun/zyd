class Statistic < ActiveRecord::Base
  Task = ["区域","抽样数","检验数","不合格数","合格数","已处置","处置中"] 
  Food = ["名称","抽样数", "检验数", "不合格数", "合格数", "已处置", "处置中"]
  Nonconformity = ["区域", "抽样单号", "样品名称", "检验项目", "大类", "亚类", "次亚类", "细类"]
  Unit = ["地区", "接样数", "合格数", "不合格数", "已处置", "处置中"]
  Overtime = ["抽样单位","天数"]
  Disposal = ["处置单位", "不合格处置数", "不合格处置率", "不合格处置完成数", "异议数", "复检数", "复检不合格数", "立案数"]
  Sampling = ["单号", "不合格项名称", "样品名称", "区域", "大类", "亚类", "次亚类", "细类"]
  Enterprise = ["区域", "总企业数", "被抽样单位数", "覆盖率"]
  EarlyWarning = ["序号", "区域", "被抽样单位", "生产企业", "样品名称", "任务来源", "报送分类a", "报送分类b", "大类", "次亚类", "亚类", "细类"]
  Retirement = ["区域","抽样机构名称","完全提交退修数","完全提交退修率"]
  Composite = ["地区", "总批次", "监督抽检批次", "合格批次", "不合格批次", "不合格样品率", "风险检测批次", "问题样品批次", "问题样品率"]
  Corr = {1=>"sp_s_70",1=>"sp_s_67",2=>"sp_s_17",3=>"sp_s_18",4=>"sp_s_19",5=>"sp_s_20"}
  Daily = YAML.load_file("config/anhui_map.yml")
  
  def self.time_slot(start_time,end_time)
    Time.parse(start_time+"-01")..Time.parse(end_time+"-31").end_of_day
  end

  def self.time_ranges(start_time,end_time)
    all_range = (start_time.to_date..end_time.to_date).map(&:to_s)
    num = 0
    (all_range-Daily["jie_time"]).each do |range|
      num += 1 if (1..5).include?(range.to_date.wday) || Daily["dao_time"].include?(range)
    end
    return num
  end

  def self.retirement(sp_bsbs,revision)
    chart = {"x"=>[], "y1"=>[], "y2"=>[]} #{"x"=>["合肥", "芜湖", "蚌埠"], "y1"=>[200, 140, 170], "y2"=>[63.0, 35.71, 52.94]}
    sp_bsbs.each do |county_name,sp_bsb_arr|
      completely    = sp_bsb_arr.length
      revision_num  = 0
      sp_bsb_arr.each{ |spbsb| revision_num += revision[spbsb.id].length if revision.has_key?(spbsb.id) } 
      revision_rate = ((revision_num.to_f/completely)*100).to_i.to_s 
      chart["x"]  << county_name           
      chart["y1"] << revision_num
      chart["y2"] << revision_rate
    end
    return chart
  end 

  def self.nonconformity(sp_bsbs)
    sheng = SysConfig.get(SysConfig::Key::PROV)+"省"
    sp_bsbs = sp_bsbs.unqualified.includes(:spdata)
    data_arr = []
    data_items = {sheng => {}}
    detailed = {sheng => []}
    city = sp_bsbs.where("sp_s_4 != '请选择'")
    county = sp_bsbs.where("sp_s_5 != '请选择'")
    #地图各省数据
    city.group(:sp_s_4).count.each{ |k,y| data_arr << {"name" => k =~ /市/ ? key : k+"市","value" => y} } 
    county_arr = Daily["total"]
    county.group(:sp_s_5).count.each do |k,y|
      k = k+"市" if county_arr.include?(k+"市")
      k = k+"县" if county_arr.include?(k+"县")
      k = k+"区" if county_arr.include?(k+"区")
      data_arr << {"name" => k,"value" => y}
    end
    #各省不合格项目
    city.group_by{ |c| c.sp_s_4 }.each do |key,sp_bsbs|
      name = key =~ /市/ ? key : key+"市"
      data_items[name] = {}
      detailed[name]   = []
      sp_bsbs.each do |sp|
        sp.spdata.each do |data| 
          if data.spdata_2 == "不合格项" or data.spdata_2 == "问题项"
            data_items[name].has_key?(data.spdata_0) ? data_items[name][data.spdata_0]<< sp.id : data_items[name][data.spdata_0]=[sp.id] 
            data_items[sheng].has_key?(data.spdata_0) ? data_items[sheng][data.spdata_0]<< sp.id : data_items[sheng][data.spdata_0]=[sp.id] 
            hash = {"area"=>name,"dh"=>sp.sp_s_16,"bcydw"=>sp.sp_s_1,"scqy"=>sp.sp_s_64,"rwly"=>sp.sp_s_2_1,"ypmc"=>sp.sp_s_14,"jyxm"=>data.spdata_0,"dl"=>sp.sp_s_17,"yl"=>sp.sp_s_18,"cyl"=>sp.sp_s_19,"xl"=>sp.sp_s_20}
            detailed[name] << hash
            detailed[sheng] << hash
          end
        end
      end
    end
    [data_arr,data_items,detailed]
  end

  def self.food(products,type)
    wtyp_czb_p = WtypCzbPart.where(sp_bsb_id:products.unqualified.map{ |p| p.id }).group_by{ |wt| wt.sp_bsb_id }
    data = []
    products.group_by{ |a| a.send(type) }.each do |name,sp_bsbs|
      #抽样数 检验数 不合格数 合格数 已处置 处置中
      num1,num2,num3,num4,num5,num6 = [],[],[],[],[],[] 
      num1 = sp_bsbs.map(&:id)
      sp_bsbs.each do |s|
        if s.sp_i_state == 9
          num2 << s.id 
          num3 << s.id if s.sp_s_71 =~ /不合格样品|问题样品/
          wtyp_czb_p[s.id].each do |w|
            if [1,2].include? w.current_state
              num6 << w.id
            elsif w.current_state == 3
              num5 << w.id
            end
          end if wtyp_czb_p.has_key?(s.id)
        end
        num4 << s.id if (/^((?!监测问题样品).)*$/ =~ s.sp_s_71) && (/([^不]合格)/ =~ s.sp_s_71) #合格批次
      end
      data << {"name"=>name, "sampling"=>num1,"test"=>num2,"unqualified"=>num3,"qualified"=>num4,"Disposed"=>num5,"Disposal"=>num6}
    end
    return data
  end

  #{"x":['合肥','芜湖','蚌埠','淮南','马鞍山','淮北','铜陵','安庆','黄山','滁州','阜阳','宿州','六安市'],"y":{"hclq":[200, 140, 170, 230, 245, 176, 135, 162, 132, 120, 160, 130,140],"hcwc":[63, 35, 52, 88, 84, 43, 56, 50, 35, 73, 37, 94,42],"yycq":[6, 5, 5, 8, 4, 3, 6, 0, 5, 7, 17, 4,14]}}
  class << self
    include ApplicationHelper
    def overtime(sp_bsbs,city)
      unqualified = sp_bsbs.unqualified
      unqualified_ids = unqualified.map(&:id)
      wtyp_czb_p = WtypCzbPart.where(sp_bsb_id:unqualified_ids).group_by{ |wt| wt.sp_bsb_id } 
      wtyp_czb_logs = WtypCzbPartLogs.where(sp_bsb_id:unqualified_ids).group_by{ |wt| wt.sp_bsb_id }
      sp_yy_ids = SpYydjb.all.map(&:id)
      sp_logs = SpLog.where(sp_bsb_id:unqualified_ids).group_by{ |sp| sp.sp_bsb_id } 
      city_arr = overtime_start({"x"=>[],"y"=>{"hclq"=>[],"hcwc"=>[],"yycq"=>[]}},unqualified,wtyp_czb_p,wtyp_czb_logs,sp_yy_ids,sp_logs,city)
      company = {}
      unqualified.group_by{ |sp| sp.send(city) }.each do |company_name,company_arr|
        company[company_name] = overtime_start({"x"=>[],"y"=>{"hclq"=>[],"hcwc"=>[],"yycq"=>[]}},company_arr,wtyp_czb_p,wtyp_czb_logs,sp_yy_ids,sp_logs,"sp_s_35") 
      end
      return city_arr,company
    end

    def overtime_start(overdue,unqualified,wtyp_czb_p,wtyp_czb_logs,sp_yy_ids,sp_logs,city)
      unqualified.group_by{ |sp| sp.send(city) }.each do |city_name,city_arr|
        hclq,hcwc,yycq = 0,0,0
        overdue["x"] << city_name
        city_arr.each do |sp_chaoqi|
          #核查领取超期
          wtyp_czb_p[sp_chaoqi.id].reverse_each do |wty|
            if wty.current_state == 1
              sp_logs[sp_chaoqi.id].reverse_each do |log|
                if log.sp_i_state == 9
                  hclq+=1 if days_between(Time.now,log.created_at) > 7
                  break 
                end
              end
              break
            end
          end 
          #处置完成超期
          if wtyp_czb_logs.has_key?(sp_chaoqi.id)
            wtyp_czb_logs[sp_chaoqi.id].reverse_each do |log|
              if log.wtyp_czb_state != 3
                hcwc+=1 if days_between(Time.now,log.created_at) > 90
                break
              end
            end
          end
          #异议超期
          if sp_yy_ids.include?(sp_chaoqi.id) 
            sp_logs[sp_chaoqi.id].reverse_each do |log|
              if log.sp_i_state == 9
                yycq+=1 if days_between(Time.now,log.created_at) > 7
                break
              end
            end
          end
        end
        overdue["y"]["hclq"] << hclq
        overdue["y"]["hcwc"] << hcwc
        overdue["y"]["yycq"] << yycq
      end
      return overdue
    end
  end
end
