class Api::V1::ClientController < ApplicationController
	skip_before_filter :session_expiry, :verify_authenticity_token, :authorize

	CURRENT_VERSION_CODE = 35
  def version
		respond_to do |format|
			format.json { render :json => {:status => 'OK', :msg => {:versionCode => CURRENT_VERSION_CODE}}}
		end
  end

  def download
		send_file Rails.root.join('public', 'ifcc.apk'), :filename => 'ifcc.apk', :disposition => 'attachment'
  end
end
