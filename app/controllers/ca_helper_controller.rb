#encoding: utf-8
class CaHelperController < ApplicationController
  skip_before_filter :authenticate_user!

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
end
