#encoding: utf-8
class Api::V1::UsersController < ApplicationController
	skip_before_filter :session_expiry, :verify_authenticity_token
	before_filter :authorize, :only => [:auth, :update_location]
  skip_before_action :authenticate_user!

  # CA AUTH
  def ca_auth
    @ca_helper = Bjca::CaHelper.new

    respond_to do |format|
      response_code = @ca_helper.validate_cert(params[:userCert])
      if response_code == 1
        sfid = @ca_helper.get_cert_info_by_oid(params[:userCert])
        @user = User.find_by_id_card(sfid)
        if @user.nil?
          format.json { render :json => {status: 'ERR', msg: '该用户未在系统中登记，请在电脑上登录系统绑定您的KEY', key: sfid, code: 444} }
        else
          format.json { render :json => {status: 'OK', msg: '登录成功', user: @user} }
        end
      else
        format.json { render :json => {status: 'ERR', msg: ValidateCertCode::ResponseCode["code:#{response_code}"]} }
      end
    end
  end

	# 向客户端返回随机数
	def ca_get_random
		render json: { status: 'OK', msg: 'OK', random_info: Bjca::CaHelper.new.gen_client_verify_random_info}
	end

  def auth
    respond_to do |format|
      #if params[:device_uuid].blank?
      #  format.json { render :json => {:status => 'ERR', :msg => '设备非法'} }
      #else
        if @user.device_uuid.blank?
          @user.device_uuid = params[:device_uuid]
          if @user.save
            format.json { render :json => {:status => 'OK', :msg => '绑定设备成功', :user => @user} }
          else
            format.json { render :json => {:status => 'ERR', :msg => '设备绑定失败'} }
          end
        else
          #if @user.device_uuid.eql?(params[:device_uuid])
          format.json { render :json => {:status => 'OK', :msg => '登录成功', :user => @user} }
          #else
          #	format.json { render :json => {:status => 'ERR', :msg => '登录失败，当前用户无法使用该设备'}}
          #end
        end
      #end
    end
  end

  def update_location
    @ul = UserLocation.new(:gps => params[:gps], :user_id => @user.id)
    respond_to do |format|
      if @ul.save
        format.json { render :json => {:status => 'OK', :msg => ''} }
      else
        format.json { render :json => {:status => 'ERR', :msg => @ul.errors.first.last} }
      end
    end
  end

  private
  def authorize
    if !(params[:username].blank? or params[:password].blank?)
      @user = User.where(uid: params[:username]).last
      if @user.blank? or !@user.valid_password?(params[:password])
        respond_to do |format|
          format.json {
            render :json => {:status => 'ERR', :msg => '无效的用户名或密码'}
            return
          }
        end
      end
    else
      respond_to do |format|
        format.json {
          render :json => {:status => 'ERR', :msg => '请输入用户名或密码'}
          return
        }
      end
    end
  end
end
