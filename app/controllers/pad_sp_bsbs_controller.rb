#encoding=UTF-8
require 'csv'
require 'net/http'
require 'RMagick'

class PadSpBsbsController < ApplicationController
  include ApplicationHelper
  before_action :init, only: [:new, :edit, :update, :create, :show]
  # 食品标准
  def checkout_standard
    result = RestClient.get("http://221.194.147.38:8081/spaqk/webservice/getInfo?name=%s&flag=#{params[:flag]}" % [URI.escape(params[:name])])
    result = result.gsub("[", "{").gsub("]", "}").gsub("'", '"')
    result = JSON.parse(result)
    if result.blank?
      render :json => {:status => 'ERR', :msg => result}
    else
      render :json => {:status => 'OK', :msg => result}
    end
  end

  def init
    if current_user.is_admin?
      @admin_user=1
    else
      @admin_user=0
    end
    #@avala=[17, 18, 19, 20, 21, 23, 24, 30, 31, 33, 36, 44, 59, 61, 62, 63, 66, 67, 68, 70, 71, 201, 203, 205, 214]
    #@options=[]
    #@avala.each do |i|
    #  @options[i]=Flexcontent.where(flex_field: "sp_bsb_sp_s_#{i}").order("flex_sortid ASC")
    #  @options[i]=@options[i].map { |option| [option[:flex_name], option[:flex_id]] }
    #  @xkz_options=[["请选择", "请选择"], ["流通许可证", "流通许可证"], ["餐饮服务许可证", "餐饮服务许可证"]]
    #end
    #@options_68=[]
    #@options[68].each_index do |i|
    #  temp=Flexcontent.where("flex_field=? and flex_groupid=?", "sp_bsb_sp_s_2", i).order("flex_sortid ASC")
    #  @options_68[i]=temp.map { |option| option[:flex_name] }
    #end
    #
		#@jg_bsbs = JgBsb.where('status = 0 and jg_sp_permission = 1 and jg_detection = 1', session[:user_province]).order('jg_province')

    @avala=[21, 24, 30, 33, 36, 44, 61, 62, 63, 68, 201, 203, 205, 214]
    @options=[]
    @avala.each do |i|
      @options[i] = Flexcontent.where(flex_field: "sp_bsb_sp_s_#{i}").order("flex_sortid ASC")
      @options[i] = @options[i].map { |option| [option[:flex_name], option[:flex_id]] }.unshift(['请选择', nil])
    end

    @xkz_options=[['请选择', ''], ['经营许可证', '经营许可证'], ['生产许可证', '生产许可证']]

    @jg_bsbs = JgBsb.where('status = 0 and jg_detection = 1').order('jg_province')
  end

  #2014-01-12
  def data_owner(params_data)
    if current_user.is_admin?||session[:change_js]==9||session[:change_js]==10
      return 1
    end
    # if params_data.tname == current_user.name
    if params_data.user_id == current_user.id
      return 1
    end
    if current_user.jg_bsb.all_names.include?(params_data.sp_s_43)
      return 1
    end
    if (params_data.sp_s_3==current_user.user_s_province||params_data.sp_s_202==current_user.user_s_province||params_data.sp_s_52==current_user.user_s_province)&&(session[:change_js]==2||session[:change_js]==3||session[:change_js]==4)
      return 1
    end
    if params_data.sp_s_17==session[:user_dl]&&session[:change_js]==8
      return 1
    end
    if (params_data.sp_s_18=='婴幼儿配方食品' and params_data.sp_s_56=='一司')&&session[:change_js]==8&&current_user.jg_bsb.jg_name == '上海市质量监督检验技术研究院'
      return 1
    end
    return 0
  end

  def accept_sample
    @pad_sp_bsb = PadSpBsb.find(params[:id])
    if current_user.jg_bsb.all_names.include?(@pad_sp_bsb.sp_s_43) and @pad_sp_bsb.sp_i_state == ::PadSpBsb::Step::FINISHED
      @sp_bsb = SpBsb.new
      @pad_sp_bsb.attributes.keys.each do |key|
        if !['updated_at', 'created_at', 'id', 'sp_i_state'].include?(key) and @sp_bsb.respond_to?("#{key}=")
          @sp_bsb.send("#{key}=", @pad_sp_bsb[key])
        end
      end

      @sp_bsb.sp_i_state = 1

      if @sp_bsb.save && @pad_sp_bsb.update_attributes(:sp_i_state => ::PadSpBsb::Step::SAMPLE_ACCEPTED)
        redirect_to "/sp_bsbs/#{@sp_bsb.id}/edit", :flash => {:notice => "成功接收该样品！"}
      else
        redirect_to :back, :flash => {:error => "接收样品失败！"}
      end
    else
      redirect_to :back, :flash => {:error => "无权限执行该操作"}
    end
  end

  def refuse_sample
    @pad_sp_bsb = PadSpBsb.find(params[:id])
    if current_user.jg_bsb.all_names.include?(@pad_sp_bsb.sp_s_43) and @pad_sp_bsb.sp_i_state == ::PadSpBsb::Step::FINISHED
      if @pad_sp_bsb.update_attributes(:sp_i_state => ::PadSpBsb::Step::SAMPLE_REFUSED)
        redirect_to :back, :flash => {:notice => "成功拒收该样品！"}
      else
        redirect_to :back, :flash => {:error => "拒收样品失败！"}
      end
    else
      redirect_to :back, :flash => {:error => "无权限执行该操作"}
    end
  end

  # GET /pad_sp_bsbs/1
  # GET /pad_sp_bsbs/1.json
  def show
    sp_bsb = PadSpBsb.find(params[:id])
    #2015-01-12
    if data_owner(sp_bsb)==0
      @hit='无权限访问，如有问题请反馈秘书处！'
      respond_to do |format|
        format.html { render :text => @hit }
      end
      return
    end
    @sp_bsb=sp_bsb
    @sp_jcxcount=@sp_bsb.sp_n_jcxcount
    @sp_data=Spdatum.where(sp_bsb_id: params[:id])
    if @sp_jcxcount==nil
      @sp_jcxcount=1
    end
  end

  # GET /pad_sp_bsbs/new
  # GET /pad_sp_bsbs/new.json
  def new
    flash[:import_result] =nil
    @sp_bsb = PadSpBsb.new

    @sp_bsb.sp_s_70 = "抽检监测(总局本级)"
    @sp_bsb.sp_s_33='塑料袋'
    @sp_bsb.sp_s_63='预包装'
    @sp_bsb.sp_s_66='月'
    @sp_bsb.tname = current_user.name
    @sp_bsb.user_id = current_user.id
    @sp_bsb.uid = current_user.uid
    @sp_bsb.sp_s_3=current_user.user_s_province
    @sp_bsb.sp_s_35=current_user.jg_bsb.jg_name
    # @sp_bsb.sp_s_37=session[:user_tname]
    @sp_bsb.sp_s_39=current_user.tel
    @sp_bsb.sp_s_52=current_user.user_s_province

    if params[:rwly].to_i != 0
      if params[:rwly].to_i == -1
        @sp_bsb.sp_s_2_1 = "#{SysConfig.get(SysConfig::Key::PROV)}食品药品监督管理局"
      else
        @sp_bsb.sp_s_2_1 = SysProvince.level1.find(params[:rwly].to_i).name + '食品药品监督管理局'
      end
      @sp_bsb.sys_province_id = params[:rwly].to_i
    end


    @jg_bsb = current_user.jg_bsb

    if !params[:cp].blank? # and params[:cp][:product_id].blank?
      @sp_bsb.sp_s_70 = params[:cp][:sp_s_70] unless params[:cp][:sp_s_70].blank?
      @sp_bsb.sp_s_67 = params[:cp][:sp_s_67] unless params[:cp][:sp_s_67].blank?
      @sp_bsb.sp_s_17 = params[:cp][:sp_s_17] unless params[:cp][:sp_s_17].blank?
      @sp_bsb.sp_s_18 = params[:cp][:sp_s_18] unless params[:cp][:sp_s_18].blank?
      @sp_bsb.sp_s_19 = params[:cp][:sp_s_19] unless params[:cp][:sp_s_19].blank?
      @sp_bsb.sp_s_20 = params[:cp][:sp_s_20] unless params[:cp][:sp_s_20].blank?
      @sp_bsb.sp_s_202 = params[:cp][:sp_s_3] unless params[:cp][:sp_s_3].blank?

      @baogao_a = BaosongA.find_by_name(@sp_bsb.sp_s_70)
      @baogao_b = BaosongB.where(:baosong_a_id => @baogao_a.id, :name => @sp_bsb.sp_s_67).last
      @tasks = TaskJgBsb.where(:jg_bsb_id => @jg_bsb.id, identifier: @baogao_b.identifier)

      # 产品信息
      if !params[:cp][:product_id].blank?
        @product_info = SpProductionInfo.find(params[:cp][:product_id])
        @sp_bsb.sp_s_14 = @product_info.cpmc
        @sp_bsb.sp_s_13 = @product_info.scbh
        @sp_bsb.sp_s_64 = @product_info.qymc
        @sp_bsb.sp_s_65 = @product_info.scdz
        @sp_bsb.sp_s_202 = @product_info.sp_s_3
      end
    end

    if !params[:qy].blank?

      @sp_bsb.sp_s_3 = params[:qy][:sp_s_3] unless params[:qy][:sp_s_3].blank?
      @sp_bsb.sp_s_4 = params[:qy][:sp_s_4] unless params[:qy][:sp_s_4].blank?
      @sp_bsb.sp_s_5 = params[:qy][:sp_s_5] unless params[:qy][:sp_s_5].blank?
      @sp_bsb.sp_s_68 = params[:qy][:sp_s_68] unless params[:qy][:sp_s_68].blank?

      # 企业信息
      if !params[:qy][:company_id].blank?
        @company_info = SpCompanyInfo.find(params[:qy][:company_id])
        @sp_bsb.sp_s_1 = @company_info.sp_s_1
        @sp_bsb.sp_s_68 = @company_info.sp_s_68
        @sp_bsb.sp_s_2 = @company_info.sp_s_2
        @sp_bsb.sp_s_23 = @company_info.sp_s_23
        @sp_bsb.sp_s_215 = @company_info.sp_s_215
        @sp_bsb.sp_s_bsfl = @company_info.sp_s_bsfl
        @sp_bsb.sp_s_201 = @company_info.sp_s_201
        @sp_bsb.sp_s_7 = @company_info.sp_s_7
        @sp_bsb.sp_s_10 = @company_info.sp_s_10
        @sp_bsb.sp_s_8 = @company_info.sp_s_8
        @sp_bsb.sp_s_9 = @company_info.sp_s_9
        @sp_bsb.sp_s_11 = @company_info.sp_s_11
        @sp_bsb.sp_s_12 = @company_info.sp_s_12
      end
    end

    temp=JgBsb.find_by_jg_name(current_user.jg_bsb.jg_name)
    if temp
      @sp_bsb.sp_s_40=temp.jg_contacts
      @sp_bsb.sp_s_41=temp.jg_tel
      @sp_bsb.sp_s_42=temp.jg_email
      @sp_bsb.sp_s_52=temp.jg_province
      @sp_bsb.sp_s_211=temp.jg_address
      # TODO: 增加这俩字段? 2015-04-18
      # @sp_bsb.sp_s_212=temp.jg_postcode
      # @sp_bsb.sp_s_213=temp.jg_fax
    end
    @sp_bsb.sp_i_state=0;
    @sp_bsb.sp_d_86=(Time.now).year.to_s+'-'+(Time.now).mon.to_s+'-'+(Time.now).day.to_s
    @sp_jcxcount=1

    # 采样人员
    @sampling_users = User.where("jg_bsb_id = ? and pad_permission & ? > 0", current_user.jg_bsb_id, ::User::PadPermission::ZXCY)

    unless @sp_bsb.sp_s_70.blank?
      @sp_s_67s = BaosongB.where(baosong_a_id: BaosongA.find_by_name(@sp_bsb.sp_s_70).id)
    else
      @sp_s_67s = []
    end

    if !@sp_s_67s.blank? and !@sp_bsb.sp_s_67.blank?
      @sp_s_67 = @sp_s_67s.where(name: @sp_bsb.sp_s_67).first
    end

    unless @sp_s_67.nil?
      @a_categories = ACategory.where(:identifier => @sp_s_67.identifier)
    else
      @a_categories = []
    end

    if !@sp_bsb.sp_s_17.blank? and !@sp_bsb.sp_s_17.eql?("请选择")
      @b_categories = BCategory.where(:identifier => @sp_s_67.identifier, a_category_id: @a_categories.where(name: @sp_bsb.sp_s_17).first.id)
    else
      @b_categories = []
    end

    if !@sp_bsb.sp_s_18.blank? and !@sp_bsb.sp_s_18.eql?("请选择")
      @c_categories = CCategory.where(:identifier => @sp_s_67.identifier, b_category_id: @b_categories.where(name: @sp_bsb.sp_s_18).first.id)
    else
      @c_categories = []
    end

    if !@sp_bsb.sp_s_19.blank? and !@sp_bsb.sp_s_19.eql?("请选择")
      @d_categories = DCategory.where(:identifier => @sp_s_67.identifier, c_category_id: @c_categories.where(name: @sp_bsb.sp_s_19).first.id)
    else
      @d_categories = []
    end


    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sp_bsb }
    end
  end

  # GET /pad_sp_bsbs/1/edit
  def edit
    sp_bsb = PadSpBsb.find(params[:id])
    @jg_bsb = current_user.jg_bsb
    @tasks = TaskJgBsb.where(:jg_bsb_id => @jg_bsb.id)

    # 采样人员
    @sampling_users = User.where('jg_bsb_id = ? and pad_permission & ? > 0', current_user.jg_bsb_id, ::User::PadPermission::ZXCY)

    # 任务来源
    @rwly = []
    @tasks.joins('LEFT JOIN sys_provinces on sys_provinces.id=task_jg_bsbs.sys_province_id').select('distinct(task_jg_bsbs.sys_province_id), sys_provinces.name').each do |task|
      if task.sys_province_id == -1
        @rwly.unshift(["#{SysConfig.get(SysConfig::Key::PROV)}食品药品监督管理局", task.sys_province_id])
      else
        @rwly.push(["#{task.name}食品药品监督管理局", task.sys_province_id])
      end
    end
    #2015-01-12
    if data_owner(sp_bsb)==0
      @hit='无权限访问，如有问题请反馈秘书处！'
      respond_to do |format|
        format.html { render :text => @hit }
      end
      return
    end
    @sp_bsb=sp_bsb
    @sp_jcxcount=@sp_bsb.sp_n_jcxcount
    @sp_bsb.sp_s_55=''
    if @sp_jcxcount==nil
      @sp_jcxcount=1
    end
    if @sp_bsb.blank?
      @sp_bsb.sp_s_85 = current_user.tname
      @sp_bsb.sp_s_87 = current_user.tel
      @sp_bsb.sp_s_88 = current_user.eaddress
    end
    @sp_data=Spdatum.where(sp_bsb_id: params[:id])

    unless @sp_bsb.sp_s_70.blank?
      @sp_s_67s = BaosongB.where(baosong_a_id: BaosongA.find_by_name(@sp_bsb.sp_s_70).id)
    else
      @sp_s_67s = []
    end

    if !@sp_s_67s.blank? and !@sp_bsb.sp_s_67.blank?
      @sp_s_67 = @sp_s_67s.where(name: @sp_bsb.sp_s_67).first
    end

    unless @sp_s_67.nil?
      @a_categories = ACategory.where(:identifier => @sp_s_67.identifier)
    else
      @a_categories = []
    end

    if !@sp_bsb.sp_s_17.blank? and !@sp_bsb.sp_s_17.eql?("请选择")
      @b_categories = BCategory.where(:identifier => @sp_s_67.identifier, a_category_id: @a_categories.where(name: @sp_bsb.sp_s_17).first.id)
    else
      @b_categories = []
    end

    if !@sp_bsb.sp_s_18.blank? and !@sp_bsb.sp_s_18.eql?("请选择")
      @c_categories = CCategory.where(:identifier => @sp_s_67.identifier, b_category_id: @b_categories.where(name: @sp_bsb.sp_s_18).first.id)
    else
      @c_categories = []
    end

    if !@sp_bsb.sp_s_19.blank? and !@sp_bsb.sp_s_19.eql?("请选择")
      @d_categories = DCategory.where(:identifier => @sp_s_67.identifier, c_category_id: @c_categories.where(name: @sp_bsb.sp_s_19).first.id)
    else
      @d_categories = []
    end

    @pictures = SpBsbPicture.where(:sp_bsb_id => @sp_bsb.id).order('sort_index ASC')
  end

  # POST /pad_sp_bsbs
  # POST /pad_sp_bsbs.json
  def create
    @sp_bsb = PadSpBsb.new(pad_sp_bsb_params)
    @sp_bsb.session = session

    # 填充任务下达相关信息
    # @province = SysProvince.find_by_name(session[:user_province])
    # @sp_bsb.sys_province_id = params[:pad_sp_bsb][:sp_s_2_1].to_i

    @jg = current_user.jg_bsb
    @sp_bsb.jg_bsb_id = @jg.id

    @a_category = ACategory.find_by_name(@sp_bsb.sp_s_17)
    @sp_bsb.a_category_id = @a_category.id
    # /填充结束

    # @sp_bsb.tname = current_user.name
    @sp_bsb.user_id = current_user.id
    @sp_bsb.uid = current_user.uid
    @sp_bsb.sp_s_52 = current_user.user_s_province
    @sp_bsb.sp_s_37 = User.find(@sp_bsb.sp_s_37_user_id).tname

    @check_existance = PadSpBsb.find_by_sp_s_16(params[:pad_sp_bsb][:sp_s_16])

    respond_to do |format|
      if @check_existance != nil
        flash[:import_result] = "保存不成功，数据库中已有该样品编号!"
        format.json { render :json => {:status => "保存出错!", :msg => "保存不成功，数据库中已有该样品编号!"} }
        format.html { render action: "new" }
      else
        if @sp_bsb.sp_s_70 == '抽检监测(总局本级)'
          # 任务来源
          rwly = SpStandard.find(:first, :conditions => ["sp_sta_0=?", @sp_bsb.sp_s_20])
          if rwly
            @sp_bsb.sp_s_56 = rwly.sp_sta_1
          end
        else
          @sp_bsb.sp_s_56 = '三司'
        end

        @sp_bsb.submit_d_flag = @sp_bsb.updated_at

        ActiveRecord::Base.transaction do
          if @sp_bsb.save
