class Api::V3::InterfaceJgController < ApplicationController
  skip_before_filter :session_expiry, :verify_authenticity_token, :authenticate_user!

	def handing_jg_bsb
		if params["uuid"].present? 
			jg_bsb = JgBsb.find_by_uuid(params["uuid"])
      is_jg_bsb = false

			if jg_bsb.nil?
				jg_bsb = JgBsb.new(uuid: params["uuid"])
        is_jg_bsb = true
      end

			params.each do |field, value|
				if jg_bsb.respond_to?(field)
				  jg_bsb.send("#{field}=", value)
        end
			end

			if jg_bsb.save
        # 处理jg_name  机构名称是否改变 1：改变 0：未改变
        if params["isNameChange"] == 0 && is_jg_bsb 
          JgBsbName.create(name: params["jg_name"], jg_bsb_id: JgBsb.find_by_uuid(params["uuid"]).id) 
        elsif params["isNameChange"] == 1 
          jg_names = JgBsbName.where(name: params["jg_name"])
          if jg_names.count == 0
            JgBsbName.create(name: params["jg_name"], jg_bsb_id: JgBsb.find_by_uuid(params["uuid"]).id)
          else
            jg_names.each do |name|
              if params["jg_name"] == name.name 
                name.update_attributes(updated_at:Time.new)
              end
            end
          end
        end
				render json: { status: 1, msg: "" }
      else
				render json: { status: 0, msg: jg_bsb.errors.first.last }
			end
		else
			  render json: { status: 0, msg: "没有uuid值" }
		end
  end

  def handing_jgbsb_super
    # type字段为机构关系操作类型 0：取消关系  1：建立关系
		if params["jg_bsb_uuid"].present? && params["super_jg_bsb_uuid"]
      jg_bsb   = JgBsb.find_by_uuid(params["jg_bsb_uuid"]) 
      super_jg = JgBsb.find_by_uuid(params["super_jg_bsb_uuid"])
      if jg_bsb && super_jg
        if params["type"] == 0
          jg_bsb_super = JgBsbSuper.new(:jg_bsb_id => jg_bsb.id, :super_jg_bsb_id => super_jg.id)
          if jg_bsb_super.save 
				    render json: { status: 1, msg: "" }
          else
				    render json: { status: 0, msg: jg_bsb.errors.first.last }
          end
        elsif params["type"] == 1
          jg_bsb_super = JgBsbSuper.where(jg_bsb_id: jg_bsb.id, super_jg_bsb_id: super_jg.id).first
          if jg_bsb_super.present?
            jg_bsb_super.detete and render json: { status: 1, msg: "" }
          else
            render json: { status: 0, msg: "查无机构关系" }
          end
        end
      else
        render json: { status: 0, msg: "jg_bsb_supers中查不到本级机构" } if jg_bsb.blank?
        render json: { status: 0, msg: "jg_bsb_supers中查不到上级机构" } if super_jg.blank?
      end
		else
				render json: { status: 0, msg: "jg_bsb_uuid或者super_jg_bsb_uuid没有值" }
    end
  end

  def handing_jgbsb_stamps
		#if params["jg_bsb_stamps"].present? 
    #  
    #  params["jg_bsb_stamps"].each do |jg_bsb_stamps|
		#	  jg_bsb = JgBsb.find_by_uuid(jg_bsb_stamps["jg_bsb_uuid"])
		#	  if jg_bsb.nil?
    #      @result["error"] << { "status" => 0, "msg" => "jg_bsb_stamps中#{jg_bsb_stamps["jg_bsb_uuid"]}不存在" }
    #    else
    #      stamp = JgBsbStamp.new(:jg_bsb_id => jg_bsb.id)
		#	    jg_bsb_stamps.each do |field, value|
		#	    	if stamp.respond_to?(field)
		#	    	  stamp.send("#{field}=", value)
    #        end
		#	    end
    #      if stamp.save
    #        @result["success"] << { "status" => 1, "msg" => "jg_bsb_stamps#{jg_bsb_stamps["jg_bsb_uuid"]}保存成功" }
    #      else
		#	      @result["error"] << { "status" => 0, "msg" => "jg_bsb_stamps#{jg_bsb_stamps["jg_bsb_uuid"]}保存失败:+#{stamp.errors.first.last.to_s}"}
    #      end
    #    end
    #  end
		#else
		#	  @result["error"] << { "status" => 0, "msg" => "jg_bsb_stamps没有值" }
		#end

    #if @result["error"].length == 0
    #  render json: { status: 1, msg: ""} 
    #else
    #  render json: { status: 0, msg: "#{@result["success"] + @result["error"]}"} 
    #end
	end
end
