#encoding: utf-8
class Api::V1::SpBsbsController < ApplicationController
  require 'RMagick'
  include ApplicationHelper

  skip_before_filter :session_expiry, :verify_authenticity_token
  before_filter :authorize, :except => [:picture, :transfer]
  skip_before_action :authenticate_user!

  before_filter :doorkeeper_authorize!, :only => [:transfer]

  def index
  end

  module ErrorCode
    None = 0
    DataSaveError = 40001
    ParamsParseError = 40002
    FatalError = 40003
    ParamsMissingError = 40004
  end

  # 接口提交数据
  # /api/v1/sp_bsbs/transfer
  def transfer
    respond_to do |format|
      ActiveRecord::Base.transaction do
        begin
          if params[:data].blank?
            format.json { render :json => {:errorcode => ErrorCode::ParamsParseError, :errormsg => '请提供data参数'} }
            return
          end
          if params[:data].class.to_s.eql?("String")
            @data = JSON.parse(params[:data], :symbolize_names => true)
          else
            @data = params[:data]
          end
          @spdata = @data.delete(:spdata)

          # spdata不可为空
          if @spdata.blank?
            format.json { render :json => {:errorcode => ErrorCode::ParamsMissingError, :errormsg => '请提供spdata参数'} }
            return
          end

          @sp_bsb = SpBsb.new(@data)

          # 增加字段必须性验证
          sp_bsb_fields[:bsb].each do |field, required|
            if required
              @sp_bsb.singleton_class.validates_presence_of field, :message => '请提供'
            end
          end

          @sp_bsb.via_api = true
          @sp_bsb.sp_i_state = 22
          @sp_bsb.sp_t_procedure = "[" + Time.now.to_s << "] 由[" << doorkeeper_token.application.name << "]接口提交"

          if @sp_bsb.save
            unless @spdata.blank?
              @spdata.each do |sd|
                d = Spdatum.new(sd)
                d.sp_bsb_id = @sp_bsb.id
                d.save
              end
            end
            format.json { render :json => {:errorcode => ErrorCode::None, :errormsg => ''} }
          else
            format.json { render :json => {:errorcode => ErrorCode::DataSaveError, :msg => @sp_bsb.errors} }
          end
        rescue Exception => e
          format.json { render :json => {:errorcode => ErrorCode::FatalError, :msg => '未知错误', :exception => e.class.to_s} }
        end
      end
    end
  end

  GPS_API_URL = "http://210.72.225.133/YJWebService/Handler.ashx?Method=SpotCheck&SystemNo=%s&CheckNumber=%s&OperationFlag=%d&OperationTime=%s"

  def do_step
    @sp_bsb = PadSpBsb.find(params[:id])
    permited_steps = [12, 13, 14, 15, 16]
    @sp_bsb.sp_i_state = params[:step].to_i

    if @sp_bsb.sp_i_state == 13 and !@user.car_sys_id.blank?
      # 接受任务
      result = RestClient.get(GPS_API_URL % [URI.escape(@user.car_sys_id), @sp_bsb.sp_s_16, 0, URI.escape(Time.now.strftime("%Y-%m-%d %H:%M:%S"))])
    end

    @sp_bsb.failed_message = params[:failed_message] if @sp_bsb.sp_i_state == 16
    respond_to do |format|
      if !params[:step].blank? and permited_steps.include?(params[:step].to_i) and @sp_bsb.save
        format.json { render :json => {:status => 'OK', :msg => '成功修改状态！'} }
      else
        format.json { render :json => {:status => 'ERR', :msg => '修改状态失败！'} }
      end
    end
  end

  def submit
    @sp_bsb = PadSpBsb.find(params[:id])
    if params[:isPrint].blank?
      params[:sp_bsb][:sp_i_state] = 15
    end

    respond_to do |format|
      if @sp_bsb.update_attributes(params[:sp_bsb].as_json)
        if @sp_bsb.sp_i_state == 15 and !@user.car_sys_id.blank?
          # 采样完成
          result = RestClient.get(GPS_API_URL % [URI.escape(@user.car_sys_id), @sp_bsb.sp_s_16, 1, URI.escape(Time.now.strftime("%Y-%m-%d %H:%M:%S"))])

          logger.error "CLOSE"
          logger.error result
        end
        format.json { render :json => {:status => "OK", :msg => "保存成功!", :id => @sp_bsb.id} }
      else
        format.json { render :json => {:status => "ERR", :msg => "保存不成功，#{@sp_bsb.errors.first.last}!"} }
      end
    end
  end

  def check_sp_production_info
    @scbh = params[:scbh]
    respond_to do |format|
      unless @scbh.blank?
        @info = SpProductionInfo.find_by_scbh(@scbh)
        unless @info.nil?
          format.json { render json: {status: 'OK', msg: @info} }
        else
          format.json { render json: {status: 'ERR', msg: '查无结果'} }
        end
      else
        format.json { render json: {status: 'ERR', msg: '参数无效'} }
      end
    end
  end

  def tasks
    @tasks = PadSpBsb.where(:sp_i_state => [12, 13, 14, 15, 16], sp_s_37_user_id: @user.id)
    respond_to do |format|
      format.json { render :json => {:status => 'OK', :msg => @tasks.as_json(:include => [:sp_bsb_pictures])} }
    end
  end

	def ca_sign
		@sp_bsb = PadSpBsb.find(params[:id])
		sign = PadCaSign.new(sp_s_16: @sp_bsb.sp_s_16, pad_sp_bsb_id: @sp_bsb.id, user_cert: params[:userCert], orig_data: params[:origData], signed_data: params[:signedData], user_id: @user.id)
		if sign.save
			render json: { status: 'OK', msg: 'OK', ca_sign_id: sign.id}
		else
			render json: { status: 'ERR', msg: sign.errors.first.last }
		end
	end

	# 生产企业信息
	def scqy_infos
		@qys = SpProductionInfo.order('id desc').limit(20)

		if params[:qymc].present?
			@qys = @qys.where('qymc like ?', "%#{params[:qymc]}%")
		end

		render json: { status: 'OK', msg: @qys.select('scbh, qymc, scdz') }
	end

	# 被抽样单位信息
	def bcydw_infos
		@bcydws = SpCompanyInfo.order('id desc').limit(20)

		if params[:sp_s_1].present?
			@bcydws = @bcydws.where('sp_s_1 like ?', "%#{params[:sp_s_1]}%")
		end

		render json: { status: 'OK', msg: @bcydws.select('sp_s_1, sp_s_201, sp_s_8, sp_s_23, sp_s_215, sp_s_bsfl, sp_s_3, sp_s_4, sp_s_5, sp_s_7, sp_s_12, sp_s_10') }
	end

  def upload_picture
    @sp_bsb_picture = SpBsbPicture.where(:sp_bsb_id => params[:id], :sort_index => params[:sort_index]).first
    @sp_bsb_picture ||= SpBsbPicture.new(:sp_bsb_id => params[:id], :sort_index => params[:sort_index])
    @sp_bsb_picture.tmp_file = params[:file]

    respond_to do |format|
      if @sp_bsb_picture.save
        format.json { render :json => {:status => 'OK', :msg => '上传照片成功', :picture => @sp_bsb_picture} }
      else
        format.json { render :json => {:status => 'ERR', :msg => '上传照片失败'} }
      end
    end
  end

  def picture
    @picture = SpBsbPicture.where(:sp_bsb_id => params[:id], :sort_index => params[:sort_index]).last
    if !@picture.blank?
      if !params[:original].blank?
        send_file @picture.absolute_path, :disposition => 'inline', :filename => "#{@picture.md5}.jpg"
      else
        img_orig = Magick::Image.read(@picture.absolute_path).first
        img = img_orig.scale(300, 400)
        send_data(img.to_blob, :filename => "#{@picture.md5}.jpg", :disposition => 'inline')
      end
    end
  end

  # 同步客户端数据
  def sync
    @result = {:status => 'OK', :msg => nil}
    respond_to do |format|
      ActiveRecord::Base.transaction do
        @sp_bsbs = params[:sp_bsbs].values if !params[:sp_bsbs].blank?
        @pictures = params[:pictures].values if !params[:pictures].blank?

        # 处理抽样信息
        if !@sp_bsbs.blank?
          @sp_bsbs.each do |sp_bsb|
            if !PadSpBsb.find(sp_bsb.delete(:id)).update_attributes(sp_bsb.as_json)
              @result[:status] = 'ERR'
              @result[:msg] = '同步失败，请稍后重试'
              raise ActiveRecord::Rollback
            end
          end
        end

        # 处理图片信息
        if !@pictures.blank?
          @pictures.each do |p|
            picture = SpBsbPicture.where(:sp_bsb_id => p[:report_id], :sort_index => p[:sort_index]).first || SpBsbPicture.new(:sp_bsb_id => p[:report_id], :sort_index => p[:sort_index])
            picture.tmp_file = p[:file]
            picture.updated_at = Time.now
            if !picture.save
              @result[:status] = 'ERR'
              @result[:msg] = '同步失败，请稍后重试'
              raise ActiveRecord::Rollback
            end
          end

        end
      end

      format.json { render :json => @result }
    end
  end

  def get_provinces
    @provinces = SysProvince.select("name, level")

    if @user.jg_bsb.attachment_path_file.blank?
      render json: {status: 'ERR', msg: '机构未设置签章，无法下发配置信息'}
    else
			if File.exists?(@user.jg_bsb.attachment_path_file)
				stamp = Base64.encode64(open(@user.jg_bsb.attachment_path_file).to_a.join)
			else
				stamp = nil
			end

      super_jgs = JgBsb.where(id: JgBsbSuper.where(jg_bsb_id: @user.jg_bsb.id).pluck(:super_jg_bsb_id)).map{|jg| jg.jg_name}
      render json: {status: 'OK', msg: @provinces, jg_stamp: stamp, prov: @user.user_s_province, super_jgs: super_jgs.join('&&')}

      #render json: {status: 'OK', msg: @provinces, jg_stamp: stamp}
    end
  end

  def is_valid
    bsb = PadSpBsb.find_by_sp_s_16(params[:sp_s_16])
    if bsb.nil?
      render json: {status: 'ERR', msg: '服务器不存在该任务: ' + params[:sp_s_16]}
    else
      bsb.sp_s_215 = params[:sp_s_215]
      bsb.sp_s_68 = params[:sp_s_68]
      bsb.sp_s_13 = params[:sp_s_13]
      bsb.sp_s_14 = params[:sp_s_14]
      bsb.sp_s_64 = params[:sp_s_64]
      bsb.sp_d_28 = params[:sp_d_28]
			bsb.force_check = true
      if bsb.check_bsb_validity
        if bsb.sp_bsb_checked_count_info.blank?
          render json: {status: 'OK', msg: '营业执照号或生产许可证号或生产企业名称或样品名称或生产日期信息不完整, 无法判断有效性.' }
        else
          render json: {status: 'OK', msg: bsb.sp_bsb_checked_count_info }
        end
      else
        render json: {status: 'ERR', msg: bsb.sp_bsb_checked_count_info }
      end
    end
  end

  private
  def authorize
    if params[:userCert].present?
			@ca_helper = Bjca::CaHelper.new
      response_code = @ca_helper.validate_cert(params[:userCert])

      if response_code == 1
        sfid = @ca_helper.get_cert_info_by_oid(params[:userCert])
        @user = User.find_by_id_card(sfid)

        if @user.nil?
          format.json { render :json => {status: 'ERR', msg: '该用户未在系统中登记，请在电脑上登录系统绑定您的KEY', key: sfid, code: 444} }
          return
        end

      else
        format.json { render :json => {status: 'ERR', msg: ValidateCertCode::ResponseCode["code:#{response_code}"]} }
        return
      end
    else
      if !(params[:username].blank? or params[:password].blank?)
        @user = User.where(uid: params[:username]).last
        if @user.blank? or !@user.valid_password?(params[:password])
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

  # CA AUTHORIZE
  def ca_authorize
  end
end
