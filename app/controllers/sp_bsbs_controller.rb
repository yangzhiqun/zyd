#encoding=UTF-8
require 'csv'
require 'net/http'

class SpBsbsController < ApplicationController
  include ApplicationHelper

  before_action :init, only: [:new, :edit, :update, :create, :show]

 def print
    @spbsb = SpBsb.find(params[:id])
    respond_to do |format|
      format.pdf {
        filepath = @spbsb.generate_bsb_report_pdf(params[:pdf_rules], false, current_user.id,false)
       if filepath.nil?
          flash[:error] = '查看报告失败'
          redirect_to '/sp_bsbs/no_available_pdf_found' and return
        else
          send_file filepath, filename: "#{@spbsb.sp_s_16}-检验报告.pdf", disposition: 'inline'
        end
      }
      format.html {
        filepath = @spbsb.generate_bsb_report_pdf(params[:pdf_rules], true, current_user.id,false)
        if filepath.nil?
          flash[:error] = '查看报告失败'
          redirect_to '/sp_bsbs/no_available_pdf_found' and return
        else
          send_file filepath, filename: "yyyy-检验报告.pdf", disposition: 'inline'
        end
      }
    end
  end

  def by_ca_info
    @spbsb = SpBsb.find(params[:id])
    preview = false
   if !params[:pr_status].blank?
       preview =  params[:pr_status]
    end
    if  !@spbsb.report_path.blank? 
       if @spbsb.ca_key_status ==0
           pdfpath=@spbsb.generate_bsb_report_pdf(params[:pdf_rules], true, current_user.id,false)
       else
          pdfpath=File.expand_path('../reports', Rails.root).to_s + @spbsb.report_path
       end
    else
     pdfpath=@spbsb.generate_bsb_report_pdf(params[:pdf_rules], preview, current_user.id,false)
    end
    
    keyword= params[:keyword] 
    signCert=params[:sign_cert]
    sealImg=params[:keypic]
    clientSignMessages=[]
    clientSignMessage ={ruleType: 1,keyword: keyword,searchOrder: '2',fileUniqueId: '111111111111',heightMoveSize: 0,moveSize: 0,moveType: 3,searchOrder: 2}
    clientSignMessages.push(clientSignMessage)
    reqMessage ={appId: '9ff70fce51874b62a5f136fdda43c4b7',sealImg: sealImg, signCert: signCert,
                    sealWidth: 0,sealHeight: 0, clientSignMessages: clientSignMessages}
    reqMessage = Base64.strict_encode64(reqMessage.to_json)
    #tmp_file = Rails.root.join('tmp', "jilin.pdf")
    filename = Rails.root.join('tmp', "sp_bsbs_#{@spbsb.id}.txt")
    cmd = "java -jar #{Rails.root.join('bin', 'mssg-pdf-client-1.1.0.jar')}  111.26.194.57 8081 108  #{reqMessage} #{pdfpath} #{filename}"
      result = `#{cmd}`
     Rails.logger.error "cmd"
    Rails.logger.error cmd
     Rails.logger.error "result"
     Rails.logger.error result

    if  result.strip.include?('200')
      signSealMessagesJson =  File.read(Rails.root.join('tmp', "sp_bsbs_#{@spbsb.id}.txt"))
      logger.error "signSealMessagesJson"
      logger.error signSealMessagesJson
      render json: {status: 'OK', msg: signSealMessagesJson}
    end
  end

  def print_pdf
    @spbsb = SpBsb.find(params[:id])
    #espond_to do |format|
   # pdfpath=File.expand_path('../reports', Rails.root).to_s + @spbsb.report_path
   if  !@spbsb.report_path.blank?
     pdfpath=File.expand_path('../reports', Rails.root).to_s + @spbsb.report_path
    else
     pdfpath=Rails.root.join('tmp', "sp_bsbs_#{@spbsb.id}_print.pdf")
    end

    sign_data=params[:sign_data]

    logger.error sign_data
    signSealMessagesJson =  File.read(Rails.root.join('tmp', "sp_bsbs_#{@spbsb.id}.txt"))
     File.write(Rails.root.join('tmp', "yang.req"),sign_data)
     writeJson= Rails.root.join('tmp', "yang.req")
     logger.error  "writeJson"
     logger.error  writeJson
    #filename = Rails.root.join('tmp', "jilin.pdf")
     reqMessage ={appId: '9ff70fce51874b62a5f136fdda43c4b7'}
     reqMessage =  Base64.strict_encode64(reqMessage.to_json)
     result = `java -jar #{Rails.root.join('bin', 'mssg-pdf-client-1.1.0.jar')}  111.26.194.57 8081 199  #{reqMessage} #{writeJson} #{pdfpath}`
     # result = `#{cmd}`
      logger.error "result"
      Rails.logger.error result
      if  result.strip.include?('200')
      logger.error signSealMessagesJson
	sp_status=params[:sp_status]
        @spbsb.update_attributes({:sp_i_state =>sp_status})
         #if sp_status=4 and @spbsb.report_path.blank?
           # report_path = "#{Time.now.strftime('/%Y/%m/%d')}/#{@spbsb.id}.pdf"
             @spbsb.update_attributes({:ca_key_status => sp_status,:sp_s_48 =>current_user.tname})
         SpLog.create(:sp_bsb_id => @spbsb.id, :sp_i_state => sp_status, :remark => "", :user_id => current_user.id,:ca_key_status => 1)
	 render json: {status: 'OK', msg: '成功'}
      end
  end



  # 食品标准
  def checkout_standard
    result = RestClient.get("http://shianbao.net:8081/spaqk/webservice/getInfo?name=%s&flag=#{params[:flag]}" % [URI.escape(params[:name])])
    result = result.gsub("[", "{").gsub("]", "}").gsub("'", '"')
    result = JSON.parse(result)
    if result.blank?
      render :json => {:status => 'ERR', :msg => result}
    else
      render :json => {:status => 'OK', :msg => result}
    end
  end

  def init
    @avala=[21, 24, 30, 33, 36, 44, 61, 62, 63, 68, 201, 203, 205]
    @options=[]
    @avala.each do |i|
      @options[i] = Flexcontent.where(flex_field: "sp_bsb_sp_s_#{i}").order("flex_sortid ASC")
      @options[i] = @options[i].map { |option| [option[:flex_name], option[:flex_id]] }.unshift(['请选择', nil])
    end

    @xkz_options=[['请选择', ''], ['经营许可证', '经营许可证'], ['生产许可证', '生产许可证']]

    #@jg_bsbs = JgBsb.where('status = 0 and jg_detection = 1', current_user.user_s_province).order('jg_province')
  end

  #2014-01-12
  def data_owner(params_data)
    if current_user.is_admin?||session[:change_js]==9||session[:change_js]==10||is_shengshi?||current_user.jg_type==1
      return 1
    end
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
    if (params_data.sp_s_18=='婴幼儿配方食品' and params_data.sp_s_70.include?('一司'))&&session[:change_js]==8&& current_user.jg_bsb_id == JgBsb.find_by_history_name('上海市质量监督检验技术研究院').id
      return 1
    end
    return 0
  end

  def count_by_sql(sql_str)
    total_temp=SpBsb.find_by_sql(sql_str)
    total_num=0
    total_temp.each do |bhg|
      total_num=bhg.total_num
    end
    return total_num
  end

  def download_file
    send_file(params[:filename], :disposition => 'attachment')
  end

  # 24H限时报告
  def xsbg
    @sp_bsb = SpBsb.find(params[:id])

    @xsbg_tt = XsbgTt.find_by_sp_bsb_id(@sp_bsb.id)

    if !@xsbg_tt.nil?
      redirect_to @xsbg_tt
    else
      @xsbg = XsbgTt.find_by_sp_bsb_id(@sp_bsb.id)
      @xsbg = XsbgTt.new(CJBH: @sp_bsb.sp_s_16, sp_bsb_id: @sp_bsb.id, GJMC: @sp_bsb.sp_s_202) if @xsbg.nil?

      @items = Spdatum.where('sp_bsb_id = ? AND (spdata_2 LIKE ? OR spdata_2 LIKE ?)', @sp_bsb.id, '%不合格%', '%问题%')
    end
  end

  # GET /sp_bsbs/1
  # GET /sp_bsbs/1.json
  def show
    sp_bsb = SpBsb.find(params[:id])

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
    @jg_bsbs = Rails.cache.fetch('jg_bsb_detection_type', expires_in: 12.hours) do
      JgBsb.where('status = 0 and jg_detection = 1', current_user.user_s_province).order('jg_province')
    end
  end

  # 推送基本数据
  def push_base_data
    ids = params[:id].split(',')
    SpBsb.where(id: ids).each do |bsb|
      bsb.push_base_data
    end

    respond_to do |format|
      format.json { render :json => {status: "OK", msg: ""} }
    end
  end

  def index
    redirect_to "/sp_bsbs_spsearch?#{session[:query]}"
  end

  # GET /sp_bsbs/new
  # GET /sp_bsbs/new.json
  def new
    @province_plus = "省"
    if ["北京", "天津", "上海", "重庆"].include?(current_user.user_s_province)
      @province_plus = "市"
    end

    if ["西藏", "内蒙古"].include?(current_user.user_s_province)
      @province_plus = "自治区"
    end

    if current_user.user_s_province == "广西"
      @province_plus = "壮族自治区"
    end

    if current_user.user_s_province == "新疆"
      @province_plus = "维吾尔自治区"
    end

    if current_user.user_s_province == "宁夏"
      @province_plus = ""
    end
  if current_user.is_admin?
      @jg_bsbs = JgBsb.select('id, jg_name, jg_contacts, jg_tel, jg_email','jg_type').where('status = 0 and jg_detection = 1', current_user.user_s_province).order('jg_province')
 else
    if current_user.jg_bsb.jg_type==1
     super_jg= JgBsbSuper.where(super_jg_bsb_id: current_user.jg_bsb.id ).group("jg_bsb_id")
        jg_names=[]
        jg_names.push(current_user.jg_bsb_id)
        super_jg.each do |j|
           jg_names.push(j.jg_bsb_id)
        end
    @jg_bsbs = JgBsb.select('id, jg_name, jg_contacts, jg_tel, jg_email','jg_type').where('status = 0 and jg_detection = 1  and id in (?)',jg_names).order('jg_province')
    elsif current_user.jg_bsb.jg_type==3
    @jg_bsbs = JgBsb.select('id, jg_name, jg_contacts, jg_tel, jg_email','jg_type').where('status = 0 and jg_detection = 1 and id in (?) ',current_user.jg_bsb_id).order('jg_province')
    end
  end
    #@jg_bsbs = JgBsb.select('id, jg_name, jg_contacts, jg_tel, jg_email','jg_type').where('status = 0 and jg_detection = 1', current_user.user_s_province).order('jg_province')
    # logger.error  @jg_bsbs.to_json
    flash[:import_result] =nil
    @sp_bsb = SpBsb.new
    @sp_bsb.user_id = current_user.id
    @sp_bsb.uid = current_user.uid
    @sp_bsb.sp_s_3 = current_user.user_s_province
    @sp_bsb.sp_s_4 = current_user.prov_city
    @sp_bsb.sp_s_35 = current_user.jg_bsb.jg_name
    @sp_bsb.sp_s_37 = current_user.tname
    @sp_bsb.sp_s_39 = current_user.tel
    @sp_bsb.sp_s_52 = current_user.user_s_province
    @sp_bsb.sp_s_71 = '未检验'
    @sp_bsb.sp_s_202 = current_user.user_s_province
    if current_user.jg_bsb
      @sp_bsb.sp_s_40 = current_user.jg_bsb.jg_contacts
      @sp_bsb.sp_s_41 = current_user.jg_bsb.jg_tel
      @sp_bsb.sp_s_42 = current_user.jg_bsb.jg_email
      @sp_bsb.sp_s_52 = current_user.jg_bsb.jg_province
      @sp_bsb.sp_s_211 = current_user.jg_bsb.jg_address
      @sp_bsb.sp_s_212 = current_user.jg_bsb.zipcode
      @sp_bsb.sp_s_213 = current_user.jg_bsb.fax

      # 筛选 送检机构 下拉选项内
