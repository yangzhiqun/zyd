class Api::V3::InterfaceUserController < ApplicationController
  skip_before_filter :session_expiry, :verify_authenticity_token, :authenticate_user!

	def new_user
		if params[:user_name].present?
      @logger = Logger.new("log/shianyun_new_user.log")
      @logger.info params
      @logger.info "-"*100
			user = User.find_by_ca_uuid(params[:user_name])

			if user.nil?
				user = User.new(ca_uuid: params[:user_name])
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
      hash = user.api_generate_uid
      if hash["type"]
        user.uid = hash["msg"]
      else
        render json: { status: 0, msg: hash["msg"]}
        return
      end

			if user.save
				render json: { status: 1, msg: ""}
			else
				render json: { status: 0, msg: user.errors.first.last}
			end
		else
			render json: { status: 0, msg: "没有user_name值"}
		end
	end
end