=begin
            params[:spdata].delete_if{|data| data.keys.length == 1}
            params[:spdata].each do |data|
              data.delete(:id)
              data[:sp_bsb_id] = @sp_bsb.id
              Spdatum.create!(data)
            end
=end

            format.json { render :json => {:status => "OK", :msg => "保存成功!", :state => @sp_bsb.sp_i_state} }
            format.html { redirect_to(:action => "check", :controller => "tasks") }
          else
            format.json { render :json => {:status => "ERR", :msg => "发生异常，保存不成功!#{@sp_bsb.errors.first.last}", :state => @sp_bsb.sp_i_state} }
            format.html { render action: "new" }
          end
        end
      end
    end
  end

  # PUT /pad_sp_bsbs/1
  # PUT /pad_sp_bsbs/1.json
  def update
    @sp_bsb=PadSpBsb.find(params[:id])
    @sp_bsb.session = session
    @check_existance = PadSpBsb.find_by_sp_s_16(params[:pad_sp_bsb][:sp_s_16])

    if @sp_bsb.sp_i_state == ::PadSpBsb::Step::TMP_SAVE

      if (@sp_bsb.sp_s_16 == params[:pad_sp_bsb][:sp_s_16]) || (@check_existance == nil)
        respond_to do |format|
          if @sp_bsb.update_attributes(pad_sp_bsb_params)
