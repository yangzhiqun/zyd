#encoding=UTF-8
#---
# Excerpted from "Agile Web Development with Rails, 3rd Ed.",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails3 for more book information.
#---
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.


class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :authenticate_user!, except: [:update_account, :bind_ca_key, :ca_login]

  # before_filter :authorize, :except => [:login, :bind_ca_key]

  # before_filter :session_expiry, :except => [:login, :ca_login, :logout, :timeout, :bind_ca_key]
  # before_filter :update_activity_time, :except => [:login, :logout, :ca_login, :bind_ca_key]

  before_filter :check_user_info, :except => [:login, :bind_ca_key, :complete_user_info]

  # helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => '8fc080370e56e929a2d5afca5540a0f7'

  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  protected

  def check_user_info
    # 如果用户账号未启用，则跳至等待页面
    if current_user.present? and !current_user.is_passed?
      redirect_to '/in-review'
      return
    end

    # 如果用户信息不完整，则跳转至填充页面
    if !current_user.nil? and !current_user.is_info_complete?
      redirect_to '/complete_user_info'
      return
    end

    if current_user.present? and current_user.encrypted_password.blank?
      session[:update_user_id] = current_user.id
      redirect_to '/update-account'
		end
  end

  # def authorize
  #   unless User.find_by_id(session[:user_id])
  #     flash[:notice] = '请登录后使用系统'
  #     redirect_to :controller => 'admin', :action => 'login'
  #   end
  # end

  def after_sign_in_path_for(resource)
    user_agent = request.env['HTTP_USER_AGENT']
    user_agent_parsed = UserAgent.parse(request.env['HTTP_USER_AGENT'])

    if current_user.user_i_switch == 1
      session[:user_dl]=current_user.user_s_dl
      session[:user_i_switch] = 1
    else
      session[:user_dl].blank?
      session[:user_i_switch] = 0
    end

    #药监局数据采样
    if current_user.user_i_js == 1 && current_user.user_d_authority == 1
      session[:change_js] = 1
    end

    #药监局数据审核
    if current_user.user_i_js == 1 && current_user.user_d_authority_2 == 1
      session[:change_js]=2
    end

    #药监局问题样品处理
    if current_user.user_i_js == 1 && current_user.user_d_authority_3 == 1
      session[:change_js]=3
    end

    #药监局统计分析
    if current_user.user_i_js == 1 && current_user.user_d_authority_4 == 1
      session[:change_js]=4
    end

    #检测机构数据采样
    if current_user.user_i_js == 0 && current_user.user_d_authority == 1
      session[:change_js]=5
    end

    #检测机构数据填报
    if current_user.user_i_js == 0 && current_user.user_d_authority_1 == 1
      session[:change_js]=6
    end

    #检测机构数据审核
    if current_user.user_i_js == 0 && current_user.user_d_authority_2 == 1
      session[:change_js]=7
    end

    #检测机构牵头单位
    if current_user.user_s_dl.present?
      session[:change_js]=8
    end

    if current_user.user_i_spys == 1 #一司
      session[:change_js]=9
    end
    if current_user.user_i_spss == 1 #三司
      session[:change_js]=10
    end
    LoginLog.create(:name => current_user.name, :sessionid => session.id, :action => '登陆成功', :ip => request.env["REMOTE_ADDR"], :os => user_agent_parsed.os, :browser => user_agent_parsed.browser, :brover => user_agent_parsed.version)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end
end

def session_expiry

  #logger.debug "session_expiry#{Time.now}\nhello#{Time.now}\nhello#{Time.now}\nhello#{Time.now}\n"
  @time_left = session[:expires_at].to_i - Time.now.to_i

  unless @time_left > 0
    reset_session
    flash[:error] = '连接超时.'
    # render :js => parent.location.reload();
    # redirect_to(:controller => 'main',:action => 're')
    redirect_to "/users/timeout"
  end
end

def update_activity_time
  #logger.debug "update_activity_time#{Time.now}\nhello#{Time.now}\nhello#{Time.now}\nhello#{Time.now}\n"
  session[:expires_at] = 3.hour.from_now.to_i
end