=begin
     if current_user.jg_bsb.jg_type == 3
        @jg_bsbs = Rails.cache.fetch("jg_bsbs_type3.id.#{current_user.jg_bsb.id}", expires_in: 10.hours) do
          @jg_bsbs.where('id = ?', current_user.jg_bsb.id).as_json
        end
      else
        @jg_bsbs = Rails.cache.fetch("jg_bsbs_type.others.prov.#{current_user.user_s_province}", expires_in: 10.hours) do
          jg_type_1_ids = JgBsb.where(jg_province: current_user.user_s_province, jg_type: 1).pluck(:id)
          @jg_bsbs.where(jg_type: 3, id: JgBsbSuper.where(super_jg_bsb_id: jg_type_1_ids).pluck(:jg_bsb_id)).as_json
          end
=end
    end

    @sp_bsb.sp_d_86=(Time.now).year.to_s+'-'+(Time.now).mon.to_s+'-'+(Time.now).day.to_s
    @sp_jcxcount=1

    @sp_s_67s = []

    @a_categories = @b_categories = @c_categories = @d_categories = []

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sp_bsb }
    end
  end

  # GET /sp_bsbs/1/edit
  def edit
    if current_user.is_admin?
      @jg_bsbs = JgBsb.select('id, jg_name, jg_contacts, jg_tel, jg_email','jg_type').where('status = 0 and jg_detection = 1', current_user.user_s_province).order('jg_province')
 else
    if current_user.jg_bsb.jg_type==1
     super_jg= JgBsbSuper.where(super_jg_bsb_id: current_user.jg_bsb.id ).group("jg_bsb_id")
        jg_names=[]
        jg_names.push(current_user.jg_bsb_id)
        super_jg.each do |j|
           jg_names.push(j.jg_bsb_id)
        end
    @jg_bsbs = JgBsb.select('id, jg_name, jg_contacts, jg_tel, jg_email','jg_type').where('status = 0 and jg_detection = 1  and id in (?)',jg_names).order('jg_province')
    elsif current_user.jg_bsb.jg_type==3
    @jg_bsbs = JgBsb.select('id, jg_name, jg_contacts, jg_tel, jg_email','jg_type').where('status = 0 and jg_detection = 1 and id in (?) ',current_user.jg_bsb_id).order('jg_province')
    end
  end
    unless current_user.jg_bsb.nil?
      # 筛选 送检机构 下拉选项内容
=begin
      if current_user.jg_bsb.jg_type == 3
        @jg_bsbs = Rails.cache.fetch("jg_bsbs_type3.id.#{current_user.jg_bsb.id}", expires_in: 10.hours) do
          @jg_bsbs.where('id = ?', current_user.jg_bsb.id).as_json
        end
      else
        @jg_bsbs = Rails.cache.fetch("jg_bsbs_type.others.prov.#{current_user.user_s_province}", expires_in: 10.hours) do
          jg_type_1_ids = JgBsb.where(jg_province: current_user.user_s_province, jg_type: 1).pluck(:id)
          @jg_bsbs.where(jg_type: 3, id: JgBsbSuper.where(super_jg_bsb_id: jg_type_1_ids).pluck(:jg_bsb_id)).as_json
        end
      end
=end
    end
    sp_bsb = SpBsb.find(params[:id])
    #2015-01-12
    if data_owner(sp_bsb)==0
      @hit='无权限访问，如有问题请反馈秘书处！'
      respond_to do |format|
        format.html { render :text => @hit }
      end
      return
    end
    @sp_bsb = sp_bsb
    @sp_jcxcount = @sp_bsb.sp_n_jcxcount
    @sp_bsb.sp_s_55 = ''
    if @sp_jcxcount.nil?
      @sp_jcxcount = 1
    end

    if @sp_bsb.sp_s_85.blank?
      @sp_bsb.sp_s_85 = current_user.tname
      @sp_bsb.sp_s_87 = current_user.tel
      @sp_bsb.sp_s_88 = current_user.eaddress
    end

    @sp_data = Spdatum.where(sp_bsb_id: params[:id])

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

    if !@sp_bsb.sp_s_17.blank? and !@sp_bsb.sp_s_17.eql?("请选择") and !@a_categories.blank?
      @b_categories = BCategory.where(:identifier => @sp_s_67.identifier, a_category_id: @a_categories.where(name: @sp_bsb.sp_s_17).first.id)
    else
      @b_categories = []
    end

    if !@sp_bsb.sp_s_18.blank? and !@sp_bsb.sp_s_18.eql?("请选择") and !@b_categories.blank?
      @c_categories = CCategory.where(:identifier => @sp_s_67.identifier, b_category_id: @b_categories.where(name: @sp_bsb.sp_s_18).first.id)
    else
      @c_categories = []
    end

    if !@sp_bsb.sp_s_19.blank? and !@sp_bsb.sp_s_19.eql?("请选择") and !@c_categories.blank?
      @d_categories = DCategory.where(:identifier => @sp_s_67.identifier, c_category_id: @c_categories.where(name: @sp_bsb.sp_s_19).first.id)
    else
      @d_categories = []
    end
    @pad_sp_bsbs = PadSpBsb.where(:sp_s_16 => @sp_bsb.sp_s_16).first
    if @pad_sp_bsbs != nil
      @pictures = SpBsbPicture.where(:sp_bsb_id => @pad_sp_bsbs.id).order('sort_index ASC')
    end

    @jg_bsb = JgBsb.find_by_jg_name(@sp_bsb.sp_s_43)
  end

  def wtyptzs
    @sp_bsb = SpBsb.find(params[:id])
  end

  # POST /sp_bsbs
  # POST /sp_bsbs.json
  def create
    ActiveRecord::Base.transaction do
      @sp_bsb = SpBsb.new(sp_bsb_params)
      # @sp_bsb.tname = current_user.name
      @sp_bsb.user_id = current_user.id
      @sp_bsb.uid = current_user.uid
      @sp_bsb.sp_s_52 = current_user.user_s_province

      @sp_bsb.sp_s_2 = @sp_bsb.sp_s_2 || '';
      @sp_bsb.sp_s_3 = @sp_bsb.sp_s_3 || '';
      @sp_bsb.sp_s_14 = @sp_bsb.sp_s_14 || '';
      @sp_bsb.sp_s_16 = @sp_bsb.sp_s_16 || '';
      @sp_bsb.sp_s_17 = @sp_bsb.sp_s_17 || '';
      @sp_bsb.sp_s_20 = @sp_bsb.sp_s_20 || '';
      @sp_bsb.sp_s_35 = @sp_bsb.sp_s_35 || '';
      @sp_bsb.sp_s_43 = @sp_bsb.sp_s_43 || '';
      @sp_bsb.sp_s_85 = @sp_bsb.sp_s_85 || '';

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
        # if @sp_bsb.sp_s_70=='抽检监测(总局本级)'
        #   rwly=SpStandard.find(:first, :conditions => ["sp_sta_0=?", @sp_bsb.sp_s_20])
        #   if rwly
        #     @sp_bsb.sp_s_56=rwly.sp_sta_1
        #   end
        # else
        #   @sp_bsb.sp_s_56='三司'
        # end
        @sp_bsb.submit_d_flag = @sp_bsb.updated_at
	
        if @sp_bsb.changes.has_key?('sp_i_state') and @sp_bsb.changes['sp_i_state'][1] == 2  and (@sp_bsb.cyd_file.blank? or @sp_bsb.cyjygzs_file.blank?)
          format.json { render :json => {:status => "保存出错!", :msg => "请填写完整【抽样单电子版】和【抽样检验告知书电子版"} }
          format.html {
            redirect_to :back, :flash => {import_result: "请填写完整【抽样单电子版】和【抽样检验告知书电子版】"}
          }
        else
          if @sp_bsb.save
            unless params[:spdata].blank?
              params[:spdata].delete_if { |data| data.keys.length == 1 }
              params[:spdata].each do |data|
                data.delete(:id)
                data[:sp_bsb_id] = @sp_bsb.id
                Spdatum.create!(data.as_json)
              end
            end
            SpLog.create(:sp_bsb_id => @sp_bsb.id, :sp_i_state => params[:sp_bsb][:sp_i_state], :remark => @role_name, :user_id => current_user.id)
            format.json { render :json => {:status => "保存成功!", :msg => "保存成功!"} }
            format.html { redirect_to "/sp_bsbs/#{@sp_bsb.id}" }
          else
            format.json { render :json => {:status => "保存出错!", :msg => "提交失败！#{@sp_bsb.errors.first.last}"} }
            format.html {
              flash[:import_result] = "提交失败，#{@sp_bsb.errors.first.last}"
              render action: 'new'
            }
          end
        end
