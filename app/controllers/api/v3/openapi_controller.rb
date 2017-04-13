class Api::V3::OpenapiController < ApplicationController
  #before_filter :doorkeeper_authorize!
  skip_before_filter :session_expiry, :verify_authenticity_token, :authenticate_user!

	def sample_add_or_edit
		if params[:baseinfo].present? and params[:subinfo].present?
      @logger = Logger.new("log/sp_logs.log")
      @logger.info params
      @logger.info "-"*100
			bsb = SpBsb.find_by_sp_s_16(params[:subinfo][:sp_s_16])
			if bsb.nil?
				bsb = SpBsb.new(sp_s_16: params[:baseinfo][:sample_code])
      end

      if params[:baseinfo][:reason_back].present? || SpBsb.find_by_sp_s_16(params[:subinfo][:sp_s_16]).blank?
			  bsb.sp_s_2_1 = params[:baseinfo][:resource_org_name]
        bsb.cyd_file_path = params[:baseinfo][:up_sample_report]
        bsb.cyjygzs_file_path = params[:baseinfo][:up_report_check]
			  bsb.sp_s_70 = params[:baseinfo][:scaname]
			  bsb.sp_s_67 = params[:baseinfo][:scbname]
			  bsb.sp_s_17 = params[:baseinfo][:fcc_grade_one_name]
			  bsb.sp_s_18 = params[:baseinfo][:fcc_grade_two_name]
			  bsb.sp_s_19 = params[:baseinfo][:fcc_grade_three_name]
			  bsb.sp_s_20 = params[:baseinfo][:fcc_grade_four_name]
			  bsb.sp_s_68 = params[:baseinfo][:pcname_hj]
			  bsb.sp_s_2 = params[:baseinfo][:pcname_dd]
			  bsb.sp_s_43 = params[:baseinfo][:check_org_name]
			  bsb.sp_i_state = 2 # TODO: 
			  bsb.wochacha_task_id = params[:task_id]

			  # 更新信息
			  params[:subinfo].each do |field, value|
			  	if SpBsb.new.respond_to?(field)
			  	  bsb.send("#{field}=", value)
          end
			  end
      end

			if bsb.save
				#if params[:subinfo][:sp_s_pic].present?
				#	prev_pic_ids = SpBsbPicture.where(sp_bsb_id: task.id).pluck(:id)
				#	params[:subinfo][:sp_s_pic].each do |pic, index|
				#		attachment = Attachment.find_by_id(pic[:id])
				#		next if attachment.nil?

				#		sbp = SpBsbPicture.new(sp_bsb_id: task.id, sort_index: index)
				#		sbp.tmp_file = attachment.absolute_path
				#		sbp.save
				#	end 
				#	SpBsbPicture.where(id: prev_pic_ids).destroy_all
				#end 
				render json: { status: 0, msg: ""}
			else
				render json: { status: 1, msg: bsb.errors.first.last}
			end
		else
			render json: { status: 1, msg: "baseinfoorsubinfonotexists"}
		end
	end
end
