class Statistic < ActiveRecord::Base
  Task = ["区域","任务数","抽样数","检验数","不合格数","合格数","已处置","处置中"] 
  Food = ["名称", "序号", "任务数", "抽样数", "检验数", "不合格数", "合格数", "已处置", "处置中"]
  Nonconformity = ["市","检验不合格项目","不合格批次"]
  Unit = ["地区", "序号", "任务数", "接样数", "合格数", "不合格数", "已处置", "处置中"]
  Overtime = ["抽样单位","天数"]
  Disposal = ["序号", "处置单位", "处置环节", "不合格处置数", "不合格处置率", "不合格处置完成数", "不合格处置完成率", "异议数", "复检数", "复检不合格数", "立案数"]
  Enterprise = ["序号", "区域", "总企业数", "被抽样单位数", "覆盖率"]
  EarlyWarning = ["序号", "区域", "被抽样单位", "生产企业", "样品名称", "任务来源", "报送分类a", "报送分类b", "大类", "次亚类", "亚类", "细类"]
  Composite = ["地区", "序号", "总批次", "监督抽检批次", "合格批次", "不合格批次", "不合格样品率", "风险检测批次", "问题样品批次", "问题样品率"]

  def self.time_slot(start_time,end_time)
    Time.parse(start_time+"-01")..Time.parse(end_time+"-31").end_of_day
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

  def self.nonconformity
    sp_bsbs = SpBsb.where("sp_i_state = 9 AND (sp_s_71 like '%不合格样品%' or sp_s_71 like '%问题样品%')").includes(:spdata)
    data_arr = []
    data_items = {"安徽省" => {}}
    detailed = {"安徽省" => []}
    city = sp_bsbs.where("sp_s_4 != '请选择'")
    county = sp_bsbs.where("sp_s_5 != '请选择'")
    #地图各省数据
    city.group(:sp_s_4).count.each{ |k,y| data_arr << {"name" => k+"市","value" => y} } 
    county.group(:sp_s_5).count.each{ |k,y| data_arr << {"name" => k,"value" => y}}
    #各省不合格项目
    city.group_by{ |c| c.sp_s_4 }.each do |key,sp_bsbs|
      name = key+"市"
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

  def self.admin_info
    return "1",current_user.user_s_province if is_sheng? 
    return "2",current_user.prov_city if is_city? 
    return "3",current_user.prov_country if is_county_level? 
  end
end
