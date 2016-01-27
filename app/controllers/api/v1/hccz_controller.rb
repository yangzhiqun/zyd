#encoding: utf-8
class Api::V1::HcczController < ApplicationController
  skip_before_filter :session_expiry, :verify_authenticity_token
  before_filter :authorize, :only => [:list]
  skip_before_action :authenticate_user!

  # @param tab: 0 => 待安排, 1 => 待办理, 2 => 待审核
  # @param @user
  def list
    @begin_at = params[:begin_at].blank? ? (Time.now - 1.year) : DateTime.parse(params[:begin_at]).beginning_of_day
    @end_at = params[:end_at].blank? ? Time.now : DateTime.parse(params[:end_at]).end_of_day

    case params[:tab].to_i
      when 0
        if @user.hcz_czap == 0
          render json: {status: 'ERR', msg: '您没有核查处置安排权限'}
          return
        end
      when 1
        if @user.hcz_czbl == 0
          render json: {status: 'ERR', msg: '您没有核查处置办理权限'}
          return
        end
      when 2
        if @user.hcz_czsh == 0
          render json: {status: 'ERR', msg: '您没有核查处置审核权限'}
          return
        end
      else
        render json: {status: 'ERR', msg: '不存在该标签'}
    end

    # 非安排
    if params[:tab].to_i != 0
      @wtyp_czbs = WtypCzbPart.where("current_state = ?", params[:tab].to_i).order("id, updated_at desc").group('cjbh')

      # 如果不是管理员则进行省份区分 和 安排
      if @user.hcz_admin != 1
        @wtyp_czbs = @wtyp_czbs.where("((wtyp_czb_type = #{::WtypCzbPart::Type::LT} OR wtyp_czb_type = #{::WtypCzbPart::Type::CY}) AND bcydw_sheng = ?) OR (wtyp_czb_type = #{::WtypCzbPart::Type::SC} AND bsscqy_sheng = ?)", @user.user_s_province, @user.user_s_province)
        if params[:state].to_i == 1
          @wtyp_czbs = @wtyp_czbs.where("czfzr = ?", @user.id)
        end
      end
      @wtyp_czbs = @wtyp_czbs.select('ypmc, cjbh, cydd, jyjl, bsscqy_sheng, bcydw_sheng, id, updated_at, count(1) as count').where("updated_at between ? and ?", @begin_at, @end_at)
    else
      # 待安排列表
      @wtyp_czbs = SpBsb.select("sp_s_14 as ypmc, sp_s_16 as cjbh, sp_s_64 AS bsscqy_sheng, sp_s_68 AS cydd, sp_s_71 AS jyjl, sp_s_202 AS bsscqy_sheng, sp_s_3 AS bcydw_sheng, id, updated_at").order("updated_at DESC").where("id NOT IN (SELECT DISTINCT sp_bsb_id FROM wtyp_czb_parts WHERE (sp_bsb_id IS NOT NULL AND current_state <> 0 AND current_state IS NOT NULL) AND (((wtyp_czb_type = 2 OR wtyp_czb_type = 3) AND bcydw_sheng = ?) OR (wtyp_czb_type = 1 AND bsscqy_sheng = ?))) AND sp_i_state = 9 AND czb_reverted_flag = 0 AND (((sp_s_3 = ? OR sp_s_202 = ?) AND (sp_s_68 = '流通' OR sp_s_68 = '餐饮')) OR (sp_s_202 = ? AND sp_s_68 = '生产')) AND (sp_s_71 LIKE '%不合格%' OR sp_s_71 LIKE '%问题%')", @user.user_s_province, @user.user_s_province, @user.user_s_province, @user.user_s_province, @user.user_s_province)
    end
    @wtyp_czbs = @wtyp_czbs.paginate(:page => params[:page], :per_page => 10)

    render json: {status: 'OK', msg: "Data GOT.", type: params[:tab].to_i, czbs: @wtyp_czbs, pager: {total_page: @wtyp_czbs.total_pages, current_page: @wtyp_czbs.current_page}}
  end

  def report
    @spbsb = SpBsb.where('sp_s_16 = ? and sp_i_state = 9', params[:cjbh]).last

    if @spbsb.blank?
      render json: {status: 'ERR', msg: "样品信息不存在或已被删除"}, status: 422
      return
    end

    @jg_bsb = JgBsb.find_by_jg_name(@spbsb.sp_s_43)
    @jyxm_str = Spdatum.where(:sp_bsb_id => @spbsb.id).limit(3).map{|s| s.spdata_0}.join(",") + "等#{Spdatum.where(:sp_bsb_id => @spbsb.id).count}项。"
    #@jyjy_str = Spdatum.where(:sp_bsb_id => @spbsb.id,!spdata_4.eql?('/')).limit(2).map{|s| s.spdata_3}.join(",")
    @jyjy_str = Spdatum.where("sp_bsb_id= ? and spdata_4 <> ?",@spbsb.id,'/').limit(2).map{|s| s.spdata_3}.join(",")
    @jyjy_str4 = Spdatum.where("sp_bsb_id= ? and spdata_4 <> ?",@spbsb.id,'/').limit(2).map{|s| s.spdata_4}.join(",")
    #		@jyjy_str1 = Spdatum.where(:sp_bsb_id => @spbsb.id,:spdata_4 => '/').map{|s| s.spdata_3}.join(",")
    @jyjy_str1 = Spdatum.where("sp_bsb_id = ? and (spdata_4 = ? OR spdata_4 = ?)",@spbsb.id,'/','-').map{|s| s.spdata_3}.join(",")
    @splog = SpLog.where("sp_bsb_id = ? AND remark = ?", @spbsb.id, "检测机构批准").last
    #抽检项
    @cjx = Spdatum.where("sp_bsb_id = ? AND (spdata_2 LIKE '%合格项%' OR spdata_2 LIKE '%不合格项%')",@spbsb.id)
    #风险项
    @fxx = Spdatum.where("sp_bsb_id = ? AND (spdata_2 LIKE '%不判定项%' OR spdata_2 LIKE '%问题项%')",@spbsb.id)
    #问题项
    @wtx = Spdatum.where("sp_bsb_id = ? AND (spdata_2 LIKE ? OR spdata_2 LIKE ?)", @spbsb.id, "%不合格%", "%问题%")
    #合格项检验依据，取合格项的spdata_4
    #@hgx = Spdatum.where("sp_bsb_id = ? AND (spdata_2 LIKE ?)", @spbsb.id, "%合格项%")
    @jyyj_hgx_str4 = "经抽样检验，所检项目符合" + Spdatum.where("sp_bsb_id= ? and spdata_4 <> ? and spdata_2 like ?",@spbsb.id,'/',"%合格项%").map{|s| s.spdata_4}.join(",")+"要求。"

    #问题项字符串
    @wtx_str = Spdatum.where("sp_bsb_id = ? AND (spdata_2 LIKE ? OR spdata_2 LIKE ?)", @spbsb.id, "%不合格%", "%问题%").map{|s| s.spdata_0}.join(",")

    if @jg_bsb.blank?
      render json: {status: 'ERR', msg: "检验机构不存在"}, status: 422
      return
    end

    if @jg_bsb.pdf_sign_rules.blank?
      render json: {status: 'ERR', msg: "请配置[#{@jg_bsb.jg_name}]签章规则号后使用打印功能"}, status: 422
      return
    end

    if @spbsb.report_path.blank? or !File.exists?(@spbsb.absolute_report_path)
      tmp_file = Rails.root.join("tmp", "sp_bsbs_#{@spbsb.id}_print.pdf")
      render template: 'sp_bsbs/1.html.erb',
             save_to_file: tmp_file,
             save_only: true,
             pdf: "home",
             wkhtmltopdf: "/usr/local/bin/wkhtmltopdf",
             encoding: "utf-8",
             disable_javascript: true,
             show_as_html: params[:debug].present?,
             print_media_type: true,
             lowquality: false

      target_path = "#{Time.now.strftime("/%Y/%m/%d")}"
      abs_target_path = File.expand_path('../reports', Rails.root).to_s + target_path
      FileUtils.mkdir_p abs_target_path unless Dir.exists? abs_target_path

      SpBsb.record_timestamps = false
      @spbsb.report_path = "#{target_path}/#{@spbsb.id}.pdf"

      cmd = "java -jar #{Rails.root.join('bin', 'esspdf-client.jar')} #{Rails.application.config.site[:ca_pdf_address]} 8888 1 #{@jg_bsb.pdf_sign_rules} #{tmp_file} #{@spbsb.absolute_report_path}"
      logger.debug cmd

      result = `#{cmd}`
      FileUtils.rm_f(tmp_file)
      if result.strip.include?('200')
        FileUtils.rm_f(tmp_file)
        if @spbsb.save
          send_file @spbsb.absolute_report_path, filename: "#{@spbsb.sp_s_16}-检验报告.pdf", disposition: "inline"
        else
          render json: {status: 'ERR', msg: "错误：1#{@spbsb.errors.first.last}"}, status: 422
        end
      else
        render json: {status: 'ERR', msg: "错误：2#{@result}"}, status: 422
      end

      SpBsb.record_timestamps = true
    else
      send_file @spbsb.absolute_report_path, filename: "#{@spbsb.sp_s_16}-检验报告.pdf", disposition: "inline"
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
