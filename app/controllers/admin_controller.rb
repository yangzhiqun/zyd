#encoding: utf-8
class AdminController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:login, :ca_login]
  skip_before_filter :authorize, :only => [:ca_login]

  def login
		redirect_to '/'
=begin
    @title = "登录"
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      user_agent = request.env['HTTP_USER_AGENT']
      user_agent_parsed = UserAgent.parse(request.env['HTTP_USER_AGENT'])
      if user
        unless user.user_sign.blank?
          flash[:error] = '系统检测到您的账号已绑定证书，请使用USB-Key登录'
          redirect_to :back
          return
        end
        session[:user_id] = user.id
        session[:user_name] = user.name
        session[:user_tname] = user.tname
        session[:user_tel] = user.tel
        session[:user_mail] = user.eaddress
        # session[:user_jcjg] = user.user_jcjg
        session[:user_province] = user.user_s_province
        session[:user_authority_1] = user.user_d_authority
        session[:user_authority_2] = user.user_d_authority_1
        session[:user_authority_3] = user.user_d_authority_2
        session[:user_authority_4] = user.user_d_authority_3
        session[:user_authority_5] = user.user_d_authority_4
        session[:user_spys] = user.user_i_spys
        session[:user_spss] = user.user_i_spss
        session[:user_sp] = user.user_i_sp
        session[:user_bjp] = user.user_i_bjp
        session[:user_hzp] = user.user_i_hzp
        session[:user_js] = user.user_i_js

        if user.user_i_switch == 1
          session[:user_dl]=user.user_s_dl
          session[:user_i_switch] = 1
        else
          session[:user_dl].blank?
          session[:user_i_switch] = 0
        end
        session[:expires_at] = 180.minutes.from_now.to_i
        if session[:user_js] == 1 && session[:user_authority_1] == 1 #药监局数据采样
          session[:change_js] = 1
        end
        if session[:user_js] == 1 && session[:user_authority_3] == 1 #药监局数据审核
          session[:change_js]=2
        end
        if session[:user_js]==1&&session[:user_authority_4]==1 #药监局问题样品处理
          session[:change_js]=3
        end
        if session[:user_js]==1&&session[:user_authority_5]==1 #药监局统计分析
          session[:change_js]=4
        end
        if session[:user_js]==0&&session[:user_authority_1]==1 #检测机构数据采样
          session[:change_js]=5
        end
        if session[:user_js]==0&&session[:user_authority_2]==1 #检测机构数据填报
          session[:change_js]=6
        end
        if session[:user_js]==0&&session[:user_authority_3]==1 #检测机构数据审核
          session[:change_js]=7
        end
        if session[:user_dl]!='' #检测机构牵头单位
          session[:change_js]=8
        end
        if session[:user_spys]==1 #一司
          session[:change_js]=9
        end
        if session[:user_spss]==1 #三司
          session[:change_js]=10
        end

        flash[:notice] = "loggin"
        LoginLog.create(:name => params[:name], :sessionid => session.id, :action => '登陆成功', :ip => request.env["REMOTE_ADDR"], :os => user_agent_parsed.os, :browser => user_agent_parsed.browser, :brover => user_agent_parsed.version)
        redirect_to "/welcome_notices"
      else
        flash[:error] = '用户名或密码错误！'
        LoginLog.create(:name => params[:name], :action => '登陆失败', :ip => request.env["REMOTE_ADDR"], :os => user_agent_parsed.os, :browser => user_agent_parsed.browser, :brover => user_agent_parsed.version)
      end
    end
=end
  end


  def logout
    user_agent = request.env['HTTP_USER_AGENT']
    user_agent_parsed = UserAgent.parse(request.env['HTTP_USER_AGENT'])
    LoginLog.create(:name => session[:user_name], :sessionid => session.id, :action => '退出登录', :ip => request.env["REMOTE_ADDR"], :os => user_agent_parsed.os, :browser => user_agent_parsed.browser, :brover => user_agent_parsed.version)

    session[:user_id] = nil
    session[:user_name]=nil
    session[:user_province]=nil
    session[:user_tel] = nil
    session[:user_mail] = nil
    session[:user_authority_1]=0
    session[:user_authority_2]=0
    session[:user_jcjg] =nil
    session[:user_jcjg_lxr] =nil
    session[:user_jcjg_tel] =nil
    session[:user_jcjg_mail] =nil
    session[:user_cyjg] =nil
    session[:user_cyjg_lxr] =nil
    session[:user_cyjg_tel] =nil
    session[:user_cyjg_mail] =nil

    session[:certId] = ''
    session[:userCert] = ''

    flash[:notice] = "logout"
		sign_out(current_user)
		redirect_to '/' 
 end

  # POST /adduser  
  def adduser
  end

  def index
  end

  module ValidateCertCode
    ResponseCode = {
        'code:1' => '成功',
        'code:-1' => '不是所信任的根',
        'code:-2' => '超过有效期',
        'code:-3' => '作废证书',
        'code:-4' => '已加入和名单',
        'code:-5' => '证书未生效',
        'code:0' => '未知错误'
    }
  end

  # CA LOGIN
  def ca_login
	 validate_ca_cert= Bjca::CaHelper.new.validate_ca_cert(params[:UserCert])
  	 validate_random= Bjca::CaHelper.new.validate_random(params[:random],params[:UserSignedData],params[:UserCert])
     ca_userid=params[:ca_userid]
   respond_to do |format|
	if validate_ca_cert.include?("成功")&& validate_random
	    session[:sfid] = ca_userid
	    session[:userCert] =params[:UserCert]
        @user = User.find_by_id_card(ca_userid)
        if @user.nil? or @user.id_card.blank?
	     format.html {
		 errmsg = '第一次使用USBKEY登陆系统时，需要与用户在系统中的账号进行绑定，请点击确定按钮进入USBKEY绑定界面。'
		 flash[:error] = errmsg
		 redirect_to '/bind_ca_key'
	    }
          format.json { render :json => {status: 'ERR', msg: errmsg, key: ca_userid , code: 444} }
        else
          # TODO 完善CA登陆后逻辑
          logger.error "111"
          sign_in @user
					logger.error "222"
					after_sign_in_path_for(@user)
					format.html { redirect_to '/welcome_notices' }
          format.json { render :json => {status: 'OK', msg: 'OK'} }
        end
     else
      format.json { render :json => {status: 'ERR', msg: '无效key'} }
     end
   end
   end
end
