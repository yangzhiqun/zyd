#encoding: utf-8
class Api::V1::UsersController < ApplicationController
	skip_before_filter :session_expiry, :verify_authenticity_token
	before_filter :authorize, :only => [:auth, :update_location]

	# CA AUTH
	def ca_auth
		client = Savon.client(wsdl: "http://#{Rails.application.config.site[:ca_auth_address]}/webservice/services/SecurityEngineDeal?wsdl")
		response = client.call(:validate_cert, message: { appName: "SVSDefault", password: params[:userCert] })
		response_code = response.as_json[:validate_cert_response][:out].to_i

		respond_to do |format|
			if response_code == 1
				response = client.call(:get_cert_info_by_oid, message: {appName: "SVSDefault", base64EncodeCert: params[:userCert], oid: '1.2.156.112562.2.1.2.2'})
				@SFid = response.as_json[:get_cert_info_by_oid_response][:out].gsub(/SF/, '')
				session[:sfid] = @SFid
				@user = User.find_by_id_card(@SFid)
				if @user.nil?
					format.json { render :json => { status: 'ERR', msg: '该用户未在系统中登记，请在电脑上登录系统绑定您的KEY', key: @SFid, code: 444 }}
				else
					format.json { render :json => { status: 'OK', msg: '登录成功', user: @user }}
				end
			else
				format.json { render :json => { status: 'ERR', msg: ValidateCertCode::ResponseCode["code:#{response_code}"] }}
			end
		end
	end

  def auth
		respond_to do |format|
			if params[:device_uuid].blank?
				format.json { render :json => {:status => 'ERR', :msg => '设备非法'}}
			else
				if @user.device_uuid.blank?
					@user.device_uuid = params[:device_uuid]
					if @user.save
						format.json { render :json => {:status => 'OK', :msg => '绑定设备成功', :user => @user}}
					else
						format.json { render :json => {:status => 'ERR', :msg => '设备绑定失败'}}
					end
				else
					#if @user.device_uuid.eql?(params[:device_uuid])
						format.json { render :json => {:status => 'OK', :msg => '登录成功', :user => @user}}
					#else
					#	format.json { render :json => {:status => 'ERR', :msg => '登录失败，当前用户无法使用该设备'}}
					#end
				end
			end
		end
  end

	def update_location
		@ul = UserLocation.new(:gps => params[:gps], :user_id => @user.id)
		respond_to do |format|
			if @ul.save
				format.json{ render :json => {:status => 'OK', :msg => ''}}
			else
				format.json{ render :json => {:status => 'ERR', :msg => @ul.errors.first.last}}
			end
		end
	end

	private 
		def authorize
			if !(params[:username].blank? or params[:password].blank?)
				@user = User.authenticate(params[:username], params[:password])
				Rails.logger.error params.as_json
				if @user.blank?
					respond_to do |format|
						format.json { 
							render :json => {:status => 'ERR', :msg => '非法访问'}
							return
						}
					end
				end
			else
				respond_to do |format|
					format.json { 
						render :json => {:status => 'ERR', :msg => '参数无效'} 
						return
					}
				end
			end
		end
end
