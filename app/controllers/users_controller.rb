#encoding=UTF-8
class UsersController < ApplicationController
  include ApplicationHelper
  skip_before_filter :check_user_info, only: [:update_account, :update, :in_review, :edit]
  skip_before_filter :authenticate_user!, only: [:update]
  before_action :find_province, only: [:new,:create,:edit,:show,:update,:index,:users_by_jcjg]
  # GET /users
  # GET /users.xml
  before_filter :init

  def init
    @options=[]
  end

  def complete_user_info
    @user = current_user
    @title = '请填写完整个人信息'
    render layout: 'blank'
  end

  def update_account
    @title = '账户升级...'

    if request.post?
      @user = User.find(session[:update_user_id])

      unless @user.update_attributes(params.require(:user).permit(:uid, :ca_uuid, :tname, :id_card, :mobile, :password, function: []))
        @errors = true
        logger.error "修改用户失败：#{@user.errors.first.last}"
      end
      return not_found if @user.nil?
    else
      @user = User.find(session[:update_user_id])
      @user.reload
      return not_found if @user.nil?
    end
    render layout: 'blank'
  end

  def index
    if current_user.is_super? or current_user.is_account_manager
      if params[:user_user_search_form].present?
        @search_form = User::UserSearchForm.new(params.require(:user_user_search_form).permit(:qtjg, :uid, :hcl_gly, :hcl_czap, :hcl_czbl, :hcl_czsh, :pad_rwbs, :pad_jsyp, :pad_rwxd, :pad_zxcy, :tname, :prov, :jg_id, :tbjbxx, :jbjcsj, :sbsh, :sbpz, :yy_gly, :yy_yysl, :yy_zhxt, :yy_yybl, :yy_yysh,:jbxxsh))
      else
        @search_form = User::UserSearchForm.new
      end

      @users = User.order('tname DESC')

      if current_user.is_account_manager
      	if current_user.user_i_js == 1 
			   	@users = @users.where(user_s_province: current_user.user_s_province)
			 else
          @users = @users.where(jg_bsb_id: current_user.jg_bsb_id)
        end
      end

      if @search_form.tname.present?
        @users = @users.where('tname like ?', "%#{@search_form.tname}%")
      end

      if @search_form.uid.present?
        @users = @users.where('uid like ?', "%#{@search_form.uid}%")
      end

      if @search_form.prov.present? and !@search_form.prov.eql?('/')
         @users = @users.where('prov_city = ?', "#{@search_form.prov}")
      end
			
      if @search_form.jg_id.present? and !@search_form.jg_id.eql?('/')
         @users = @users.where('jg_bsb_id = ?', "#{@search_form.jg_id}")
      end


      @users = @users.where('user_d_authority = 1') if @search_form.tbjbxx.to_i == 1
      @users = @users.where('user_d_authority_1 = 1') if @search_form.jbjcsj.to_i == 1
      @users = @users.where('user_d_authority_2 = 1') if @search_form.sbsh.to_i == 1
      @users = @users.where('user_d_authority_5 = 1') if @search_form.sbpz.to_i == 1
      @users = @users.where('jbxx_sh = 1') if @search_form.jbxxsh.to_i == 1
      if @search_form.qtjg.to_i == 1
        @users = @users.where('user_i_switch = 1')
      else
        @users = @users.where('user_i_switch = 0')
      end

      @users = @users.where('yycz_permission & ? > 1', ::User::YyczPermission::GL) if @search_form.yy_gly.to_i == 1
      @users = @users.where('yycz_permission & ? > 0', ::User::YyczPermission::YYSL) if @search_form.yy_yysl.to_i == 1
      @users = @users.where('yycz_permission & ? > 1', ::User::YyczPermission::ZHXT) if @search_form.yy_zhxt.to_i == 1
      @users = @users.where('yycz_permission & ? > 1', ::User::YyczPermission::YYBL) if @search_form.yy_yybl.to_i == 1
      @users = @users.where('yycz_permission & ? > 1', ::User::YyczPermission::YYSH) if @search_form.yy_yysh.to_i == 1

      @users = @users.where('hcz_permission & ? > 1', ::User::HczPermission::GL) if @search_form.hcl_gly.to_i == 1
      @users = @users.where('hcz_permission & ? > 0', ::User::HczPermission::CZAP) if @search_form.hcl_czap.to_i == 1
      @users = @users.where('hcz_permission & ? > 1', ::User::HczPermission::CZBL) if @search_form.hcl_czbl.to_i == 1
      @users = @users.where('hcz_permission & ? > 1', ::User::HczPermission::CZSH) if @search_form.hcl_czsh.to_i == 1

      @users = @users.where('pad_permission & ? > 0', ::User::PadPermission::RWBS) if @search_form.pad_rwbs.to_i == 1
      @users = @users.where('pad_permission & ? > 1', ::User::PadPermission::ZXCY) if @search_form.pad_zxcy.to_i == 1
      @users = @users.where('pad_permission & ? > 1', ::User::PadPermission::RWXD) if @search_form.pad_rwxd.to_i == 1
      @users = @users.where('pad_permission & ? > 1', ::User::PadPermission::JSYP) if @search_form.pad_jsyp.to_i == 1
     if current_user.is_city? and (!current_user.is_super? or !current_user.is_admin?)
      @users = @users.where(" prov_city = ?",current_user.prov_city)
     elsif current_user.is_county_level? and (!current_user.is_super? or !current_user.is_admin?)
      @users = @users.where(" prov_country = ?",current_user.prov_country)
     end
      @users = @users.paginate(page: params[:page], per_page: 20)
    else
      @users = User.where(id: current_user.id)
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @user }
    end
  end

  def changeauthority
    @user = current_user

    respond_to do |format|
      format.html # changeauthority.html.erb
      format.xml { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    if current_user.name == 'superadmin' or is_shengshi? 
      @user = User.new(user_s_province: SysConfig.get(SysConfig::Key::PROV))
      respond_to do |format|
        format.html # new.html.erb
        format.xml { render :xml => @user }
      end
    else
      redirect_to :controller => 'admin', :action => 'login'
    end
  end

  def bind_ca_key
    if request.get?
      render layout: "blank"
    elsif request.post?
      @user = User.where(uid: params[:username]).last
      if @user.nil? or !@user.valid_password?(params[:password])
        render json: {status: 'ERR', msg: '无效的用户名或密码'}
      else
        if params[:user_sign].blank?
          render json: {status: 'ERR', msg: '无效的签名'}
          return
        end

        if session[:sfid].blank?
          render json: {status: 'ERR', msg: '无效的身份证号'}
          return
        end

        @user.id_card = session[:sfid]
        @user.user_sign = params[:user_sign]

        unless @user.save
          render json: {status: 'ERR', msg: @user.errors.first.last}
        else
          render json: {status: 'OK', msg: "成功绑定，请重新登录！"}
        end
      end
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    if current_user.is_account_manager or current_user.is_super?
      @user = User.new(user_params)
      @user.user_s_province = current_user.user_s_province
      @user.state = User::State::InUse

      respond_to do |format|
        if @user.save
          UserAuditLog.create(user_id: @user.id, operator_id: current_user.id, action: UserAuditLog::Action::SUPass, msg: '管理员添加')
          flash[:notice] = "#{@user.tname}账号添加成功!"
          format.html { redirect_to "/users/#{@user.id}/edit" }
        else
          flash[:notice] = @user.errors.first.last
          format.html { render :action => 'new' }
        end
      end
    else
      flash[:notice] = '无权操作'
      redirect_to :back
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    u_params = user_params
    if u_params[:password].blank?
      u_params.delete(:password)
      u_params.delete(:password_confirmation)
    end

    if params['account-pass-request'].to_i == 1 and ((current_user.id == @user.id and @user.state == User::State::Rejected) or (!@user.is_passed? and current_user.is_account_manager))
      request_pass = params['account-pass'].to_i == 1

      case @user.state
        when User::State::ReviewSJ
          if request_pass
            @user.state = User::State::InUse
            UserAuditLog.create(user_id: @user.id, operator_id: current_user.id, action: UserAuditLog::Action::SjPass, msg: '省局审核通过')
          else
            @user.state = User::State::Rejected
            UserAuditLog.create(user_id: @user.id, operator_id: current_user.id, action: UserAuditLog::Action::SjFail, msg: '机构审核失败')
          end
        when User::State::ReviewJG
          if request_pass
            @user.state = User::State::ReviewSJ
            UserAuditLog.create(user_id: @user.id, operator_id: current_user.id, action: UserAuditLog::Action::JgPass, msg: '机构审核通过')
          else
            @user.state = User::State::Rejected
            UserAuditLog.create(user_id: @user.id, operator_id: current_user.id, action: UserAuditLog::Action::JgFail, msg: '机构审核失败')
          end
        when User::State::InUse
          raise 'How can this happen?'
        when User::State::Rejected
          @user.state = User::State::ReviewJG
          UserAuditLog.create(user_id: @user.id, operator_id: current_user.id, action: UserAuditLog::Action::UserReq, msg: '用户再次提起')
        else
          #...
      end
    end

    respond_to do |format|
      if @user.update_attributes(u_params)
        flash[:notice] = "用户信息修改成功"
        if params['account-pass-request'].to_i == 1
          format.html { redirect_to('/users/pending') }
        else
          format.html { redirect_to "/users/#{@user.id}/edit" }
        end
        format.xml { head :ok }
      else
        flash[:notice] = @user.errors.first.last
        format.html { render :action => "edit" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def users_by_jcjg
    @jg_bsb = JgBsb.find_by_jg_name(params[:jcjg])

    respond_to do |format|
			if @jg_bsb.present?
				if (params[:model] || "yydjb").eql? "yydjb"
					@users = User.where("jg_bsb_id = ? and yycz_permission & ? > 0", @jg_bsb.id, 0x0000000000100)
				elsif params[:model].eql? "wtyp_czb"
					@users = User.where("jg_bsb_id = ? and hcz_permission & ? > 0", @jg_bsb.id, 0x0000000000010)
				end
				format.json { render :json => {:status => 'OK', :msg => @users} }
			else
				format.json { render :json => {:status => 'ERR', :msg => '机构信息不存在'} }
			end
		end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    if @user.name!='admin' or is_shengshi? 
      @user.destroy
    end
    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml { head :ok }
    end
  end

  #
  def import_data_excel
    unless current_user.name == 'superadmin'
      respond_to do |format|
        flash[:import_result] = "仅管理员可操作"
        format.html { redirect_to :back }
      end
      return
    end

    @imported_excel = params[:excel]

    if @imported_excel.blank?
      respond_to do |format|
        flash[:import_result] = "请上传导入文件"
        format.html { redirect_to :back }
      end
      return
    end

    unless ['.xls', '.xlsx'].include? File.extname(@imported_excel.original_filename)
      respond_to do |format|
        flash[:import_result] = "仅支持.xls 和 .xlsx格式文件"
        format.html { redirect_to :back }
      end
      return
    end

    roster = Spreadsheet.open(@imported_excel.path).worksheet(0)

    roster.each_with_index do |row, index|
      if index == 0
        @title = row
        next
      end

      next if row[@title.index('用户名')].nil? or row[@title.index('用户名')].strip.blank?

      if User.exists?(name: row[@title.index('用户名')])
        user = User.find_by_name(row[@title.index('用户名')])
      else
        user = User.new
      end
      user.name = row[@title.index('用户名')]

      pwd = row[@title.index('初始密码')].to_s
      if pwd.blank?
        user.password = '123456'
      else
        user.password = pwd
      end

      user.tname = row[@title.index('姓名')]
      user.tel = row[@title.index('联系电话')]
      user.eaddress = row[@title.index('E-mail')]
      user.user_s_province = row[@title.index('所在省份')]
      user.prov_city = row[@title.index('所在市')]
      user.user_s_lcity = row[@title.index('所在县')]
      user.user_jcjg = row[@title.index('机构名称')]


      user.jg_bsb_id = JgBsb.find_by_jg_name(user.user_jcjg).id
      user.user_i_switch = row[@title.index('是否为工作组')].to_i
      user.user_s_dl = row[@title.index('工作组内容')]
      user.user_i_js = row[@title.index('是否为地方药监局')].to_i
      user.user_i_spys = row[@title.index('是否为食品一司')].to_i
      user.user_i_spss = row[@title.index('是否为食品三司')].to_i
      user.user_i_sp = row[@title.index('食品')].to_i
      user.user_d_authority = row[@title.index('填报基本信息')].to_i
      user.user_d_authority_1 = row[@title.index('填报检测数据')].to_i
      user.jbxx_sh = row[@title.index('报告发送人')].to_i
      user.user_d_authority_2 = row[@title.index('机构审核')].to_i
      user.user_d_authority_5 = row[@title.index('机构批准')].to_i
      user.user_d_authority_4 = row[@title.index('统计分析')].to_i
      user.yysl = row[@title.index('异议受理')].to_i
      user.zhxt = row[@title.index('异议安排')].to_i
      user.yybl = row[@title.index('异议办理')].to_i
      user.yysh = row[@title.index('异议审核')].to_i
      user.hcz_czap = row[@title.index('核查处置安排')].to_i
      user.hcz_czbl = row[@title.index('核查处置办理')].to_i
      user.hcz_czsh = row[@title.index('核查处置审核')].to_i
      user.jsyp = row[@title.index('接收样品')].to_i
      user.zxcy = row[@title.index('执行采样任务')].to_i
      user.rwbs = row[@title.index('任务部署')].to_i
      user.rwxd = row[@title.index('任务下达')].to_i
      user.pub_xxfb = row[@title.index('信息发布')].to_i
      user.pub_xxfb_sh = row[@title.index('信息发布审核')].to_i
      user.enable_api = row[@title.index('是否启用接口')].to_i

      if user.save
      else
      end
    end

    respond_to do |format|
      format.html { redirect_to :action => "index", :controller => "users" }
    end
  end

  ###导出用户信息
  def export_user_info
    book = Spreadsheet::Workbook.new
    sheet =book.create_worksheet :name => "totles"
    sheet.row(0).concat %w{用户名 姓名 联系电话 电子邮箱 所在省份 所在机构 是否为工作组 是否为地方药监局 是否为食品一司 是否为食品三司 保健食品权限 化妆品权限 食品权限 填报基本信息 填报检测数据 上报审核 问题样品处理 统计分析 异议登记 异议安排 异议办理 异议审核 处置安排 处置办理 处置审核 任务部署 任务下达 执行采样 接收样品}
    count_row=1
    @user_info= User.find_by_sql("select * from users where user_i_js=1")
    @user_info.each do |info|
      sheet[count_row, 0]=info.name
      sheet[count_row, 1]=info.tname
      sheet[count_row, 2]=info.tel
      sheet[count_row, 3]=info.eaddress
      sheet[count_row, 4]=info.user_s_province
      sheet[count_row, 5]=info.jg_bsb.jg_name unless info.jg_bsb.nil?
      sheet[count_row, 6]=info.user_i_switch
      sheet[count_row, 7]=info.user_i_js
      sheet[count_row, 8]=info.user_i_spys
      sheet[count_row, 9]=info.user_i_spss
      sheet[count_row, 10]=info.user_i_bjp
      sheet[count_row, 11]=info.user_i_hzp
      sheet[count_row, 12]=info.user_i_sp
      sheet[count_row, 13]=info.user_d_authority
      sheet[count_row, 14]=info.user_d_authority_1
      sheet[count_row, 15]=info.user_d_authority_2
      sheet[count_row, 16]=info.user_d_authority_3
      sheet[count_row, 17]=info.user_d_authority_4
      sheet[count_row, 18]=info.yysl
      sheet[count_row, 19]=info.zhxt
      sheet[count_row, 20]=info.yybl
      sheet[count_row, 21]=info.yysh
      sheet[count_row, 22]=info.hcz_czap
      sheet[count_row, 23]=info.hcz_czbl
      sheet[count_row, 24]=info.hcz_czsh
      sheet[count_row, 25]=info.rwbs
      sheet[count_row, 26]=info.rwxd
      sheet[count_row, 27]=info.zxcy
      sheet[count_row, 28]=info.jsyp
      count_row += 1
    end

    savetempfile="public/#{(Time.now).year.to_s}年用户信息.xls"
    book.write(savetempfile)
    send_file(savetempfile, :disposition => "attachment")
  end

  def in_review
  end

  def pending
    return not_found unless current_user.is_account_manager
		if is_city?
      @pending_users = User.where('state = ? and user_s_province = ? and prov_city = ? ', User::State::ReviewSJ, current_user.user_s_province, current_user.prov_city)
   elsif 
      @pending_users = User.where('state = ? and user_s_province = ? and prov_city = ? and prov_country = ?', User::State::ReviewSJ, current_user.user_s_province, current_user.prov_city,current_user.prov_country)
    elsif current_user.user_i_js == 1
     # @pending_users = User.where('state = ? and user_s_province = ? and prov_city = ?', User::State::ReviewSJ, current_user.user_s_province, current_user.prov_city)
      @pending_users = User.where('state = ? and user_s_province = ? ', User::State::ReviewSJ, current_user.user_s_province)
    else
      @pending_users = User.where('state = ? and jg_bsb_id = ?', User::State::ReviewJG, current_user.jg_bsb_id)
    end
  end

  private
  def user_params
    params.require(:user).permit(:jbxx_sh,:jg_type,:ca_uuid, :hccz_level, :hccz_type, :is_account_manager, :mobile, :jg_bsb_id, :id_card, :user_sign, :pub_xxfb, :pub_xxfb_sh, :prov_city, :prov_country, :yyadmin, :jsyp, :hcz_admin, :car_sys_id, :zxcy, :rwbs, :rwxd, :enable_api, :hcz_sc, :hcz_lt, :hcz_czap, :hcz_czbl, :hcz_czsh, :yysl, :zhxt, :yybl, :yysh, :yycz_permission, :name, :password, :password_confirmation, :tname, :user_id, :uid, :tel, :eaddress, :company, :user_s_province, :user_d_authority, :user_d_authority_1, :user_jcjg, :user_jcjg_lxr, :user_jcjg_tel, :user_jcjg_mail, :user_cyjg, :user_cyjg_lxr, :user_cyjg_tel, :user_cyjg_mail, :user_d_authority_2, :user_d_authority_3, :user_d_authority_4, :user_d_authority_5, :user_i_js, :user_i_switch, :user_i_sp, :user_i_hzp, :user_i_bjp, :user_s_dl, :user_i_spys, :user_i_spss, :function_type, :prov_city, :prov_country, :admin_level)
  end
  def find_province
        @province = SysProvince.where("level like '_' or level like '__'").where(name: SysConfig.get(SysConfig::Key::PROV)).last
  end
end