#         if @sp_bsb.save
#          unless params[:spdata].blank?
#            params[:spdata].delete_if { |data| data.keys.length == 1 }
#            params[:spdata].each do |data|
#              data.delete(:id)
#              data[:sp_bsb_id] = @sp_bsb.id
#              Spdatum.create!(data.as_json)
#            end
#          end
#          format.json { render :json => {:status => "保存成功!", :msg => "保存成功!"} }
#          format.html { redirect_to "/sp_bsbs/#{@sp_bsb.id}" }
#        else
#          format.json { render :json => {:status => "保存出错!", :msg => "提交失败！#{@sp_bsb.errors.first.last}"} }
#          format.html {
#            flash[:import_result] = "提交失败，#{@sp_bsb.errors.first.last}"
#            render action: 'new'
#          }
#        end
      end
    end
  end

  # PUT /sp_bsbs/1
  # PUT /sp_bsbs/1.json
  def update
    @sp_bsb = SpBsb.find(params[:id])
    #TODO: 不要过早开启事务
    ActiveRecord::Base.transaction do
      respond_to do |format|
        @original_updated_at = nil

        if (params[:sp_bsb][:sp_i_state].to_i == 9 && current_user.is_admin?)
          @role_name = '秘书处直接修改'

          # 时间不改变
          @original_updated_at = @sp_bsb.updated_at

          # NOTICE: 推测sp_i_backtimes用于记录秘书处修改次数?
          @sp_bsb.sp_i_backtimes = @sp_bsb.sp_i_backtimes.to_i + 1
          @sp_bsb.sp_s_reason = "#{@sp_bsb.sp_s_reason.to_s}#{Time.now.to_s},#{@role_name}:#{params[:sp_bsb].delete(:sp_s_55)}\n"
        end


        if (params[:sp_bsb][:sp_i_state].to_i == 3 or params[:sp_bsb][:sp_i_state].to_i == 1) and !params[:sp_bsb][:sp_s_55].blank?
          if current_user.is_admin?
            @role_name = '秘书处退回'

            @sp_bsb.sp_i_backtimes = @sp_bsb.sp_i_backtimes.to_i + 1 if @sp_bsb.sp_i_state == 9

          elsif session[:change_js] == 2

            @role_name = "药监局_#{current_user.name}_退回"

          elsif session[:change_js] == 6
            @role_name = "检测机构_填报检验数据_#{current_user.name}_退回"
          elsif session[:change_js] == 7
            @role_name = "检测机构_#{current_user.name}_退回"
          elsif session[:change_js] == 8
            @role_name = "牵头机构_#{current_user.name}_退回"
          end

          @sp_bsb.sp_i_jgback = @sp_bsb.sp_i_jgback.to_i + 1
          @sp_bsb.sp_s_reason = "#{@sp_bsb.sp_s_reason.to_s}#{Time.now.to_s},#{@role_name}:#{params[:sp_bsb].delete(:sp_s_55)}\n"
        end

        if @sp_bsb.sp_i_state != 9 && @sp_bsb.sp_i_backtimes.nil?
          @sp_bsb.submit_d_flag = Time.now.ago(3600*8).to_s(:db)
        end

        if @role_name.blank?
          @role_name = params[:commit]
        end
        @loglaststate=SpLog.where("sp_bsb_id = ? ", params[:id]).last
        if @loglaststate.nil?
          @loglaststatesign = false
        else
          if params[:sp_bsb][:sp_i_state].to_s == '9' and @loglaststate.sp_i_state.to_s == '5'
            @loglaststatesign = true
          else
            @loglaststatesign = false
          end
        end
        if @role_name.eql? '检测机构批准' or params[:sp_bsb][:sp_i_state].to_s == '6' or @loglaststatesign or params[:sp_bsb][:sp_i_state].to_s =='5' 
          @sp_bsb.sp_s_48 = current_user.tname
        end

        @sp_bsb.assign_attributes(sp_bsb_params)

        if @sp_bsb.changes.has_key?('sp_i_state') and @sp_bsb.changes['sp_i_state'][1] == 2 and [0, 1].include?(@sp_bsb.changes['sp_i_state'][0]) and (@sp_bsb.cyd_file.blank? or @sp_bsb.cyjygzs_file.blank?)
          format.json { render :json => {:status => "保存出错!", :msg => "请填写完整【抽样单电子版】和【抽样检验告知书电子版"} }
          format.html {
            redirect_to :back, :flash => {import_result: "请填写完整【抽样单电子版】和【抽样检验告知书电子版】"}
          }
        else

          if @sp_bsb.save
            # 如果original 存在，则回退updated_at时间
            if @original_updated_at.present?
              SpBsb.record_timestamps = false
              @sp_bsb.update_attributes(updated_at: @original_updated_at)
              SpBsb.record_timestamps = true
            end

            if params[:sp_bsb][:sp_i_state].to_i <= 4 || (params[:sp_bsb][:sp_i_state].to_i == 9 && current_user.is_admin?)
              unless params[:spdata].blank?
                params[:spdata].delete_if { |data| data.keys.length == 1 }
                createlog=0
                params[:spdata].each do |data|
                  if data[:id].nil?
                    createlog = 1
                    break
                  end
                end
                if createlog == 1
                  @sp_bsb.spdata.destroy_all
                  params[:spdata].each do |data|
                    data.delete(:id)
                    data[:sp_bsb_id] = params[:id]
                    Spdatum.create!(data.as_json)
                  end
                else
                  params[:spdata].each do |data|
                    @spdata = Spdatum.find(data[:id])
                    @spdata.update_attributes(data.as_json)
                  end
                end
              end
            end

            # 记录CA记录
            if !session[:userCert].blank? and !@sp_bsb.ca_sign.blank?
              SpBsbCert.create(source: @sp_bsb.ca_source, user_cert: session[:userCert], sign: @sp_bsb.ca_sign, user_id: current_user.id, sp_i_state: @sp_bsb.sp_i_state, sp_bsb_id: @sp_bsb.id)
            end

            if @role_name.blank? and !@loglaststate.nil?
              if params[:sp_bsb][:sp_i_state].to_s == '6' or (params[:sp_bsb][:sp_i_state].to_s == '9' and @loglaststate.sp_i_state.to_s == '5')
                @role_name = '检测机构批准'
              end
            end
            SpLog.create(:sp_bsb_id => params[:id], :sp_i_state => params[:sp_bsb][:sp_i_state], :remark => @role_name, :user_id => current_user.id)

            format.json { render :json => {:status => "保存成功!", :msg => "保存成功!"} }
            format.html { redirect_to("/sp_bsbs_spsearch?#{session[:query]}") }
          else
            @sp_data = params[:spdata]
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
            flash[:import_result] = @sp_bsb.errors.first.last
            @sp_bsb = SpBsb.find(@sp_bsb.id)
            format.html { render action: "edit" }
            format.json { render json: {status: '保存出错!', msg: "修改不成功! #{flash[:import_result]}"} }
          end
        end
      end
    end
  end

  # DELETE /sp_bsbs/1
  # DELETE /sp_bsbs/1.json
  def destroy
    @sp_bsb = SpBsb.find(params[:id])
    @sp_bsb.destroy

    respond_to do |format|
      format.html { redirect_to "/sp_bsbs_spsearch?#{session[:query]}" }
      format.json { head :no_content }
    end
  end

  # POST /sp_bsbs/spsearch
  # POST /sp_bsbs/spsearch.json
  def spsearch

    if request.post?
      if params[:remember].to_i == 1
        session[:query] = params.select { |k, v| !['authenticity_token', 'controller', 'action'].include?(k.to_s) }.map { |k, v| "#{k}=#{URI.encode(v)}" }.join("&")
      else
        session[:query] = nil
      end
    end

    @sp_bsbs = SpBsb.select("sp_bsbs.ca_key_status,sp_bsbs.report_path,sp_bsbs.id, sp_bsbs.updated_at, sp_bsbs.sp_s_3, sp_bsbs.sp_s_4, sp_bsbs.sp_s_14, sp_bsbs.sp_s_16, sp_bsbs.sp_s_43, sp_bsbs.sp_s_214, sp_bsbs.sp_s_35, sp_bsbs.sp_s_71, sp_bsbs.sp_s_202, sp_bsbs.sp_i_state, sp_bsbs.fail_report_path, sp_bsbs.czb_reverted_flag")
    
    if params[:r1]
      session[:change_js]=params[:r1].to_i
    end

    if params[:flag]==nil
      @tabs='tabs_1'
      params[:flag]='tabs_1'
    else
      @tabs=params[:flag]
    end
    unless params[:page].blank?
      session[:sp_page] = params[:page]
    else
      session[:sp_page] = 1
      params[:page] = 1
    end


    #	if !params[:sp_order].blank?
    #		@sp_bsbs = @sp_bsbs.order("#{params[:sp_order]} #{params[:sp_order_seq] || 'DESC'}")
    #	else
    #		@sp_bsbs = @sp_bsbs.order("updated_at #{params[:sp_order_seq] || 'DESC'}")
    #	end
    #	看起来没问题，但是测试结果不对，改成如下
    if !params[:sp_order].blank?
      @sp_bsbs = @sp_bsbs.order("#{params[:sp_order]} #{params[:sp_order_seq] || 'DESC'}")
    elsif !params[:sp_order_seq].blank?
      @sp_bsbs = @sp_bsbs.order("sp_bsbs.updated_at #{params[:sp_order_seq]}")
    else
      @sp_bsbs = @sp_bsbs.order("sp_bsbs.updated_at DESC")
    end

    @ending_time = Time.now
    @begin_time = Time.now - 3.months

    unless params[:begin_time].blank?
      @begin_time = DateTime.parse(params[:begin_time])
    end

    unless params[:ending_time].blank?
      @ending_time = DateTime.parse(params[:ending_time])
    end

    @sp_bsbs = @sp_bsbs.where("sp_bsbs.updated_at BETWEEN ? AND ?", @begin_time.beginning_of_day, @ending_time.end_of_day)

    if params[:flag]=="tabs_3"
      respond_to do |format|
        format.html { render action: "index" }
        format.json { render json: @sp_bsbs }
      end
      return
    end

    unless params[:s1].blank?
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_35 LIKE ?", "%#{params[:s1]}%")
    end

    unless params[:s2].blank?
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_43 LIKE ?", "%#{params[:s2]}%")
    end

    unless params[:s3].blank?
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_85 LIKE ?", "%#{params[:s3]}%")
    end

    unless params[:s4].blank?
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_14 LIKE ?", "%#{params[:s4]}%")
    end

    if  !params[:s5].blank? and params[:s5] != "请选择"
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_2 LIKE ?", "%#{params[:s5]}%")
    end

     if  !params[:s6].blank? and params[:s6] != "请选择"
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_18 LIKE ?", "%#{params[:s6]}%")
    end
   if !params[:sp_bsa].blank? and params[:sp_bsa] !="请选择"
     @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_70 LIKE ?", "%#{params[:sp_bsa]}%")
  end
  if !params[:sp_bsb].blank? and params[:sp_bsb] !="请选择"
     @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_67 LIKE ?", "%#{params[:sp_bsb]}%")
  end

    unless params[:s7].blank?
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_16 LIKE ?", "%#{params[:s7]}%")
    end

    # 被抽样单位名称
    unless params[:s11].blank?
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_1 LIKE ?", "%#{params[:s11]}%")
    end

    # 标识生产企业名称
    unless params[:s12].blank?
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_64 LIKE ?", "%#{params[:s12]}%")
    end

    # 任务来源
    unless params[:s13].blank?
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_2_1 LIKE ?", "%#{params[:s13]}%")
    end

    if params[:sp_dl] != '请选择' && !params[:sp_dl].blank?
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_17 LIKE ?", "%#{params[:sp_dl]}%")
    end

    if params[:sp_sf]!='全部' and !params[:sp_sf].blank?
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_4 LIKE ? ",  "%#{params[:sp_sf]}%")
    end
    if params[:flag]=="tabs_4" #只判断完全提交的数据
        if current_user.jg_bsb.jg_type ==1
        begin
       super_jg = JgBsbSuper.where(super_jg_bsb_id: current_user.jg_bsb.id ).group("jg_bsb_id")
        jg_names=[]
        jg_names.push(current_user.jg_bsb.jg_name)
        super_jg.each do |j|
           jg_names.push(j.jg_bsb.jg_name)
        end
       @sp_bsbs= @sp_bsbs.where("sp_bsbs.sp_s_43 in (?)",jg_names).paginate(page: params[:page], per_page: 10)
      rescue

      end
      elsif current_user.jg_bsb.jg_type ==3
      @sp_bsbs= @sp_bsbs.where("sp_bsbs.sp_s_43 = ?",current_user.jg_bsb.jg_name).paginate(page: params[:page], per_page: 10)
      end
    end
    if current_user.is_admin? || session[:change_js]==10 || is_sheng?
      case params[:s8].to_i
        when 1
          @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state between 0 and 16")
        when 2
          @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state = 10")
        when 3
          @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state IN (0, 1)")
        when 4
          @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state IN (2, 3)")
        when 5
          @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state IN (4)")
        when 6
          @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state IN (6, 7)")
        when 7
          @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state = 8")
        when 8
          @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state = 9")
        when 9, 10, 11, 12, 13
          @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state between 0 and 16")
        when 15
          @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state = 5")
        when 16
        @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state = 16")
        else
          @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state between 0 and 16")
      end
    elsif (session[:change_js]==2||session[:change_js]==3||session[:change_js]==4) && ['tabs_1', 'tabs_5'].include?(params[:flag])
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state = 6")
    elsif (session[:change_js]==2||session[:change_js]==3||session[:change_js]==4)&&params[:flag]=="tabs_2"
      @sp_bsbs = @sp_bsbs.where('sp_bsbs.sp_i_state IN (7, 8)')
    elsif (session[:change_js]==2||session[:change_js]==3||session[:change_js]==4)&&params[:flag]=="tabs_4"
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state = 9")
    elsif (session[:change_js]==1||session[:change_js]==5) && ['tabs_1', 'tabs_5'].include?(params[:flag])
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state IN (0, 1, 10)")
    elsif (session[:change_js]==1||session[:change_js]==5)&&params[:flag]=="tabs_2"
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state between 2 and 8")
    elsif (session[:change_js]==1||session[:change_js]==5)&&params[:flag]=="tabs_4"
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state = 9")
    elsif session[:change_js]==6 && ['tabs_1', 'tabs_5'].include?(params[:flag])
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state IN (2, 3)")
    elsif session[:change_js]==6&&params[:flag]=="tabs_2"
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state between 4 and 8")
    elsif session[:change_js]==6&&params[:flag]=="tabs_4"
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state = 9")
    elsif session[:change_js]==7 && ['tabs_1', 'tabs_5'].include?(params[:flag])
	 @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state = 4")
    elsif session[:change_js]==7&&params[:flag]=="tabs_2"
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state between 5 and 8")
    elsif session[:change_js]==7&&params[:flag]=="tabs_4"
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state = 9")
    elsif session[:change_js]==11 && ['tabs_1', 'tabs_5'].include?(params[:flag])
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state = 5")
    elsif session[:change_js]==11&&params[:flag]=="tabs_2"
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state =16")
    elsif session[:change_js]==11&&params[:flag]=="tabs_4"
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state = 9")
    elsif session[:change_js]==8 && ['tabs_1', 'tabs_5'].include?(params[:flag])
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state = 8")
    elsif session[:change_js]==8&&params[:flag]=="tabs_4"
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state = 9")
    elsif session[:change_js]==16&&['tabs_1', 'tabs_5'].include?(params[:flag])
	 @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state = 16")
     elsif session[:change_js]==16&&params[:flag]=="tabs_4"
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state = 9")
     elsif session[:change_js]==16&&params[:flag]=="tabs_2"
      @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state =9")
    end
    if params[:flag]=="tabs_5"
      @sp_bsbs =@sp_bsbs.where("sp_bsbs.sp_s_reason IS NOT NULL")
    end
    if params[:flag]=="tabs_6"
      @sp_bsbs =@sp_bsbs.where("sp_bsbs.czb_reverted_flag = 1")
    end

    if params[:s8]=='10'
      if current_user.is_admin?||session[:change_js]==10||is_sheng?
        @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_70 = '抽检监测(总局本级)'").paginate(page: params[:page], per_page: 10)

        respond_to do |format|
          format.html { render action: "index" }
          format.json { render json: @sp_bsbs }
        end
        return
      end
    end

    if params[:s8]=='11'
      if current_user.is_admin?||session[:change_js]==10||is_sheng?
        @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_70 = '抽检监测（地方）'").paginate(page: params[:page], per_page: 10)

        respond_to do |format|
          format.html { render action: "index" }
          format.json { render json: @sp_bsbs }
        end
        return
      end
    end

    if params[:s8]=='12'
      if current_user.is_admin?||session[:change_js]==10||is_sheng?
        @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_70 = '三司专项检验'").paginate(page: params[:page], per_page: 10)
        respond_to do |format|
          format.html { render action: "index" }
          format.json { render json: @sp_bsbs }
        end
        return
      end
    end

    if params[:s8]=='13'
      if current_user.is_admin?||session[:change_js]==10||is_sheng?
        @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_70 = '网络专项检验'").paginate(page: params[:page], per_page: 10)
        respond_to do |format|
          format.html { render action: "index" }
          format.json { render json: @sp_bsbs }
        end
        return
      end
    end

    if params[:s8]=='14'
      if current_user.is_admin? || session[:change_js] == 10||is_sheng?
        @sp_bsbs = @sp_bsbs.where("sp_bsbs.synced = false and sp_bsbs.sp_i_state = 2").paginate(page: params[:page], per_page: 10)

        respond_to do |format|
          format.html { render action: "index" }
          format.json { render json: @sp_bsbs }
        end
        return
      end
    end

    if params[:s8]=='9'
      if current_user.is_admin? || session[:change_js]==10||is_sheng?
        @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_71 like '%不合格样品%' or sp_bsbs.sp_s_71 like '%问题样品%'").paginate(page: params[:page], per_page: 10)
      else
        if session[:change_js]==2||session[:change_js]==3||session[:change_js]==4 #药监局数据审核
          @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_3 = ? or sp_bsbs.sp_s_202 = ?", current_user.user_s_province, current_user.user_s_province).where("sp_bsbs.sp_s_71 like '%不合格样品%' or sp_bsbs.sp_s_71 like '%问题样品%'").paginate(page: params[:page], per_page: 10)
        elsif session[:change_js]==7 #数据审核
          #@sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_43 in (?)", current_user.jg_bsb.all_names).where("sp_bsbs.sp_s_71 like '%不合格样品%' or sp_bsbs.sp_s_71 like '%问题样品%'").paginate(page: params[:page], per_page: 10)
     #if current_user.jg_bsb.jg_type ==1
     # logger.error "7 "
      #begin
      # super_jg = JgBsbSuper.where(super_jg_bsb_id: current_user.jg_bsb.id ).group("jg_bsb_id")
      #  jg_names=[]
      #  jg_names.push(current_user.jg_bsb.jg_name)
      #  super_jg.each do |j|
      #     jg_names.push(j.jg_bsb.jg_name)
      #  end
      #  logger.error "jg_names "
      # #@sp_bsbs= @sp_bsbs.where("sp_bsbs.sp_s_43 in (?)",jg_names).paginate(page: params[:page], per_page: 10)
      #rescue
      #  
      #end
      #elsif current_user.jg_bsb.jg_type ==3
     if params[:flag]!="tabs_4"
      @sp_bsbs= @sp_bsbs.where("sp_bsbs.sp_s_43 = ?",current_user.jg_bsb.jg_name).paginate(page: params[:page], per_page: 10)
     end
      #end 
       elsif session[:change_js]==6 #数据填报
         # @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_43 in (?)", current_user.jg_bsb.all_names).where("sp_bsbs.sp_s_71 like '%不合格样品%' or sp_bsbs.sp_s_71 like '%问题样品%'").paginate(page: params[:page], per_page: 10)
      #if current_user.jg_bsb.jg_type ==1
			#logger.error "6 "
      #begin
      # super_jg = JgBsbSuper.where(super_jg_bsb_id: current_user.jg_bsb.id ).group("jg_bsb_id")
      #  jg_names=[]
      #  jg_names.push(current_user.jg_bsb.jg_name)
      #  super_jg.each do |j|
      #     jg_names.push(j.jg_bsb.jg_name)
      #  end
      #  logger.error "jg_names "
      # @sp_bsbs= @sp_bsbs.where("sp_bsbs.sp_s_43 in (?)",jg_names).paginate(page: params[:page], per_page: 10)
      #rescue
      #  
      #end
      #elsif current_user.jg_bsb.jg_type ==3
      if params[:flag]!="tabs_4"
      @sp_bsbs= @sp_bsbs.where("sp_bsbs.sp_s_43 = ?",current_user.jg_bsb.jg_name).paginate(page: params[:page], per_page: 10)
      end
      #end  
      elsif session[:change_js]==1||session[:change_js]==5 #填报
         # @sp_bsbs = @sp_bsbs.where('sp_bsbs.user_id = ?', current_user.id).where("sp_bsbs.sp_s_71 like '%不合格样品%' or sp_bsbs.sp_s_71 like '%问题样品%'").paginate(page: params[:page], per_page: 10)
      #if current_user.jg_bsb.jg_type ==1
		  #  begin
      # super_jg = JgBsbSuper.where(super_jg_bsb_id: current_user.jg_bsb.id ).group("jg_bsb_id")
      #  jg_names=[]
      #  jg_names.push(current_user.jg_bsb.jg_name)
      #  super_jg.each do |j|
      #     jg_names.push(j.jg_bsb.jg_name)
      #  end
      #  logger.error "jg_names "
      # @sp_bsbs= @sp_bsbs.where("sp_bsbs.sp_s_43 in (?)",jg_names).paginate(page: params[:page], per_page: 10)
      #rescue
      #  
      #end
      #elsif current_user.jg_bsb.jg_type ==3
        if params[:flag]!="tabs_4"
          @sp_bsbs= @sp_bsbs.where("sp_bsbs.sp_s_43 = ?",current_user.jg_bsb.jg_name).paginate(page: params[:page], per_page: 10)
        end
      #end	
 
        elsif session[:change_js]==16 #数据填报
          if params[:flag]!="tabs_4"
         @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_43 in (?)", current_user.jg_bsb.all_names).where("sp_bsbs.sp_s_71 like '%不合格样品%' or sp_bsbs.sp_s_71 like '%问题样品%'").paginate(page: params[:page], per_page: 10)
          end
        elsif session[:change_js]==8 #牵头
          if session[:user_dl]=='乳制品'&& current_user.jg_bsb_id == JgBsb.find_by_history_name('上海市质量监督检验技术研究院').id
            @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_17 = ? or (sp_bsbs.sp_s_18='婴幼儿配方食品' and sp_bsbs.sp_s_70 LIKE '%一司%')", session[:user_dl]).where("sp_bsbs.sp_s_71 like '%不合格样品%' or sp_bsbs.sp_s_71 like '%问题样品%'").paginate(page: params[:page], per_page: 10)
          else
            @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_17 = ?", session[:user_dl]).where("sp_bsbs.sp_s_71 like '%不合格样品%' or sp_bsbs.sp_s_71 like '%问题样品%'").paginate(page: params[:page], per_page: 10)
          end
        elsif session[:change_js]==9
          @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state = 9 AND sp_bsbs.sp_s_70 LIKE '%一司%' AND sp_bsbs.sp_s_71 like '%不合格样品%' or sp_bsbs.sp_s_71 like '%问题样品%'").paginate(page: params[:page], per_page: 10)
        elsif session[:change_js]==10
          @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state = 9 AND sp_bsbs.sp_s_70 NOT LIKE '%一司%' AND sp_bsbs.sp_s_71 like '%不合格样品%' or sp_bsbs.sp_s_71 like '%问题样品%'").paginate(page: params[:page], per_page: 10)
        end
      end
    elsif current_user.is_admin?||session[:change_js]==10||is_sheng?
      @sp_bsbs = @sp_bsbs.paginate(page: params[:page], per_page: 10)
    else
      if session[:change_js]==2||session[:change_js]==3||session[:change_js]==4 #药监局数据审核
        @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_3=? or (sp_bsbs.sp_s_202=? and (sp_bsbs.sp_s_71 like '%不合格样品%' or sp_bsbs.sp_s_71 like '%问题样品%'))", current_user.user_s_province, current_user.user_s_province).paginate(page: params[:page], per_page: 10)
      elsif session[:change_js]==7 #数据审核
     #  if current_user.jg_bsb.jg_type ==1
     #   begin
     #  super_jg = JgBsbSuper.where(super_jg_bsb_id: current_user.jg_bsb.id ).group("jg_bsb_id")
     #   jg_names=[]
     #   jg_names.push(current_user.jg_bsb.jg_name)
     #   super_jg.each do |j|
     #      jg_names.push(j.jg_bsb.jg_name)
     #   end
     #   logger.error "jg_names "
     #  @sp_bsbs= @sp_bsbs.where("sp_bsbs.sp_s_43 in (?)",jg_names).paginate(page: params[:page], per_page: 10)
     # rescue
     #   
     # end
     # elsif current_user.jg_bsb.jg_type ==3
        if params[:flag]!="tabs_4"
      @sp_bsbs= @sp_bsbs.where("sp_bsbs.sp_s_43 = ?",current_user.jg_bsb.jg_name).paginate(page: params[:page], per_page: 10)
        end
     # end 
       # @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_43 in (?)", current_user.jg_bsb.all_names).paginate(page: params[:page], per_page: 10)
      elsif session[:change_js]==11 #数据批准
     #  if current_user.jg_bsb.jg_type ==1
     #   begin
     #  super_jg = JgBsbSuper.where(super_jg_bsb_id: current_user.jg_bsb.id ).group("jg_bsb_id")
     #   jg_names=[]
     #   jg_names.push(current_user.jg_bsb.jg_name)
     #   super_jg.each do |j|
     #      jg_names.push(j.jg_bsb.jg_name)
     #   end
     #   logger.error "jg_names "
     #  @sp_bsbs= @sp_bsbs.where("sp_bsbs.sp_s_43 in (?)",jg_names).paginate(page: params[:page], per_page: 10)
     # rescue
     #   
     # end
     # elsif current_user.jg_bsb.jg_type ==3
        if params[:flag]!="tabs_4"
      @sp_bsbs= @sp_bsbs.where("sp_bsbs.sp_s_43 = ?",current_user.jg_bsb.jg_name).paginate(page: params[:page], per_page: 10)
        end
     # end 
       # @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_43 in (?)", current_user.jg_bsb.all_names).paginate(page: params[:page], per_page: 10)
      elsif session[:change_js]==6 #数据填报
		#		if current_user.jg_bsb.jg_type ==1
    #    begin
    #   super_jg = JgBsbSuper.where(super_jg_bsb_id: current_user.jg_bsb.id ).group("jg_bsb_id")
    #    jg_names=[]
    #    jg_names.push(current_user.jg_bsb.jg_name)
    #    super_jg.each do |j|
    #       jg_names.push(j.jg_bsb.jg_name)
    #    end
    #    logger.error "jg_names "
    #   @sp_bsbs= @sp_bsbs.where("sp_bsbs.sp_s_43 in (?)",jg_names).paginate(page: params[:page], per_page: 10)
    #  rescue
    #    
    #  end
    #  elsif current_user.jg_bsb.jg_type ==3
        if params[:flag]!="tabs_4"
      @sp_bsbs= @sp_bsbs.where("sp_bsbs.sp_s_43 = ?",current_user.jg_bsb.jg_name).paginate(page: params[:page], per_page: 10)
        end
    #  end 	
        #@sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_43 in (?)", current_user.jg_bsb.all_names).paginate(page: params[:page], per_page: 10)
       elsif session[:change_js]==16 #数据填报