=begin
            params[:spdata].delete_if{|data| data.keys.length == 1}
            createlog=0
            params[:spdata].each do |data|
              if data[:id]==nil
                createlog=1
                break
              end
            end
            if createlog==1
              @sp_bsb.spdata.destroy_all
              params[:spdata].each do |data|
                data.delete(:id)
                data[:sp_bsb_id] = params[:id]
                Spdatum.create!(data)
              end
            else
              params[:spdata].each do |data|
                @spdata = Spdatum.find(data[:id])
                @spdata.update_attributes(data)
              end
            end
=end
            format.json { render :json => {:status => "保存成功!", :msg => "保存成功!"} }
            format.html { redirect_to "/tasks/check" }
          else
            format.html { render action: "edit" }
            format.json { render json: @sp_bsb.errors, status: :unprocessable_entity }
          end
        end
      else
        respond_to do |format|
          flash[:import_result] ="修改不成功，数据库中已有该样品编号!"
          @sp_bsb = PadSpBsb.new(params[:pad_sp_bsb])
          @sp_data = params[:spdata]
          format.html { redirect_to :action => "edit", :id => params[:id] }
        end
      end
    elsif @sp_bsb.sp_i_state == ::PadSpBsb::Step::FINISHED
      if params[:pad_sp_bsb][:accept_or_not].to_i == 1

        if params[:pad_sp_bsb][:cyd_file].blank? or params[:pad_sp_bsb][:cyjygzs_file].blank?
          redirect_to :back, :flash => {error: "请填写完整【抽样单电子版】和【抽样检验告知书电子版】"}
          return
        end

        if current_user.user_d_authority == 1 and current_user.jg_bsb.all_names.include?(@sp_bsb.sp_s_43) and @sp_bsb.sp_i_state == ::PadSpBsb::Step::FINISHED
          params[:pad_sp_bsb][:sp_i_state] = ::PadSpBsb::Step::SAMPLE_ACCEPTED

          if @sp_bsb.update_attributes(pad_sp_bsb_params)
            @sp_bsb_new = SpBsb.new
            @sp_bsb.attributes.keys.each do |key|
              if !['updated_at', 'created_at', 'id', 'sp_i_state'].include?(key) and @sp_bsb_new.respond_to?("#{key}=")
                @sp_bsb_new.send("#{key}=", @sp_bsb[key])
              end
            end

            @sp_bsb_new.sp_i_state = 1
            @sp_bsb_new.tname = current_user.tname
            @sp_bsb_new.user_id = current_user.id
            @sp_bsb_new.uid = current_user.uid

            if @sp_bsb_new.save
              redirect_to "/sp_bsbs/#{@sp_bsb_new.id}/edit", :flash => {:notice => "成功接收该样品！"}
            else
              redirect_to :back, :flash => {:error => "接收样品失败！"}
            end
          else
            redirect_to :back, :flash => {:error => "接收样品失败, ERROR: 2！#{@sp_bsb.errors.first.last.as_json}"}
          end
        else
          redirect_to :back, :flash => {:error => "无权限执行该操作"}
        end
      elsif params[:pad_sp_bsb][:accept_or_not].to_i == 0
        if params[:pad_sp_bsb][:refuse_reason].blank? or params[:pad_sp_bsb][:accept_file].blank?
          redirect_to :back, :flash => {error: "请填写完整【拒绝信息】和【电子附件】"}
        else
          if current_user.jg_bsb.all_names.include?(@sp_bsb.sp_s_43) and @sp_bsb.sp_i_state == ::PadSpBsb::Step::FINISHED

            params[:pad_sp_bsb][:sp_i_state] = ::PadSpBsb::Step::SAMPLE_REFUSED

            if @sp_bsb.update_attributes(pad_sp_bsb_params)
              redirect_to :back, :flash => {:notice => "成功拒收该样品！"}
            else
              redirect_to :back, :flash => {:error => "拒收样品失败！#{@sp_bsb.errors.first.last.as_json}"}
            end
          else
            redirect_to :back, :flash => {:error => "无权限执行该操作"}
          end
        end
			else
				redirect_to :back, flash: { error: '状态未知' }
      end
    end
  end

  def accept_file
    @sp_bsb = PadSpBsb.find(params[:id])
    send_file("#{@sp_bsb.accept_file}", :filename => "#{@sp_bsb.sp_s_16}拒收#{File.extname(@sp_bsb.accept_file)}", :disposition => 'inline')
  end

  def cyd
    @sp_bsb = PadSpBsb.find(params[:id])
    send_file("#{@sp_bsb.cyd_file}", :filename => "#{@sp_bsb.sp_s_16}抽样单电子版#{File.extname(@sp_bsb.cyd_file)}", :disposition => 'inline')
  end

  def cyjygzs
    @sp_bsb = PadSpBsb.find(params[:id])
    send_file("#{@sp_bsb.cyjygzs_file}", :filename => "#{@sp_bsb.sp_s_16}抽样检验告知书#{File.extname(@sp_bsb.cyjygzs_file)}", :disposition => 'inline')
  end

  def picture
    @picture = SpBsbPicture.where(:sp_bsb_id => params[:id], :sort_index => params[:sort_index]).last
    respond_to do |format|
      format.html do
        render 'pad_sp_bsbs/picture'
      end
      format.jpeg do
        if !@picture.blank?
          if params[:rotate].blank? || params[:rotate].to_i == 0
            send_file @picture.absolute_path, :disposition => 'inline', :filename => "#{@picture.md5}.jpeg"
          else
            degree = 90 * params[:rotate].to_i
            img_orig = ::Magick::Image.read(@picture.absolute_path).first
            img = img_orig.rotate(degree)
            send_data(img.to_blob, :filename => "#{@picture.md5}.jpg", :disposition => 'inline')
          end
        else
          render :text => 'sorry.'
        end
      end
    end
  end

  # DELETE /pad_sp_bsbs/1
  # DELETE /pad_sp_bsbs/1.json
  def destroy
    @sp_bsb = PadSpBsb.find(params[:id])
    @sp_bsb.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  # get /pad_sp_bsbs/submit
  def submit
    @sp_bsb = PadSpBsb.find(params[:id])
    @sp_bsb.update_attribute(:sp_i_state, 1)
    respond_to do |format|
      format.html { redirect_to "/pad_sp_bsbs_spsearch?page=#{session[:sp_page]}" }
    end
  end

  private
  def pad_sp_bsb_params
    params.require(:pad_sp_bsb).permit(:report_path, :sp_s_1, :sp_s_2, :sp_s_3, :sp_s_4, :sp_s_5, :sp_s_6, :sp_s_7, :sp_s_8, :sp_s_9, :sp_s_10, :sp_s_11, :sp_s_12, :sp_s_13, :sp_s_14, :sp_n_15, :sp_s_16, :sp_s_17, :sp_s_18, :sp_s_19, :sp_s_20, :sp_s_21, :sp_d_22, :sp_s_23, :sp_s_24, :sp_s_25, :sp_s_26, :sp_s_27, :sp_d_28, :sp_n_29, :sp_s_30, :sp_n_31, :sp_n_32, :sp_s_33, :sp_s_34, :sp_s_35, :sp_s_36, :sp_s_37, :sp_d_38, :sp_s_39, :sp_s_40, :sp_s_41, :sp_s_42, :sp_s_43, :sp_s_44, :sp_s_45, :sp_d_46, :sp_d_47, :sp_s_48, :sp_s_49, :sp_s_50, :sp_s_51, :sp_s_52, :sp_s_53, :sp_s_54, :sp_s_55, :sp_s_56, :sp_s_57, :sp_s_58, :sp_s_59, :sp_s_60, :sp_s_61, :sp_s_62, :sp_s_63, :sp_s_64, :sp_s_65, :sp_s_66, :sp_s_67, :sp_s_68, :sp_s_69, :sp_s_70, :sp_s_71, :sp_s_72, :sp_s_73, :sp_s_74, :sp_s_75, :sp_s_76, :sp_s_77, :sp_s_78, :sp_s_79, :sp_s_80, :sp_s_81, :sp_s_82, :sp_s_83, :sp_s_84, :sp_s_85, :sp_d_86, :sp_s_87, :sp_s_88, :user_id, :uid,
                                       :sp_n_jcxcount,
																			 :sp_s_37_user_id,
                                       :cyd_file, :cyjygzs_file,
                                       :yydj_enabled_by_admin_at,
                                       :sp_s_bsfl,
                                       :sp_s_2_1,
                                       :sp_s_18_1,
                                       :sp_s_30_1,
                                       :sp_s_33_1,
                                       :sp_s_110_1,
                                       :sp_s_110_2,
                                       :sp_s_110_3,
                                       :sp_s_110_4,
                                       :sp_s_110_5,
                                       :sp_s_110_6,
                                       :sp_s_110_7,
                                       :sp_s_110_8,
                                       :sp_s_111_1,
                                       :sp_s_111_2,
                                       :sp_s_111_3,
                                       :sp_s_111_4,
                                       :sp_s_111_5,
                                       :sp_s_111_6,
                                       :sp_s_111_7,
                                       :sp_s_111_8,
                                       :sp_s_112_1,
                                       :sp_s_112_2,
                                       :sp_s_112_3,
                                       :sp_s_112_4,
                                       :sp_s_112_5,
                                       :sp_s_112_6,
                                       :sp_s_112_7,
                                       :sp_s_112_8,
                                       :sp_s_113_1,
                                       :sp_s_113_2,
                                       :sp_s_113_3,
                                       :sp_s_113_4,
                                       :sp_s_113_5,
                                       :sp_s_113_6,
                                       :sp_s_113_7,
                                       :sp_s_113_8,
                                       :sp_s_114_1,
                                       :sp_s_114_2,
                                       :sp_s_114_3,
                                       :sp_s_114_4,
                                       :sp_s_114_5,
                                       :sp_s_114_6,
                                       :sp_s_114_7,
                                       :sp_s_114_8,
                                       :sp_s_115_1,
                                       :sp_s_115_2,
                                       :sp_s_115_3,
                                       :sp_s_115_4,
                                       :sp_s_115_5,
                                       :sp_s_115_6,
                                       :sp_s_115_7,
                                       :sp_s_115_8,
                                       :sp_s_116_1,
                                       :sp_s_116_2,
                                       :sp_s_116_3,
                                       :sp_s_116_4,
                                       :sp_s_116_5,
                                       :sp_s_116_6,
                                       :sp_s_116_7,
                                       :sp_s_116_8,
                                       :sp_s_117_1,
                                       :sp_s_117_2,
                                       :sp_s_117_3,
                                       :sp_s_117_4,
                                       :sp_s_117_5,
                                       :sp_s_117_6,
                                       :sp_s_117_7,
                                       :sp_s_117_8,
                                       :sp_s_118_1,
                                       :sp_s_118_2,
                                       :sp_s_118_3,
                                       :sp_s_118_4,
                                       :sp_s_118_5,
                                       :sp_s_118_6,
                                       :sp_s_118_7,
                                       :sp_s_118_8,
                                       :sp_s_119_1,
                                       :sp_s_119_2,
                                       :sp_s_119_3,
                                       :sp_s_119_4,
                                       :sp_s_119_5,
                                       :sp_s_119_6,
                                       :sp_s_119_7,
                                       :sp_s_119_8,
                                       :sp_s_120_1,
                                       :sp_s_120_2,
                                       :sp_s_120_3,
                                       :sp_s_120_4,
                                       :sp_s_120_5,
                                       :sp_s_120_6,
                                       :sp_s_120_7,
                                       :sp_s_120_8,
                                       :sp_s_121_1,
                                       :sp_s_121_2,
                                       :sp_s_121_3,
                                       :sp_s_121_4,
                                       :sp_s_121_5,
                                       :sp_s_121_6,
                                       :sp_s_121_7,
                                       :sp_s_121_8,
                                       :sp_s_122_1,
                                       :sp_s_122_2,
                                       :sp_s_122_3,
                                       :sp_s_122_4,
                                       :sp_s_122_5,
                                       :sp_s_122_6,
                                       :sp_s_122_7,
                                       :sp_s_122_8,
                                       :sp_s_123_1,
                                       :sp_s_123_2,
                                       :sp_s_123_3,
                                       :sp_s_123_4,
                                       :sp_s_123_5,
                                       :sp_s_123_6,
                                       :sp_s_123_7,
                                       :sp_s_123_8,
                                       :sp_s_124_1,
                                       :sp_s_124_2,
                                       :sp_s_124_3,
                                       :sp_s_124_4,
                                       :sp_s_124_5,
                                       :sp_s_124_6,
                                       :sp_s_124_7,
                                       :sp_s_124_8,
                                       :sp_s_125_1,
                                       :sp_s_125_2,
                                       :sp_s_125_3,
                                       :sp_s_125_4,
                                       :sp_s_125_5,
                                       :sp_s_125_6,
                                       :sp_s_125_7,
                                       :sp_s_125_8,
                                       :sp_s_126_1,
                                       :sp_s_126_2,
                                       :sp_s_126_3,
                                       :sp_s_126_4,
                                       :sp_s_126_5,
                                       :sp_s_126_6,
                                       :sp_s_126_7,
                                       :sp_s_126_8,
                                       :sp_s_127_1,
                                       :sp_s_127_2,
                                       :sp_s_127_3,
                                       :sp_s_127_4,
                                       :sp_s_127_5,
                                       :sp_s_127_6,
                                       :sp_s_127_7,
                                       :sp_s_127_8,
                                       :sp_s_128_1,
                                       :sp_s_128_2,
                                       :sp_s_128_3,
                                       :sp_s_128_4,
                                       :sp_s_128_5,
                                       :sp_s_128_6,
                                       :sp_s_128_7,
                                       :sp_s_128_8,
                                       :sp_s_129_1,
                                       :sp_s_129_2,
                                       :sp_s_129_3,
                                       :sp_s_129_4,
                                       :sp_s_129_5,
                                       :sp_s_129_6,
                                       :sp_s_129_7,
                                       :sp_s_129_8,
                                       :sp_s_130_1,
                                       :sp_s_130_2,
                                       :sp_s_130_3,
                                       :sp_s_130_4,
                                       :sp_s_130_5,
                                       :sp_s_130_6,
                                       :sp_s_130_7,
                                       :sp_s_130_8,
                                       :sp_s_131_1,
                                       :sp_s_131_2,
                                       :sp_s_131_3,
                                       :sp_s_131_4,
                                       :sp_s_131_5,
                                       :sp_s_131_6,
                                       :sp_s_131_7,
                                       :sp_s_131_8,
                                       :sp_s_132_1,
                                       :sp_s_132_2,
                                       :sp_s_132_3,
                                       :sp_s_132_4,
                                       :sp_s_132_5,
                                       :sp_s_132_6,
                                       :sp_s_132_7,
                                       :sp_s_132_8,
                                       :sp_s_133_1,
                                       :sp_s_133_2,
                                       :sp_s_133_3,
                                       :sp_s_133_4,
                                       :sp_s_133_5,
                                       :sp_s_133_6,
                                       :sp_s_133_7,
                                       :sp_s_133_8,
                                       :sp_s_134_1,
                                       :sp_s_134_2,
                                       :sp_s_134_3,
                                       :sp_s_134_4,
                                       :sp_s_134_5,
                                       :sp_s_134_6,
                                       :sp_s_134_7,
                                       :sp_s_134_8,
                                       :sp_s_135_1,
                                       :sp_s_135_2,
                                       :sp_s_135_3,
                                       :sp_s_135_4,
                                       :sp_s_135_5,
                                       :sp_s_135_6,
                                       :sp_s_135_7,
                                       :sp_s_135_8,
                                       :sp_s_136_1,
                                       :sp_s_136_2,
                                       :sp_s_136_3,
                                       :sp_s_136_4,
                                       :sp_s_136_5,
                                       :sp_s_136_6,
                                       :sp_s_136_7,
                                       :sp_s_136_8,
                                       :sp_s_137_1,
                                       :sp_s_137_2,
                                       :sp_s_137_3,
                                       :sp_s_137_4,
                                       :sp_s_137_5,
                                       :sp_s_137_6,
                                       :sp_s_137_7,
                                       :sp_s_137_8,
                                       :sp_s_138_1,
                                       :sp_s_138_2,
                                       :sp_s_138_3,
                                       :sp_s_138_4,
                                       :sp_s_138_5,
                                       :sp_s_138_6,
                                       :sp_s_138_7,
                                       :sp_s_138_8,
                                       :sp_s_139_1,
                                       :sp_s_139_2,
                                       :sp_s_139_3,
                                       :sp_s_139_4,
                                       :sp_s_139_5,
                                       :sp_s_139_6,
                                       :sp_s_139_7,
                                       :sp_s_139_8,
                                       :sp_s_140_1,
                                       :sp_s_140_2,
                                       :sp_s_140_3,
                                       :sp_s_140_4,
                                       :sp_s_140_5,
                                       :sp_s_140_6,
                                       :sp_s_140_7,
                                       :sp_s_140_8,
                                       :sp_s_110_9,
                                       :sp_s_111_9,
                                       :sp_s_112_9,
                                       :sp_s_113_9,
                                       :sp_s_114_9,
                                       :sp_s_115_9,
                                       :sp_s_116_9,
                                       :sp_s_117_9,
                                       :sp_s_118_9,
                                       :sp_s_119_9,
                                       :sp_s_120_9,
                                       :sp_s_121_9,
                                       :sp_s_122_9,
                                       :sp_s_123_9,
                                       :sp_s_124_9,
                                       :sp_s_125_9,
                                       :sp_s_126_9,
                                       :sp_s_127_9,
                                       :sp_s_128_9,
                                       :sp_s_129_9,
                                       :sp_s_130_9,
                                       :sp_s_131_9,
                                       :sp_s_132_9,
                                       :sp_s_133_9,
                                       :sp_s_134_9,
                                       :sp_s_135_9,
                                       :sp_s_136_9,
                                       :sp_s_137_9,
                                       :sp_s_138_9,
                                       :sp_s_139_9,
                                       :sp_s_140_9,
                                       :sp_s_110_0,
                                       :sp_s_111_0,
                                       :sp_s_112_0,
                                       :sp_s_113_0,
                                       :sp_s_114_0,
                                       :sp_s_115_0,
                                       :sp_s_116_0,
                                       :sp_s_117_0,
                                       :sp_s_118_0,
                                       :sp_s_119_0,
                                       :sp_s_120_0,
                                       :sp_s_121_0,
                                       :sp_s_122_0,
                                       :sp_s_123_0,
                                       :sp_s_124_0,
                                       :sp_s_125_0,
                                       :sp_s_126_0,
                                       :sp_s_127_0,
                                       :sp_s_128_0,
                                       :sp_s_129_0,
                                       :sp_s_130_0,
                                       :sp_s_131_0,
                                       :sp_s_132_0,
                                       :sp_s_133_0,
                                       :sp_s_134_0,
                                       :sp_s_135_0,
                                       :sp_s_136_0,
                                       :sp_s_137_0,
                                       :sp_s_138_0,
                                       :sp_s_139_0,
                                       :sp_s_140_0,
                                       :sp_i_state,
                                       :sp_i_jgback,
                                       :sp_i_backtimes,
                                       :sp_s_reason,
                                       :submit_d_flag,
                                       :sp_t_procedure,
                                       :sp_s_200,
                                       :sp_s_201,
                                       :sp_s_202,
                                       :sp_s_203,
                                       :sp_s_204,
                                       :sp_s_205,
                                       :sp_s_206,
                                       :sp_s_207,
                                       :sp_s_208,
                                       :sp_s_209,
                                       :sp_s_210,
                                       :sp_s_211,
                                       :sp_s_212,
                                       :sp_s_213,
                                       :sp_s_214,
                                       :sp_s_215,
                                       :fail_report_path,
                                       :fail_report_at,
                                       :sys_province_id,
                                       :bgfl,
                                       :sp_xkz,
                                       :sp_xkz_id,
                                       :updated_at,
                                       :czb_reverted_flag,
                                       :synced, :ca_source, :ca_sign,:sp_s_220,:sp_s_221,:sp_s_222

    )

  end
end
