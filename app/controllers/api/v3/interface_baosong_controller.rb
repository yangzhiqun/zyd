class Api::V3::InterfaceBaosongController < ApplicationController
 skip_before_filter :session_expiry, :verify_authenticity_token, :authenticate_user! 
 
 ActiveRecordName = {"BaosongA"=>"baosong_as", "BaosongB"=>"baosong_bs", "ACategory"=>"a_categories", "BCategory"=>"b_categories", "CCategory"=>"c_categories", "DCategory"=>"d_categories", "CheckItem"=>"check_item"}
 
 def baosong_sync
   render json: {status: 0, msg: '参数为空'} and return if params["baosong_as"].blank? || params["baosong_bs"].blank? || params["a_categories"].blank? || params["b_categories"].blank? || params["c_categories"].blank? || params["d_categories"].blank? || params["check_item"].blank?
   logger.info params
   @logger = Logger.new("log/shianyun_baosongfenlei.log") 
   @logger.info params
   begin
     ActiveRecord::Base.transaction do
       if params["type"] == "add"
         @type_name = {}
         # 报送分类Ａ
         baosong_a_id = create_baosong("BaosongA")
         # 报送分类Ｂ
         baosong_b_id = create_baosong("BaosongB", baosong_a_id)
         # 大类
         @type_name = create_obj("ACategory", @type_name) 
         # 亚类
         @type_name = create_obj("BCategory", @type_name) 
         # 次亚类
         @type_name = create_obj("CCategory", @type_name) 
         # 细类
         @type_name = create_obj("DCategory", @type_name) 
         ## 检验项目
         create_obj("CheckItem", @type_name) 
       elsif params["type"] == "update"
         update_obj       
       end
     end
     @logger.info ">>>>>成功<<<<<"
     render json: { status: 1, msg: "全部完成" }
   rescue => e
     @logger.error "ERROR: #{$!}"
     @logger.error e.class.to_s
     @logger.info "-"*150
     render json: { status: 0, msg: "#{$!}" }
   end
 end
  
 # 创建报送分类A.B
 def create_baosong(name,baosong_a_id=nil)
   if name == "BaosongA"
     obj = BaosongA.find_by_name(params["baosong_as"]["name"])
   else
     obj = BaosongB.where(baosong_a_id:baosong_a_id,name:params["baosong_bs"]["name"]).first
   end
   if obj.nil?
     obj = name.constantize.new()
   end
   params[ActiveRecordName["#{name}"]].each do |field, value|
     if obj.respond_to?(field)
       obj.send("#{field}=", value)
     end
   end
   obj.baosong_a_id = baosong_a_id if name == "BaosongB"
   obj.save!
   obj.id
 end
 
 # 创建四大类和检验项目
 def create_obj(name,type_name)
   params[ActiveRecordName["#{name}"]].each do |category|
     obj = name.constantize.new() 
     category.each do |field, value|
       if obj.respond_to?(field)
         obj.send("#{field}=", value)
       end
     end
     case name 
       when "BCategory"
         obj.a_category_id = type_name[category["a_category"]]
       when "CCategory"  
         obj.a_category_id = type_name[category["a_category"]]
         obj.b_category_id = type_name[[category["a_category"],category["b_category"]].join("-")]
       when "DCategory"  
         obj.a_category_id = type_name[category["a_category"]] 
         obj.b_category_id = type_name[[category["a_category"],category["b_category"]].join("-")]
         obj.c_category_id = type_name[[category["a_category"],category["b_category"],category["c_category"]].join("-")]
       when "CheckItem"  
         obj.a_category_id = type_name[category["a_category"]]
         obj.b_category_id = type_name[[category["a_category"],category["b_category"]].join("-")]
         obj.c_category_id = type_name[[category["a_category"],category["b_category"],category["c_category"]].join("-")]
         obj.d_category_id = type_name[[category["a_category"],category["b_category"],category["c_category"],category["d_category"]].join("-")] 
     end
     obj.save!
     case name 
       when "ACategory"
         hash_key = category["name"]
       when "BCategory"
         hash_key = [category["a_category"],category["name"]].join("-")
       when "CCategory"  
         hash_key = [category["a_category"],category["b_category"],category["name"]].join("-")
       when "DCategory"  
         hash_key = [category["a_category"],category["b_category"],category["c_category"],category["name"]].join("-")
     end
     unless type_name.has_key?(hash_key)
       type_name[hash_key] = obj.id
     else
       raise "#{hash_key} >> 重复!" 
     end
   end
   type_name
 end

 def update_obj
   data = params["check_item"]
   baosong_b = BaosongA.find_by_name(params["baosong_as"]["name"]).baosong_bs.find_by_identifier(params["baosong_bs"]["identifier"])
   b_category = baosong_b.a_categories.find_by_name(data["a_category"]).b_categories.find_by_name(data["b_category"])
   c_category = CCategory.where(b_category_id: b_category.id, name: data["c_category"]).first
   d_category = DCategory.where(c_category_id: c_category.id, name: data["d_category"]).first
   check_item = CheckItem.where(d_category_id: d_category.id, name: data["name"]).first
   data.each do |field, value|
     if check_item.respond_to?(field)
       check_item.send("#{field}=", value)
     end
   end
   data.save!
 end
end
