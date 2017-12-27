class Statistic < ActiveRecord::Base
  Task = ["区域","抽样数","检验数","不合格数","合格数","已处置","处置中"] 
  Food = ["名称","抽样数", "检验数", "不合格数", "合格数", "已处置", "处置中"]
  Nonconformity = ["区域", "抽样单号", "样品名称", "检验项目", "大类", "亚类", "次亚类", "细类"]
  Unit = ["地区", "序号", "任务数", "接样数", "合格数", "不合格数", "已处置", "处置中"]
  Overtime = ["抽样单位","天数"]
  Disposal = ["处置单位", "不合格处置数", "不合格处置率", "不合格处置完成数", "异议数", "复检数", "复检不合格数", "立案数"]
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
    range = (start_time.to_date..end_time.to_date).to_a.map(&:to_s)
    return range-Daily["time"]
  end

  def self.retirement(sp_bsbs,revision)
    chart = {"x"=>[], "y1"=>[], "y2"=>[]} #{"x"=>["合肥", "芜湖", "蚌埠"], "y1"=>[200, 140, 170], "y2"=>[63.0, 35.71, 52.94]}
    sp_bsbs.each do |county_name,sp_bsb_arr|
      completely    = sp_bsb_arr.length
      revision_num  = 0
      sp_bsb_arr.each{ |spbsb| revision_num += revision[spbsb.id].length if revision.has_key?(spbsb.id) } 
      revision_rate = ((revision_num.to_f/completely)*100).to_i.to_s 
      chart["x"]  << county_name           
      chart["y1"] << completely
      chart["y2"] << revision_rate
    end
    return chart
  end 

  def self.nonconformity(sp_bsbs)
    sp_bsbs = sp_bsbs.where("sp_i_state = 9 AND (sp_s_71 like '%不合格样品%' or sp_s_71 like '%问题样品%')").includes(:spdata)
    data_arr = []
    data_items = {"安徽省" => {}}
    detailed = {"安徽省" => []}
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
          if data.spdata_2 == "不合格项"
            data_items[name].has_key?(data.spdata_0) ? data_items[name][data.spdata_0]+=1 : data_items[name][data.spdata_0]=1   
            data_items["安徽省"].has_key?(data.spdata_0) ? data_items["安徽省"][data.spdata_0]+=1 : data_items["安徽省"][data.spdata_0]=1 
            hash = {"area"=>name,"dh"=>sp.sp_s_16,"bcydw"=>sp.sp_s_1,"scqy"=>sp.sp_s_64,"rwly"=>sp.sp_s_2_1,"ypmc"=>sp.sp_s_14,"jyxm"=>data.spdata_0,"dl"=>sp.sp_s_17,"yl"=>sp.sp_s_18,"cyl"=>sp.sp_s_19,"xl"=>sp.sp_s_20}
            detailed[name] << hash
            detailed["安徽省"] << hash
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
end
