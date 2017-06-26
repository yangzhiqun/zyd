#encoding: utf-8
class CaHelperController < ApplicationController
  skip_before_filter :authenticate_user!

  def sso
    response = Unirest.get("http://223.71.250.19:8080/am/identity/attributes?subjectid=#{params['tokenId']}&attributenames=useridcode")
    if response.code == 200
      ca_uuid = response.body.lines.last.split('=').last.strip
      user = User.find_by_ca_uuid(ca_uuid)
      if user.nil?
        render text: "用户不存在或未登记, caid: #{ca_uuid}"
      else
				if current_user.nil?
					sign_in(user)
				else
					if current_user.id != user.id
						sign_out(current_user)
						sign_in(user)
					end
				end
				redirect_to '/'
      end
    else
      render text: "服务器错误, Status: #{response.code}"
    end
  end

  def fsnip_sso
    logger.error session.as_json
    if session['cas'].blank?
      render text: 'no sso session', status: 401
    else
      user = User.find_by_ca_uuid(session['cas']['user'])
      if user.nil?
        render text: "用户不存在或未登记, uuid: #{session['cas']['user']}"
      else
        if current_user.nil?
          sign_in(user)
        else
          if current_user.id != user.id
            sign_out(current_user)
            sign_in(user)
          end
        end
        redirect_to '/'
      end
    end
  end

  def fsnip_logout 
    if params["ca_uuid"].blank?
      render text: '没有传值'
    else
      user = User.find_by_ca_uuid(params["ca_uuid"])
      if user.nil?
        render text: "用户不存在或未登记, uuid: #{params["ca_uuid"]}"
      else
        if current_user.nil?
          sign_out(user)
        else
          if current_user.id == user.id
            sign_out(current_user)
          end
        end
        redirect_to '/'
      end
    end
  end

  def verify_report

    if request.post?

      @report_file = params[:report_file]
      if @report_file.blank?
        flash[:error] = '请上传待验证的文件'
      else
        result_file_path = "/tmp/verify_pdf_#{Time.now.to_i}_#{rand(200000)}.result.txt"
        cmd = "/usr/local/java-ppc64-80/jre/bin/java -jar #{Rails.root.join('bin', 'esspdf-client.jar')} #{Rails.application.config.site[:ca_pdf_address]} 8888 2 #{@report_file.path} #{result_file_path}"
        `#{cmd}`
        @result = File.read(result_file_path).to_i
        if @result == 200
					@verify_passed = true
				else
					@verify_passed = false
				end
      end
    end

    render :layout => 'blank_with_topbar'
  end

	def account_sync
		case params[:synType].to_i
		when 0
			@operateID  = params["operateID"]
			@userIdCode = params["userIdCode"]
			@userType   = params["userType"]
			@result     = false
			p "*"*100
			p @operateID,@userIdCode,params[:synType]
			p "*"*100
			if !(@operateID&&@userIdCode).blank?
				obj = User.where(user_code: @userIdCode).first			
				if @operateID == "11"
					@result = Api::DataSync::UserInfo.query_user_info_detail(@userIdCode)
				elsif @operateID == "13" && !obj.blank?
					obj.destroy
					@result = true
				elsif @operateID == "51" && !obj.blank?
					@result = obj.update_attributes(:ca_user_status => 1)	
				end
			end
			p "------------"
			p @result.to_s
			p "------------"
			render :text => @result.to_s
		when 1
			@operateID  = params["operateID"]	
			@orgNumber  = params["orgNumber"]
			@userType		= params["userType"]
			@result = false
			p "-"*100
			p @operateID,@orgNumber,@userType
			p "-"*100
			if !(@operateID&&@orgNumber).blank?
				if @operateID == "41" || @operateID == "42"
					@result = Api::DataSync::DeptInfo.query_organization_vo(@orgNumber)
				else
					org = JgBsb.where(id: @orgNumber).first
					if !org.blank?
						obj.destroy
						@result = true
					end
				end
			end
			render :text => @result.to_s
		end
	end
def hash_client_sign
		signCert = params[:signCert]
    signEseal = params[:signEseal]
		@sp_bsb = SpBsb.find(params[:sp_bsb_id])
	if [2, 3].include? @sp_bsb.sp_i_state
      keyword = '检验人'
    elsif @sp_bsb.sp_i_state == 4
      keyword = '审核人'
    elsif @sp_bsb.sp_i_state == 5
      keyword = '批准人：'
   end
	_QFRQ_keyword_ = '签发日期：'
	res = {}
		
end
  def create_text
     filename=Rails.root.join('tmp', "test.txt")
     reqMessage ={appId: Rails.application.config.site[:appid],policyType: 2}
     reqContent =Base64.strict_encode64(reqMessage.to_json)
     cmd = "java -jar #{Rails.root.join('bin', 'mssg-pdf-client.jar')} #{Rails.application.config.site[:ip]} #{Rails.application.config.site[:port]} 113 #{reqContent} #{filename} "
     result = `#{cmd}`
     nonceStr  =  File.read(Rails.root.join('tmp', "test.txt"))
     logger.error "result: #{result}"
     render json: {status: 'OK', msg: nonceStr}
  end

  def client_sign_pdf
    @spbsb = SpBsb.find(params[:sp_bsb_id])
    signData =params[:signData]
    signCert =params[:signCert]
    res = {}
    if params[:pdf_rules_list][:JDCJ].present?
      jd_pdf_rules=params[:pdf_rules_list][:JDCJ]
      logger.error jd_pdf_rules
    end
   if fx_pdf_rules=params[:pdf_rules_list][:FXJC].present?	
     fx_pdf_rules=params[:pdf_rules_list][:FXJC]
     logger.error fx_pdf_rules
   end
   
    respond_to do |format|
        format.html {
	  logger.error "ssdsd"
       	   if params[:pdf_rules_list][:JDCJ].present?
		ca_filepath=@spbsb.JDCJ_report_path
		new_ca_filepath = "#{Rails.application.config.attachment_path}/result/#{@spbsb.sp_s_16}-JYBG.pdf"
                filepath = @spbsb.generate_ca_pdf_report(ca_filepath,new_ca_filepath,params[:pdf_rules_list][:JDCJ],signData,signCert,params[:nonce])  
		logger.error filepath
		if filepath.nil?
                    flash[:error] = '查看报告失败'
                    redirect_to '/sp_bsbs/no_available_pdf_found' and return
                else
                  #res[:JDCJ_path]= filepath
		 @spbsb.update_attributes(JDCJ_report_path: filepath)
                end
	    end

	   if params[:pdf_rules_list][:FXJC].present?
		ca_filepath=@spbsb.FXJC_report_path
		new_ca_filepath = "#{Rails.application.config.attachment_path}/result/#{@spbsb.sp_s_16}-FXBG.pdf"
		filepath = @spbsb.generate_ca_pdf_report(ca_filepath,new_ca_filepath,params[:pdf_rules_list][:FXJC],signData,signCert,params[:nonce])
		logger.error filepath
		if filepath.nil?
                    flash[:error] = '查看报告失败'
                    redirect_to '/sp_bsbs/no_available_pdf_found' and return
                else
                    # res[:FXJC_path]= filepath
	           @spbsb.update_attributes(FXJC_report_path: filepath)
                end
	   end

	  render json: { status: 'OK',res: res}	
	}
    end

  end 
end
