#encoding: utf-8
class CaHelperController < ApplicationController
  skip_before_filter :authenticate_user!

  def sso
    response = Unirest.get("http://60.247.77.105:8080/am/identity/attributes?subjectid=#{params['tokenId']}&attributenames=useridcode")
    if response.code == 200
      ca_uuid = response.body.lines.last.split('=').last.strip
      user = User.find_by_ca_uuid(ca_uuid)
      if user.nil?
        render text: "用户不存在或未登记, caid: #{ca_uuid}"
      else
        sign_in(user)
        redirect_to '/'
      end
    else
      render text: "服务器错误, Status: #{response.code}"
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
end
