class Api::V1::ClientController < ApplicationController
	skip_before_filter :session_expiry, :verify_authenticity_token, :authorize
  skip_before_action :authenticate_user!

	#CURRENT_VERSION_CODE = 40
  def version
		config_path = Rails.root.join('config', 'app_version.json')
		app_info = JSON.parse(File.read(config_path))

		respond_to do |format|
			format.json { render :json => {:status => 'OK', :msg => {:versionCode => app_info['version_code']}}}
		end
  end

  def download
		send_file Rails.root.join('public', 'ifcc.apk'), :filename => 'ifcc.apk', :disposition => 'attachment'
  end
end
