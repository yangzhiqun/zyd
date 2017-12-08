#encoding=UTF-8
class WtypCzbsController < ApplicationController
  include ApplicationHelper
  # GET /wtyp_czbs
  # GET /wtyp_czbs.json
  before_filter :init

  def init
    @cz_options=[["未启动", "未启动"], ["已部署", "已部署"], ["已采取处置措施", "已采取处置措施"], ["处置完毕", "处置完毕"]]
    @czhj_options=[["请选择", ""], ["生产", "生产"], ["流通", "流通"], ["餐饮", "餐饮"]]
    @czrd_options=[["请选择", ""], ["确认企业为真实", "确认企业为真实"], ["认定为假冒企业产品", "认定为假冒企业产品"]]
    @czdealfix1_options=[["请选择", ""], ["封存扣押", "封存扣押"], ["召回下架", "召回下架"], ["停止生产经营", "停止生产经营"]]
    @czdealfix2_options=[["请选择", ""], ["是", "是"], ["否", "否"]]
    @hcczdw_options=[["请选择", ""], ["盒", "盒"], ["袋", "袋"], ["瓶", "瓶"], ["包", "包"], ["箱", "箱"]]
    @hcczwtyy_options=[["人为添加", "人为添加"], ["原料问题", "原料问题"], ["生产工艺", "生产工艺"], ["过程控制不严", "过程控制不严"], ["储运不当", "储运不当"], ["包装迁移", "包装迁移"], ["标签标识问题", "标签标识问题"]]
    @hcczfjjg_options=[["请选择", ""], ["合格", "合格"], ["不合格", "不合格"]]
    @hcczdx_options=[["请选择", ""], ["生产许可", "生产许可"], ["经营许可", "经营许可"], ["餐饮服务许可", "餐饮服务许可"], ["产品许可", "产品许可"]]
    @fcysrq_options=[["请选择", ""], ["已", "已"], ["预计", "预计"]]
  end

  def index

    @begin_at = params[:begin_at].blank? ? (Time.now - 1.year) : DateTime.parse(params[:begin_at]).beginning_of_day
    @end_at = params[:end_at].blank? ? Time.now : DateTime.parse(params[:end_at]).end_of_day

    params[:begin_at] = @begin_at
    params[:end_at] = @end_at

    @wtyp_czbs = WtypCzbPart.list_by(params, current_user)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @wtyp_czbs }
    end
  end

  # GET /wtyp_czbs/1
  # GET /wtyp_czbs/1.json
  def show
    @wtyp_czb = WtypCzb.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @wtyp_czb }
    end
  end

  def edit
    @sp_bsb=SpBsb.find(params[:id])

    @wtyp_czb = WtypCzb.find_by_wtyp_sp_bsbs_id(@sp_bsb.id)
    #@wtyp_czb =WtypCzb.find(params[:wtyp_czb_id])
    # 生产部分
    # 生产部分核查处置仅包含：生产 & 流通

    if params[:wtyp_czb_id].present?
      wtyp_czb_part = WtypCzbPart.where(id: params[:wtyp_czb_id])
    else
      wtyp_czb_part = WtypCzbPart.all
    end
    if !@sp_bsb.sp_s_68.eql?("餐饮") or (@sp_bsb.sp_s_68.eql?('餐饮') and @sp_bsb.sp_s_63.eql?('预包装'))
      @part_sc = wtyp_czb_part.where(wtyp_czb_type: WtypCzbPart::Type::SC, wtyp_czb_id: @wtyp_czb.id).first
     # @part_sc = WtypCzbPart.where(wtyp_czb_type: WtypCzbPart::Type::SC, wtyp_czb_id: @wtyp_czb.id,id: params[:wtyp_czb_id]).first
    end

    # [流通/餐饮]部分
    if @sp_bsb.sp_s_68.eql?("流通")
      @lt_cy_type = WtypCzbPart::Type::LT
    elsif @sp_bsb.sp_s_68.eql?("餐饮")
      @lt_cy_type = WtypCzbPart::Type::CY
    #elsif  @sp_bsb.sp_s_68.eql?('流通') and @sp_bsb.sp_s_2.eql?('网购')
     # @lt_cy_type = WtypCzbPart::Type::WC
    end
    @part_lt_cy = wtyp_czb_part.where(wtyp_czb_type: @lt_cy_type, wtyp_czb_id: @wtyp_czb.id).first
    #@part_lt_cy = WtypCzbPart.where(wtyp_czb_type: @lt_cy_type, wtyp_czb_id: @wtyp_czb.id, id: params[:wtyp_czb_id]).first
    if @sp_bsb.sp_s_68.eql?('流通') and @sp_bsb.sp_s_2.eql?('网购')
     @part_wc = wtyp_czb_part.where(wtyp_czb_type: WtypCzbPart::Type::WC, wtyp_czb_id: @wtyp_czb.id).first
     #@part_wc = WtypCzbPart.where(wtyp_czb_type: WtypCzbPart::Type::WC, wtyp_czb_id: @wtyp_czb.id,id: params[:wtyp_czb_id]).first
    end
    # #47 第10条，如果抽样环节是生产，则只处理生产，不处理流通
    @is_editing = WtypCzbPart.where('bcydw_sheng = ? OR bsscqy_sheng = ? AND wtyp_czb_id = ?', current_user.user_s_province, current_user.user_s_province, @wtyp_czb.id).where('current_state = ?', ::WtypCzb::State::ASSIGNED).count > 0

    @yydjb = SpYydjb.where('cjbh = ? AND current_state IN (1, 2, 3)', @sp_bsb.sp_s_16).last

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @wtyp_czb }
    end
  end

  # POST /wtyp_czbs
  # POST /wtyp_czbs.json
  def create
    @wtyp_czb = WtypCzb.new(params[:wtyp_czb])

    @wtyp_czb.current_state = ::WtypCzb::State::LOGGED
    result_record=WtypCzb.where("wtyp_sp_bsbs_id=? and wtyp_czb_type = ?", params[:wtyp_czb][:wtyp_sp_bsbs_id], @wtyp_czb.wtyp_czb_type).last
    respond_to do |format|
      if result_record==nil
        @sp_bsb=SpBsb.find(params[:wtyp_czb][:wtyp_sp_bsbs_id])
        if params[:wtyp_czb][:wtyp_no]=='1'
          SpBsb.record_timestamps = false
          @sp_bsb.update_attribute('sp_s_202', params[:sp_sf])
          SpBsb.record_timestamps = true
        end
        if @wtyp_czb.save
          @spdata = @sp_bsb.spdata
          @spdata.each do |data|
            if data.spdata_2.include? "问题" or data.spdata_2.include? "不合格"
              hczdata = SpHczSpdata.new
              hczdata.spdata_0 = data.spdata_0
              hczdata.spdata_1 = data.spdata_1
              hczdata.spdata_2 = data.spdata_2
              hczdata.spdata_3 = data.spdata_3
              hczdata.spdata_4 = data.spdata_4
              hczdata.spdata_5 = data.spdata_5
              hczdata.spdata_6 = data.spdata_6
              hczdata.spdata_7 = data.spdata_7
              hczdata.spdata_8 = data.spdata_8
              hczdata.spdata_9 = data.spdata_9
              hczdata.spdata_10 = data.spdata_10
              hczdata.spdata_11 = data.spdata_11
              hczdata.spdata_12 = data.spdata_12
              hczdata.spdata_13 = data.spdata_13
              hczdata.spdata_14 = data.spdata_14
              hczdata.spdata_15 = data.spdata_15
              hczdata.spdata_16 = data.spdata_16
              hczdata.spdata_17 = data.spdata_17
              hczdata.spdata_18 = data.spdata_18
              hczdata.sp_hcz_id = @wtyp_czb.id
              hczdata.save
            end
          end
          format.html { redirect_to "/wtyp_czbs/#{@wtyp_czb.wtyp_sp_bsbs_id}/edit" }
          format.json { render json: @wtyp_czb, status: :created, location: @wtyp_czb }
        else
          format.html { render action: "new" }
          format.json { render json: @wtyp_czb.errors, status: :unprocessable_entity }
        end
      else
        flash[:edit_result] = "新建处理不成功，该样品已处理，请刷新!"
        format.html { redirect_to "/sp_bsbs" }
      end
    end
  end

  # PUT /wtyp_czbs/1
  # PUT /wtyp_czbs/1.json
  def update
    @wtyp_czb = WtypCzb.find(params[:id])
    @sp_bsb = SpBsb.find(@wtyp_czb.wtyp_sp_bsbs_id)

    respond_to do |format|

      params[:parts].each do |part|
        next if part[:wtyp_czb_id].blank?
        next if part[:save_me].to_i == 0
        @wtyp_czb_part = WtypCzbPart.where(wtyp_czb_type: part[:wtyp_czb_type], wtyp_czb_id: part[:wtyp_czb_id]).first
   
        @wtyp_czb_part.current_user = current_user
        #if part[:tmp_save].to_i == 0
          @wtyp_czb_part.czfzr = current_user.id
       # end
        @wtyp_czb_part.czbm = current_user.jg_bsb.jg_name
        @wtyp_czb_part.update_attributes(part.permit(:wtyp_czb_id, :xc_attachment_file, :pc_attachment_file, :xz_attachment_file, :qd_attachment_file, :wtyp_contacts, :wtyp_date, :wtyp_deal_detail, :wtyp_deal_jg, :wtyp_deal_way, :wtyp_email, :wtyp_fax, :wtyp_jg, :wtyp_remark, :wtyp_state, :wtyp_tel, :wtyp_verify, :wtyp_sp_bsbs_id, :wtyp_no, :wtyp_deal_segment, :wtyp_deal_affirm, :wtyp_deal_site, :wtyp_deal_result, :wtyp_deal_fix1way, :wtyp_deal_fix2way, :wtyp_deal_fix3way, :wtyp_result_fix1way, :wtyp_result_fix2way, :wtyp_result_fix3way, :wtyp_result_fix4way, :wtyp_result_fix5way, :wtyp_result_fix6way, :wtyp_result_fix7way, :wtyp_result_fix8way, :current_state, :czb_type, :bcydw_sheng, :bsscqy_sheng, :yyzt, :yyfl, :yyczjg, :fjzt, :fjsqr, :fjsqsj, :fjslrq, :fjwcsj, :fjjgou, :blbm, :blr, :blsj, :tbbm, :tbr, :tbsj, :shbm, :shr, :shsj, :cjbh, :ypmc, :ypgg, :ypph, :jyjl, :bcydwmc, :cydwmc, :cydwsf, :bsscqymc, :scrq, :yytcr, :yytcsj, :yysdsj, :yynr, :djbm, :djr, :djsj, :fjsqzk, :bgfl, :yyczqk, :thyy, :czbm, :czfzr, :bgsbh, :cydd, :bcydwdz, :bsscqydz, :cyjs, :jymd, :jyjgzt, :bgfl, :qdhcczrq, :shbm, :czwbrq, :fxpj_1, :fxpj_2, :fxpj_3, :fxpj_4, :cpkzqk_1, :cpkzqk_2, :cpkzqk_3, :cpkzqk_4, :cpkzqk_5, :cpkzqk_6, :cpkzqk_7, :cpkzqk_8, :cpkzqk_9, :cpkzqk_10, :cpkzqk_11, :cpkzqk_12, :cpkzqk_13, :cpkzqk_14, :cpkzqk_15, :cpkzqk_16, :cpkzqk_17, :cpkzqk_18, :cpkzqk_19, :cpkzqk_20, :cpkzqk_21, :cpkzqk_22, :cpkzqk_23, :pczgfc_1, :pczgfc_2, :pczgfc_3, :pczgfc_4, :pczgfc_5, :pczgfc_6, :pczgfc_7, :pczgfc_8, :pczgfc_9, :xzcfqk_1, :xzcfqk_2, :xzcfqk_3, :xzcfqk_4, :xzcfqk_5, :xzcfqk_6, :xzcfqk_7, :xzcfqk_8, :xzcfqk_9, :xzcfqk_10, :xzcfqk_11, :xzcfqk_12, :xzcfqk_13, :xzcfqk_14, :xzcfqk_15, :xzcfqk_16, :xzcfqk_17, :xzcfqk_18, :xzcfqk_19, :xzcfqk_20, :xzcfqk_21, :hccz_type,
                                                     :part_submit_flag1, :part_submit_flag2, :part_submit_flag3, :part_submit_flag4, :part_submit_flag5, :part_submit_flag6, :part_submit_flag7, :wtyp_czb_type, :sp_bsb_id, :pczgfc_10, :pczgfc_11, :pczgfc_12, :pczgfc_16, :pczgfc_14, :pczgfc_15, :pczgfc_16, :pczgfc_17, :current_state_desc, :tmp_save, :part_submit, :save_me, :qdqk_sdrq, :qdqk_sfjs, :cpkzqk_wzhyy, :cpkzqk_sfdw, :cpkzqk_sfhl, :yypc_zsylly, :yypc_bhgscz, :yypc_wzcyy, :yypc_sfhl, :xzcf_rdyj, :xzcf_yjsfsd, :xzcf_cssfsd, :xzcf_wlayy, :xzcf_wcfyy, :xzcf_blasfhl, :zgfc_sftjbg, :zgfc_jgbmyj, :zgfc_zgsfhl, :tbys_tbqtbm, :tbys_xzbmmc, :tbys_sfjgmc, :tbys_sfla, :tbys_sftbys, :cpkzqk_kc, :cpkzqk_zj, :zgfc_fcrq, :tbys_sfsfys, :tbr_dh, :tbr_cz, :shr_dh, :shr_cz, :cpkzqk_kcdw, :yypc_yylbsc, :yypc_yylbys, :yypc_yylbxs, :wtyp_dbtype,:wc_sheng,:wc_shi,:wc_xian))
      end
      format.html { redirect_to :back }
    end
  end

  def xc_attachment
    @wtyp_czb_part = WtypCzbPart.find(params[:id])
    if @wtyp_czb_part.wtyp_czb_type == 1
      czb_type = '生产'
    end
    if @wtyp_czb_part.wtyp_czb_type == 2
      czb_type = '流通'
    end
    if @wtyp_czb_part.wtyp_czb_type == 3
      czb_type = '餐饮'
    end
    if @wtyp_czb_part.wtyp_czb_type == 4
     czb_type = '网抽'
    end
    send_file("#{@wtyp_czb_part.xc_attachment_file}", :filename => "#{@wtyp_czb_part.cjbh}-#{czb_type}-现场检查记录#{File.extname(@wtyp_czb_part.xc_attachment_file)}", :disposition => 'inline')
  end

  def pc_attachment
    @wtyp_czb_part = WtypCzbPart.find(params[:id])
    if @wtyp_czb_part.wtyp_czb_type == 1
      czb_type = '生产'
    end
    if @wtyp_czb_part.wtyp_czb_type == 2
      czb_type = '流通'
    end
    if @wtyp_czb_part.wtyp_czb_type == 3
      czb_type = '餐饮'
    end
    if @wtyp_czb_part.wtyp_czb_type == 4
     czb_type = '网抽'
    end
    send_file("#{@wtyp_czb_part.pc_attachment_file}", :filename => "#{@wtyp_czb_part.cjbh}-#{czb_type}-排查整改报告#{File.extname(@wtyp_czb_part.pc_attachment_file)}", :disposition => 'inline')
  end

  def xz_attachment
    @wtyp_czb_part = WtypCzbPart.find(params[:id])
    if @wtyp_czb_part.wtyp_czb_type == 1
      czb_type = '生产'
    end
    if @wtyp_czb_part.wtyp_czb_type == 2
      czb_type = '流通'
    end
    if @wtyp_czb_part.wtyp_czb_type == 3
      czb_type = '餐饮'
    end
    if @wtyp_czb_part.wtyp_czb_type == 4
      czb_type = '网抽'
    end
    send_file("#{@wtyp_czb_part.xz_attachment_file}", :filename => "#{@wtyp_czb_part.cjbh}-#{czb_type}-行政处罚通知书#{File.extname(@wtyp_czb_part.xz_attachment_file)}", :disposition => 'inline')
  end

  def qd_attachment
    @wtyp_czb_part = WtypCzbPart.find(params[:id])
    if @wtyp_czb_part.wtyp_czb_type == 1
      czb_type = '生产'
    end
    if @wtyp_czb_part.wtyp_czb_type == 2
      czb_type = '流通'
    end
    if @wtyp_czb_part.wtyp_czb_type == 3
      czb_type = '餐饮'
    end
    if @wtyp_czb_part.wtyp_czb_type == 4
      czb_type = '网抽'
    end
    send_file("#{@wtyp_czb_part.qd_attachment_file}", :filename => "#{@wtyp_czb_part.cjbh}-#{czb_type}-启动文书#{File.extname(@wtyp_czb_part.qd_attachment_file)}", :disposition => 'inline')
  end

  # DELETE /wtyp_czbs/1
  # DELETE /wtyp_czbs/1.json
  def destroy
    @wtyp_czb = WtypCzb.find(params[:id])
    @wtyp_czb.destroy

    respond_to do |format|
      format.html { redirect_to wtyp_czbs_url }
      format.json { head :no_content }
    end
  end

  def assign_task
    respond_to do |format|
      @czbs = WtypCzbPart.where(:id => params[:ids].split(','))

      if @czbs.update_all(:czbm => params[:czbm], :czfzr => params[:czfzr], :current_state => WtypCzb::State::ASSIGNED, :blr => current_user.tname, :blbm => current_user.jg_bsb.jg_name, :blsj => Time.now)
        format.json { render :json => {:status => 'OK'} }
      else
        format.json { render :json => {:status => 'ERR', :msg => '失败！'} }
      end
    end
  end

  def revert
    if params[:is_ap].eql?('true')
      @wtyp_czb_parts = WtypCzbPart.where(id: params[:ids].split(','))

      SpBsb.record_timestamps = false
      SpBsb.where(id: @wtyp_czb_parts.pluck(:sp_bsb_id)).each do |bsb|
        bsb.update_attributes(czb_reverted_flag: true, czb_reverted_reason: '操作时间：' + Time.now.to_s + ', 原因：' + params[:thyy] + ', 操作人员：' + current_user.tname)
      end
      @wtyp_czb_parts.destroy_all
      SpBsb.record_timestamps = true
    else
      @wtyp_czbs = WtypCzbPart.where(id: params[:ids].split(','))

      @wtyp_czbs.each do |czb|
        czb.thyy = (czb.thyy || '') + '<br>' + '操作时间：' + Time.now.to_s + ', 原因：' + params[:thyy] + ', 操作人员：' + current_user.tname + "(#{current_user.uid})"
        czb.current_user = current_user
        #czb.czfzr ="NULL"
        czb.reverting = true
        case czb.current_state
          when ::WtypCzb::State::LOGGED
            czb.current_state = ::WtypCzb::State::CANCEL
          when ::WtypCzb::State::ASSIGNED
            czb.current_state = ::WtypCzb::State::LOGGED
          when ::WtypCzb::State::FILLED
            czb.current_state = ::WtypCzb::State::ASSIGNED
            czb.part_submit_flag1 = false
            czb.part_submit_flag2 = false
            czb.part_submit_flag3 = false
            czb.part_submit_flag4 = false
            czb.part_submit_flag5 = false
            czb.part_submit_flag6 = false
            czb.part_submit_flag7 = false
            czb.czfzr = czb.blr_user_id
          when SpYydjb::State::PASSED
            czb.current_state = ::WtypCzb::State::FILLED
        end
        czb.save
      end
    end

    respond_to do |format|
      format.json { render :json => {:status => 'OK', :msg => ''} }
    end
  end

  def duban
    return not_found if current_user.hcz_admin != 1
    @part = WtypCzbPart.find(params[:part_id])
    if @part.wtyp_dbtype.to_i == 0
      @part.wtyp_dbtype = 1
    elsif @part.wtyp_dbtype.to_i == 1
      @part.wtyp_dbtype = 2
    end

    if @part.save
      render json: {status: 'OK'}
    else
      render json: {status: 'ERR', msg: @part.errors.first.last}
    end
  end
end