=begin        if current_user.jg_bsb.jg_type ==1
        begin
       super_jg = JgBsbSuper.where(super_jg_bsb_id: current_user.jg_bsb.id ).group("jg_bsb_id")
        jg_names=[]
        jg_names.push(current_user.jg_bsb.jg_name)
        super_jg.each do |j|
           jg_names.push(j.jg_bsb.jg_name)
        end
        logger.error "jg_names "
       @sp_bsbs= @sp_bsbs.where("sp_bsbs.sp_s_43 in (?)",jg_names).paginate(page: params[:page], per_page: 10)
      rescue
        
      end
      elsif current_user.jg_bsb.jg_type ==3
      @sp_bsbs= @sp_bsbs.where("sp_bsbs.sp_s_43 = ?",current_user.jg_bsb.jg_name).paginate(page: params[:page], per_page: 10)
      end
=end
         if params[:flag]!="tabs_4"
         @sp_bsbs= @sp_bsbs.where("sp_bsbs.sp_s_43 = ?",current_user.jg_bsb.jg_name).paginate(page: params[:page], per_page: 10)
         end
       # @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_43 in (?)", current_user.jg_bsb.all_names).paginate(page: params[:page], per_page: 10)
      elsif session[:change_js]==1||session[:change_js]==5 #填报
        if params[:flag]!="tabs_4"
        @sp_bsbs = @sp_bsbs.where('sp_bsbs.user_id = ?', current_user.id).paginate(page: params[:page], per_page: 10)
        end
      elsif session[:change_js]==8 #牵头
        if session[:user_dl]=='乳制品'&&current_user.jg_bsb_id == JgBsb.find_by_history_name('上海市质量监督检验技术研究院').id
          @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_17=? or (sp_bsbs.sp_s_18='婴幼儿配方食品' and sp_bsbs.sp_s_70 LIKE '%一司%')", session[:user_dl]).paginate(page: params[:page], per_page: 10)
        else
          @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_s_17=?", session[:user_dl]).paginate(page: params[:page], per_page: 10)
        end
      elsif session[:change_js]==9
        @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state = 9 and sp_bsbs.sp_s_70 LIKE '%一司%'").paginate(page: params[:page], per_page: 10)
      elsif session[:change_js]==10
        @sp_bsbs = @sp_bsbs.where("sp_bsbs.sp_i_state = 9 and sp_bsbs.sp_s_70 NOT LIKE '%一司%'").paginate(page: params[:page], per_page: 10)
      end
    end
   
    @rwly = all_super_departments
    if is_city? and (!current_user.is_super? or !current_user.is_admin?)
      @sp_bsbs = @sp_bsbs.where(sp_s_2_1: @rwly).paginate(page: params[:page], per_page: 10)
    elsif is_county_level? and (!current_user.is_super? or !current_user.is_admin?)
      @sp_bsbs = @sp_bsbs.where(sp_s_2_1: @rwly).paginate(page: params[:page], per_page: 10)
    end
    
    respond_to do |format|
      format.html {
        if @sp_bsbs.respond_to?(:total_pages)
          render action: "index"
        else
          render text: '账号存在异常，请联系系统维护方。'
        end
      }
      format.json { render json: @sp_bsbs }
    end
  end

  # get /sp_bsbs/submit
  def submit
    #if current_user.is_admin?
    @sp_bsb = SpBsb.find(params[:id])
    @sp_bsb.update_attribute(:sp_i_state, 1)
    #end
    respond_to do |format|
      format.html { redirect_to "/sp_bsbs_spsearch?#{session[:query]}" }
    end
  end

  #excel 导入
  def import_excel
    uploaded_io = params[:excel]
    accepted_formats = [".xls", ".xlsx"]
    if !uploaded_io.nil? and accepted_formats.include? File.extname(uploaded_io.original_filename) then
      file_name = Rails.root.join('excel', current_user.name + (Time.now.to_i.to_s)+uploaded_io.original_filename)
      File.open(file_name, 'wb+') do |file|
        file.write(uploaded_io.read)

        book = Spreadsheet.open(file_name)
        sheet1 = book.worksheet 0
        i_num=0
        temp_str=''
        ActiveRecord::Base.transaction do
          sheet1.each_with_index do |row, index|
            if i_num<=0
              i_num=i_num+1
            elsif (row[9]!=nil&&("安徽','澳门','北京','福建','甘肃','广东','广西','贵州','海南','河北','河南','黑龙江','湖北','湖南','吉林','江苏','江西','辽宁','内蒙古','宁夏','青海','山东','山西','陕西','上海','四川','台湾','天津','西藏','香港','新疆','云南','浙江','重庆','兵团".include? row[9]))||(current_user.is_admin?&&row[9]!=nil)
              result_record=SpBsb.find(:first, :conditions => ["sp_s_16=?", row[25]])

              if result_record==nil&&row[62]!=nil&&row[21]!=nil&&row[9]!=nil&&row[29]!=nil&&row[25]!=nil&&row[5]!=nil&&row[26]!=nil&&row[3]!=nil&&row[50]!=nil&&row[0]!=nil&&row[1]!=nil&&row[2]!=nil&&"抽检监测（总局本级三司）','抽检监测（总局本级一司）','抽检监测（三司专项）','抽检监测（省级）','抽检监测（地方）".include?(row[1])&&BaosongB.exists?(name: row[2])
                bsb = SpBsb.new
                bsb.sp_s_2_1=row[0]
                bsb.sp_s_70=row[1]
                bsb.sp_s_67=row[2]
                bsb.sp_s_1=row[3]
                bsb.sp_s_68=row[4]
                bsb.sp_s_2=row[5]
                bsb.sp_s_23=row[6]
                bsb.sp_s_215=row[7]
                bsb.sp_s_bsfl=row[8]
                bsb.sp_s_3=row[9]
                bsb.sp_s_4=row[10]
                bsb.sp_s_5=row[11]
                bsb.sp_s_201=row[12]
                bsb.sp_s_7=row[13]
                bsb.sp_s_10=row[14]
                bsb.sp_s_8=row[15]
                bsb.sp_s_9=row[16]
                bsb.sp_s_11=row[17]
                bsb.sp_s_12=row[18]

                bsb.sp_xkz=row[19]
                bsb.sp_xkz_id=row[20]

                bsb.sp_s_14=row[21]
                bsb.sp_s_203=row[22]
                bsb.sp_n_15=row[23]
                bsb.sp_s_6=row[24]
                bsb.sp_s_16=row[25]
                bsb.sp_s_17=row[26]
                bsb.sp_s_18=row[27]
                bsb.sp_s_19=row[28]
                bsb.sp_s_20=row[29]
                bsb.sp_s_61=row[30]
                bsb.sp_s_62=row[31]
                bsb.sp_s_63=row[32]
                bsb.sp_s_21=row[33]
                bsb.sp_d_22=row[34]
                bsb.sp_s_24=row[35]
                bsb.sp_s_25=row[36]
                bsb.sp_s_26=row[37]
                bsb.sp_s_27=row[38]
                bsb.sp_d_28=row[39]
                bsb.sp_n_29=row[40]
                #    bsb.sp_s_66=row[39]
                bsb.sp_s_13=row[41]
                bsb.sp_s_72=row[42]
                bsb.sp_s_73=row[43]
                bsb.sp_s_74=row[44]
                bsb.sp_s_204=row[45]
                bsb.sp_s_205=row[46]
                bsb.sp_s_206=row[47]
                bsb.sp_s_207=row[48]
                bsb.sp_s_208=row[49]
                bsb.sp_s_64=row[50]
                bsb.sp_s_65=row[51]
                bsb.sp_s_202=row[52]
                bsb.sp_s_75=row[53]
                bsb.sp_s_76=row[54]
                bsb.sp_s_30=row[55]
                bsb.sp_n_31=row[56]
                bsb.sp_s_33=row[57]
                bsb.sp_n_32=row[58]
                bsb.sp_s_209=row[59]
                bsb.sp_s_210=row[60]
                bsb.sp_s_34=row[61]
                bsb.sp_s_35=row[62]
                bsb.sp_s_36=row[63]
                bsb.sp_s_37=row[64]
                bsb.sp_d_38=row[65]
                bsb.sp_s_39=row[66]
                bsb.sp_s_40=row[67]
                bsb.sp_s_41=row[68]
                bsb.sp_s_42=row[69]
                bsb.sp_s_211=row[70]
                bsb.sp_s_212=row[71]
                bsb.sp_s_213=row[72]
                bsb.sp_s_43=''
                bsb.sp_s_85= current_user.name
                bsb.sp_s_52=current_user.user_s_province
                bsb.sp_s_56=""
                # bsb.tname = current_user.name
                bsb.user_id = current_user.id
                bsb.uid = current_user.uid
                bsb.sp_i_state=10
                bsb.sp_n_jcxcount=1
                bsb.sp_d_86=(Time.now).year.to_s+'-'+(Time.now).mon.to_s+'-'+(Time.now).day.to_s
                bsb.save
                i_num=i_num+1
              else
                temp_str=temp_str+"#{index},"
              end
            end
          end
        end
        if temp_str!=''
          if temp_str.length>2000
            temp_str=temp_str[0, 2000]
            flash[:import_result] = "文件上传成功,新导入#{i_num-1}条记录!其中"+temp_str+"...不符合导入要求!"
          else
            flash[:import_result] = "文件上传成功,新导入#{i_num-1}条记录!其中"+temp_str+"不符合导入要求!"
          end
        else
          flash[:import_result] = "文件上传成功,新导入#{i_num-1}条记录!"
        end
      end
    else
      flash[:import_result] = "文件上传失败！"
    end

    params[:flag]="tabs_3"

    respond_to do |format|
      format.html { redirect_to "/sp_bsbs_spsearch?flag=tabs_3" }
    end
  end

  #excel 导入修改检测数据
  def import_data_excel
    uploaded_io = params[:excel]

    accepted_formats = [".xls", ".xlsx"]
    if !uploaded_io.nil? and accepted_formats.include? File.extname(uploaded_io.original_filename) then
      File.open(Rails.root.join('excel', current_user.name+(Time.now).to_s+uploaded_io.original_filename), 'wb') do |file|
        file.write(uploaded_io.read)
        book = Spreadsheet.open(Rails.root.join('excel', current_user.name + (Time.now).to_s+uploaded_io.original_filename))
        sheet1 = book.worksheet 0
        i_num=0
        temp_str=''
        sheet1.each do |row|
          if i_num<=0
            i_num=i_num+1
          else
            if (current_user.is_admin?)
              @result_record=SpBsb.find_by_sql(["select sp_bsbs.id as id1,spdata.id as id2 from sp_bsbs,spdata where sp_s_16=? and sp_bsbs.id=spdata.sp_bsb_id and spdata_0=?", row[0], row[1]])
              if @result_record!=nil
                ActiveRecord::Base.transaction do
                  @sp_bsb = SpBsb.find(@result_record[0].id1)
                  @sp_bsb.sp_s_71=row[3]
                  @sp_bsb.save
                  @spdata = Spdatum.find(@result_record[0].id2)
                  @spdata.spdata_8=row[2]
                  @spdata.save
                end
              end
            end
            i_num=i_num+1
          end
        end
        if temp_str!=''
          if temp_str.length>2000
            temp_str=temp_str[0, 2000]
            flash[:import_result] = "文件上传成功,新导入#{i_num-1}条记录!其中"+temp_str+"...不符合导入要求!"
          else
            flash[:import_result] = "文件上传成功,新导入#{i_num-1}条记录!其中"+temp_str+"不符合导入要求!"
          end
        else
          flash[:import_result] = "文件上传成功,新导入#{i_num-1}条记录!"
        end
      end
    else
      flash[:import_result] = "文件上传失败！"
    end

    respond_to do |format|
      format.html { redirect_to "/sp_bsbs_spsearch?#{session[:query]}" }
    end
  end

  #excel 临时导入修改检测数据
  def import_temp_data_excel
    uploaded_io = params[:excel]
    accepted_formats = [".xls", ".xlsx"]
    SpBsb.record_timestamps = false
    if !uploaded_io.nil? and accepted_formats.include? File.extname(uploaded_io.original_filename) then
      File.open(Rails.root.join('excel', (current_user.name +(Time.now).to_s+uploaded_io.original_filename), 'wb')) do |file|
        file.write(uploaded_io.read)
        book = Spreadsheet.open(Rails.root.join('excel', current_user.name + (Time.now).to_s+uploaded_io.original_filename))
        sheet1 = book.worksheet 0
        i_num=0
        temp_str=''
        sheet1.each do |row|
          if i_num<=0
            i_num=i_num+1
          else
            if (current_user.is_admin?)
              result_record=SpBsb.find(:first, :conditions => ["sp_s_16=?", row[1]])
              if result_record!=nil
                ActiveRecord::Base.transaction do
                  bsb = SpBsb.find(:first, :conditions => ["sp_s_16=?", row[1]])
                  bsb.sp_s_202=row[0]
                  bsb.save
                end
              end
            end
            i_num=i_num+1
          end
        end
        if temp_str!=''
          if temp_str.length>2000
            temp_str=temp_str[0, 2000]
            flash[:import_result] = "文件上传成功,新导入#{i_num-1}条记录!其中"+temp_str+"...不符合导入要求!"
          else
            flash[:import_result] = "文件上传成功,新导入#{i_num-1}条记录!其中"+temp_str+"不符合导入要求!"
          end
        else
          flash[:import_result] = "文件上传成功,新导入#{i_num-1}条记录!"
        end
      end
    else
      flash[:import_result] = "文件上传失败！"
    end

    SpBsb.record_timestamps = true

    respond_to do |format|
      format.html { redirect_to "/sp_bsbs_spsearch?#{session[:query]}" }
    end
  end

  # 删除检验报告
  def remove_fail_report
    @sp_bsb = SpBsb.find(params[:id])
    @sp_bsb.fail_report_path = nil
    @sp_bsb.save

    redirect_to :back
  end

  # 抽样单电子版
  def cyd
    @sp_bsb = SpBsb.find(params[:id])
    if @sp_bsb.cyd_file_path.blank?
      render text: "该样品的【抽样单电子版】不存在"
    else
      send_file("#{@sp_bsb.cyd_file}", :filename => "#{@sp_bsb.sp_s_16}抽样单电子版#{File.extname(@sp_bsb.cyd_file)}", :disposition => 'inline')
    end
  end

  # 抽样检验告知书
  def cyjygzs
    @sp_bsb = SpBsb.find(params[:id])
    if @sp_bsb.cyjygzs_file_path.blank?
      render text: "该样品的【抽样检验告知书电子版】不存在"
    else
      send_file("#{@sp_bsb.cyjygzs_file}", :filename => "#{@sp_bsb.sp_s_16}抽样检验告知书#{File.extname(@sp_bsb.cyjygzs_file)}", :disposition => 'inline')
    end
  end

  def fail_pdf_report
    @sp_bsb = SpBsb.find(params[:id])
    if request.post?
      file = params[:file]
      unless params[:file].blank?
        # 10M
        if File.size(file.path) > 5242880
          flash[:fail_report_result] = "上传失败！请上传不大于5M的报告文件"
          redirect_to(:back, :fail_report_result => '请选择文件')
          return
        end

        md5 = Digest::MD5.file(file.path).hexdigest.upcase
        path = Time.now.strftime("%Y/%m/%d")

        FileUtils.mkdir_p "#{Rails.application.config.fail_report_path}/#{path}" unless Dir.exists?("#{Rails.application.config.fail_report_path}/#{path}")
        ext = File.extname(params[:file].original_filename)
        FileUtils.mv(params[:file].path, "#{Rails.application.config.fail_report_path}/#{path}/#{md5}#{ext}")

        old_path = @sp_bsb.fail_report_path
        SpBsb.record_timestamps = false
        if @sp_bsb.update_attributes(:fail_report_path => "#{path}/#{md5}#{ext}", :fail_report_at => Time.now)
          #FileUtils.rm("#{Rails.application.config.fail_report_path}/#{old_path}")
        end
        SpBsb.record_timestamps = true
        flash[:fail_report_result] = "上传报告成功！"
        redirect_to(:back, :fail_report_result => '上传成功')
      else
        flash[:fail_report_result] = "请选择报告文件"
        redirect_to(:back, :fail_report_result => '请选择文件')
      end
    else
      send_file("#{Rails.application.config.fail_report_path}/#{@sp_bsb.fail_report_path}", :filename => "#{@sp_bsb.sp_s_16}#{File.extname(@sp_bsb.fail_report_path)}", :disposition => 'attachment')
    end
  end

  # 导入报送分类
  def import_sp_standards_v2
    unless params[:file].nil?
      book = Spreadsheet.open(params[:file].path)

      sheet = book.worksheet(0)

      @lines = []
      sheet.each_with_index 2 do |row, index|
        # 大类
        @A_category = row[0].to_s.strip unless row[0].nil?
        # 亚类
        @B_category = row[1].to_s.strip unless row[1].nil?
        # 次亚类
        @C_category = row[2].to_s.strip unless row[2].nil?
        # 细类
        @D_category = row[3].to_s.strip unless row[3].nil?

        # 检验项目
        @JYXM = row[6].to_s.strip unless row[6].nil?

        # 结果单位
        @JGDW = row[8].to_s.strip unless row[8].nil?

        # 检验依据
        @JYYJ = row[11].to_s.strip unless row[11].nil?

        # 判定依据
        @PDYJ = row[12].to_s.strip unless row[12].nil?

        # 标准方法检出限
        @BZFFJCX = row[13].to_s.strip unless row[13].nil?

        # 标准方法检出限单位
        @BZFFJCXDW = row[14].to_s.strip unless row[14].nil?

        # 标准最小允许限
        @BZZXYXX = row[15].to_s.strip unless row[15].nil?

        # 标准最小允许限单位 
        @BZZXYXXDW = row[16].to_s.strip unless row[16].nil?

        # 标准最大允许限 
        @BZZDYXX = row[17].to_s.strip unless row[17].nil?

        # 标准最大允许限单位 
        @BZZDYXXDW = row[18].to_s.strip unless row[18].nil?

        @lines.push({A_category: @A_category, B_category: @B_category, C_category: @C_category, D_category: @D_category, JYXM: @JYXM, JGDW: @JGDW, JYYJ: @JYYJ, PDYJ: @PDYJ, BZFFJCX: @BZFFJCX, BZFFJCXDW: @BZFFJCXDW, BZZXYXX: @BZZXYXX, BZZXYXXDW: @BZZXYXXDW, BZZDYXX: @BZZDYXX, BZZDYXXDW: @BZZDYXXDW})
      end

      @identifier = "TTTT"
      ActiveRecord::Base.transaction do
        @lines.each do |line|
          a_category = ACategory.where(name: line[:A_category], identifier: @identifier).first_or_create
          b_category = BCategory.where(name: line[:B_category], identifier: @identifier, a_category_id: a_category.id).first_or_create
          c_category = CCategory.where(name: line[:C_category], identifier: @identifier, a_category_id: a_category.id, b_category_id: b_category.id).first_or_create
          d_category = DCategory.where(name: line[:D_category], identifier: @identifier, a_category_id: a_category.id, b_category_id: b_category.id, c_category_id: c_category.id).first_or_create

          item = CheckItem.where(a_category_id: a_category.id, b_category_id: b_category.id, c_category_id: c_category.id, d_category_id: d_category.id, name: line[:JYXM]).first_or_create

          item.JGDW = (item.JGDW || "").split("#").push(line[:JGDW]).uniq.join("#")
          item.JYYJ = (item.JYYJ || "").split("#").push(line[:JYYJ]).uniq.join("#")
          item.PDYJ = (item.PDYJ || "").split("#").push(line[:PDYJ]).uniq.join("#")
          item.BZFFJCX = (item.BZFFJCX || "").split("#").push(line[:BZFFJCX]).uniq.join("#")
          logger.error item.BZFFJCX

          item.BZFFJCXDW = (item.BZFFJCXDW || "").split("#").push(line[:BZFFJCXDW]).uniq.join("#")
          item.BZZXYXX = (item.BZZXYXX || "").split("#").push(line[:BZZXYXX]).uniq.join("#")
          item.BZZXYXXDW = (item.BZZXYXXDW || "").split("#").push(line[:BZZXYXXDW]).uniq.join("#")
          item.BZZDYXX = (item.BZZDYXX || "").split("#").push(line[:BZZDYXX]).uniq.join("#")
          item.BZZDYXXDW = (item.BZZDYXXDW || "").split("#").push(line[:BZZDYXXDW]).uniq.join("#")

          item.save
        end
      end
    end
  end

  def  super_jg
    #begin
      super_jg_bsb_id = params[:super_jg_bsb_id]
      @jg_bsbsuper=JgBsbSuper.where(super_jg_bsb_id: super_jg_bsb_id ).group("jg_bsb_id")
      jg_ids=[]
    if !@jg_bsbsuper.blank?
      jg_ids.push(super_jg_bsb_id)
      @jg_bsbsuper.each do |j|
         jg_ids.push(j.jg_bsb_id)
      end
       @jg=JgBsb.where("jg_bsbs.jg_detection=? and jg_bsbs.id in(?)",1,jg_ids)
      else
       @jg= JgBsb.where("jg_bsbs.jg_detection=? and jg_bsbs.id in(?)",1,super_jg_bsb_id)
    end
        render json: {status: 'OK', msg: @jg }
   # rescue
     #@jg= JgBsb.where("jg_bsbs.jg_detection=? and jg_bsbs.id in(?)",1,18) 
    # render json: {status: 'OK', msg: @jg }
   # end
    end
 
  private
  def sp_bsb_params
    params.require(:sp_bsb).permit(
        :ca_key_status,:report_path, :sp_s_1, :sp_s_2, :sp_s_3, :sp_s_4, :sp_s_5, :sp_s_6, :sp_s_7, :sp_s_8, :sp_s_9, :sp_s_10, :sp_s_11, :sp_s_12, :sp_s_13, :sp_s_14, :sp_n_15, :sp_s_16, :sp_s_17, :sp_s_18, :sp_s_19, :sp_s_20, :sp_s_21, :sp_d_22, :sp_s_23, :sp_s_24, :sp_s_25, :sp_s_26, :sp_s_27, :sp_d_28, :sp_n_29, :sp_s_30, :sp_n_31, :sp_n_32, :sp_s_33, :sp_s_34, :sp_s_35, :sp_s_36, :sp_s_37, :sp_d_38, :sp_s_39, :sp_s_40, :sp_s_41, :sp_s_42, :sp_s_43, :sp_s_44, :sp_s_45, :sp_d_46, :sp_d_47, :sp_s_48, :sp_s_49, :sp_s_50, :sp_s_51, :sp_s_52, :sp_s_53, :sp_s_54, :sp_s_55, :sp_s_56, :sp_s_57, :sp_s_58, :sp_s_59, :sp_s_60, :sp_s_61, :sp_s_62, :sp_s_63, :sp_s_64, :sp_s_65, :sp_s_66, :sp_s_67, :sp_s_68, :sp_s_69, :sp_s_70, :sp_s_71, :sp_s_72, :sp_s_73, :sp_s_74, :sp_s_75, :sp_s_76, :sp_s_77, :sp_s_78, :sp_s_79, :sp_s_80, :sp_s_81, :sp_s_82, :sp_s_83, :sp_s_84, :sp_s_85, :sp_d_86, :sp_s_87, :sp_s_88, :user_id, :uid,
        :sp_n_jcxcount,
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
        :sp_s_220,
        :sp_s_221,
        :sp_s_222,
        :fail_report_path,
        :fail_report_at,
        :bgfl,
        :sp_xkz,
        :sp_xkz_id,
        :updated_at,
        :czb_reverted_flag,
        :czb_reverted_reason,
				:synced, :ca_source, :ca_sign,
				:inspection_basis, :decision_basis
    )
  end
end

