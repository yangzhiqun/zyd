class Api::V3::InterfaceRegionController < ApplicationController
  skip_before_filter :session_expiry, :verify_authenticity_token, :authenticate_user!

	def new_region
		if params["id"].present? and params["name"].present? and params["level"].present?
      @logger = Logger.new("log/shianyun_new_regin.log")
      @logger.info params
      @logger.info "-"*100
			prov = SysProvince.find_by_id(params["id"])

			if prov.nil?
				prov = SysProvince.new(id: params["id"])
      end

			params.each do |field, value|
				if prov.respond_to?(field)
				  prov.send("#{field}=", value)
          if field =="code" && value == ""
            prov.code = nil 
          end
        end
			end

			if prov.save
				render json: { status: 1, msg: ""}
			else
				render json: { status: 0, msg: prov.errors.first.last}
			end
		else
			render json: { status: 0, msg: "没有值"}
		end
	end
end
