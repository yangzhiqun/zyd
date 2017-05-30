class Api::V3::InterfaceJgController < ApplicationController
  skip_before_filter :session_expiry, :verify_authenticity_token, :authenticate_user!

	def new_jg
    @result = {"error" => [], "success" => []}

    @logger = Logger.new("log/shianyun_new_jg.log")
    @logger.info params
    @logger.info "-"*100

    # 保存jg_bsb
		if params["jg_bsbs"].present? 
			jg_bsb = JgBsb.find_by_uuid(params["jg_bsbs"]["uuid"])
			if jg_bsb.nil?
				jg_bsb = JgBsb.new(ca_uuid: params["jg_bsbs"]["uuid"])
      end

			params["jg_bsbs"].each do |field, value|
				if jg_bsb.respond_to?(field)
				  jg_bsb.send("#{field}=", value)
        end
			end

			if user.save
        @result["success"] << { "status" => 1, "msg" => "jg_bsb保存成功" } 
      else
				@result["error"] << { "status" => 0, "msg" => user.errors.first.last }
			end
		else
			  @result["error"] << { "status" => 0, "msg" => "jg_bsb没有值" }
		end

    # 保存 jg_bsb_supers
		if params["jg_bsb_supers"].present? 
      jg_bsb   = JgBsb.find_by_uuid(params["jg_bsb_supers"]["jg_bsb_uuid"]) 
      super_jg = JgBsb.find_by_uuid(params["jg_bsb_supers"]["super_jg_bsb_uuid"])
      if jg_bsb && super_jg
        jg_bsb_super = JgBsbSuper.new(:jg_bsb_id => jg_bsb.id, :super_jg_bsb_id => super_jg.id)
        if jg_bsb_super.save 
          @result["success"] << { "status" => 1, "msg" => "jg_bsb_supers保存成功" }
        else
           @result["error"] << { "status" => 0, "msg" => jg_bsb_super.errors.first.last } 
        end
      else
        @result["error"] << { "status" => 0, "msg" => "jg_bsb_supers中查不到本级机构" } if jg_bsb.blank?
        @result["error"] << { "status" => 0, "msg" => "jg_bsb_supers中查不到上级机构" } if super_jg.blank?
      end
		else
			  @result["error"] << { "status" => 0, "msg" => "jg_bsb_supers没有值"}
    end

    # 保存 jg_bsb_stamps
		if params["jg_bsb_stamps"].present? 
      
      params["jg_bsb_stamps"].each do |jg_bsb_stamps|
			  jg_bsb = JgBsb.find_by_uuid(jg_bsb_stamps["jg_bsb_uuid"])
			  if jg_bsb.nil?
          @result["error"] << { "status" => 0, "msg" => "jg_bsb_stamps中#{jg_bsb_stamps["jg_bsb_uuid"]}不存在" }
        else
          stamp = JgBsbStamp.new(:jg_bsb_id => jg_bsb.id)
			    jg_bsb_stamps.each do |field, value|
			    	if stamp.respond_to?(field)
			    	  stamp.send("#{field}=", value)
            end
			    end
          if stamp.save
            @result["success"] << { "status" => 1, "msg" => "jg_bsb_stamps#{jg_bsb_stamps["jg_bsb_uuid"]}保存成功" }
          else
			      @result["error"] << { "status" => 0, "msg" => "jg_bsb_stamps#{jg_bsb_stamps["jg_bsb_uuid"]}保存失败:+#{stamp.errors.first.last.to_s}"}
          end
        end
      end
		else
			  @result["error"] << { "status" => 0, "msg" => "jg_bsb_stamps没有值" }
		end

    if @result["error"].length == 0
      render json: { status: 1, msg: ""} 
    else
      render json: { status: 0, msg: "#{@result["success"] + @result["error"]}"} 
    end
	end
end
