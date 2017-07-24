class Api::V3::InterfaceStampsController < ApplicationController
  skip_before_filter :session_expiry, :verify_authenticity_token, :authenticate_user!

  def jg_bsb_stamps_sync
    render json: {status: 0, msg: 'uuid为空'} and return if params["uuid"].blank? && params["type"].blank? 
    @logger = Logger.new("log/shianyun_jg_bsb_stamps.log")
    @logger.info params
    @logger.info "-"*100
    jg_bsb_stamp = JgBsbStamp.find_by_uuid(params["uuid"])
    if params["type"] == 0
      render json: {status: 0, msg: '没有找到对象'} and return if jg_bsb_stamp.blank?
      render json: {status: 1, msg: ''} if jg_bsb_stamp.delete 
    else
      jg_bsb = JgBsb.find_by_uuid(params["jg_uuid"])
      render json: {status: 0, msg: "没有找到机构(#{params["jg_uuid"]})"} and return if jg_bsb.blank? 
      if jg_bsb_stamp.nil?
        jg_bsb_stamp = JgBsbStamp.new()
      end
			params.each do |field, value|
				if jg_bsb_stamp.respond_to?(field)
				  jg_bsb_stamp.send("#{field}=", value)
        end
			end
      jg_bsb_stamp.jg_bsb_id = jg_bsb.id
			if jg_bsb_stamp.save
				render json: { status: 1, msg: ""}
			else
				render json: { status: 0, msg: jg_bsb_stamp.errors.first.last}
			end
    end
  end
  
end
