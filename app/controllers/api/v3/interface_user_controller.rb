class Api::V3::InterfaceUserController < ApplicationController
  skip_before_filter :session_expiry, :verify_authenticity_token, :authenticate_user!

	def new_user
		if params[:user_name].present?
      @logger = Logger.new("log/shianyun_new_user.log")
      @logger.info params
      @logger.info "-"*100
			user = User.find_by_ca_uuid(params[:user_name])
      config_province = SysConfig.get(SysConfig::Key::PROV)
      if params[:jg_type] == 1 && params[:user_s_province] != config_province
        render json: { status: 0, msg: "该#{config_province}二级站不允许注册其他省份用户"} and return
      end

			if user.nil?
				user = User.new(ca_uuid: params[:user_name],password: "123456789",uid:params[:user_name])
      end

			params.each do |field, value|
				if user.respond_to?(field)
				  user.send("#{field}=", value)
        end
			end

      jg_bsb = JgBsb.find_by_uuid(params["jg_bsb_id"])
      if jg_bsb.nil?
        render json: { status: 0, msg: "查无机构"} and return
      else
        user.jg_bsb_id = jg_bsb.id
      end

      
      # uid赋值
      #hash = user.api_generate_uid
      #if hash["type"]
      #  user.uid = hash["msg"]
      #else
      #  render json: { status: 0, msg: hash["msg"]} and return
      #end

			if user.save
				render json: { status: 1, msg: ""}
			else
        p user.errors
				render json: { status: 0, msg: user.errors.first.last }
			end
		else
			render json: { status: 0, msg: "没有user_name值"}
		end
	end

  def update_user_uuid
    if params["uid"].present? && params["ca_uuid"].present?
      user = User.find_by_uid(params["uid"]) 
		  if user.nil?
        render json: { status: 0, msg: "查无用户" }
      else
        user.ca_uuid = params["ca_uuid"]
        if user.save
          render json: { status: 1, msg: ""}
        else
          render json: {status: 0, msg: user.errors.first }
        end
      end
    else
      render json: { status: 0, msg: "没有值"}
    end
  end
end
