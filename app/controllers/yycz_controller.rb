#encoding: utf-8
class YyczController < ApplicationController
  include ApplicationHelper
  def new
    @yycz = SpYydjb.new
    @yycz.djsj = Time.now
  end

  def create
    @yydjb = SpYydjb.new(yydjb_params)
    # @yydjb.current_state = SpYydjb::State::LOGGED
    @yydjb.yytcsj = Time.now
    @yydjb.yysdsj = Time.now
    @yydjb.djsj = Time.now
    @yydjb.session = session
    @yydjb.current_user = current_user


    if @yydjb.fjsqqk == 1
      @yydjb.fjsqsj = Time.now
      @yydjb.fjslrq = Time.now
    end

    @yydjb.djbm = current_user.jg_bsb.jg_name
    @yydjb.djr = current_user.tname
    @yydjb.djr_user_id = current_user.id

    # 2015年5月17日应 张秀宇 要求，去掉中间安排环节，直接将登记后的异议信息安排给当前登记人
    @yydjb.current_state = SpYydjb::State::ASSIGNED
    @yydjb.blr = current_user.tname
    @yydjb.blr_user_id = current_user.id
    @yydjb.blbm = current_user.jg_bsb.jg_name
    @yydjb.blsj = Time.now
    
    @bsb = SpBsb.find_by_sp_s_16(@yydjb.cjbh)

    # 如果当前异议提出时间超过5天，则标识为超期登记
    if Time.now - @bsb.updated_at >= 5.days
      @yydjb.dj_delayed = true
    end

    if @yydjb.save
      if @yydjb.fjsqqk == 1
        @spdata = @bsb.spdata
        @spdata.each do |data|
          if data.spdata_2.include? "问题" or data.spdata_2.include? "不合格"
            yydata = SpYydjbSpdata.new
            yydata.spdata_0 = data.spdata_0
            yydata.spdata_1 = data.spdata_1
            yydata.spdata_2 = data.spdata_2
            yydata.spdata_3 = data.spdata_3
            yydata.spdata_4 = data.spdata_4
            yydata.spdata_5 = data.spdata_5
            yydata.spdata_6 = data.spdata_6
            yydata.spdata_7 = data.spdata_7
            yydata.spdata_8 = data.spdata_8
            yydata.spdata_9 = data.spdata_9
            yydata.spdata_10 = data.spdata_10
            yydata.spdata_11 = data.spdata_11
            yydata.spdata_12 = data.spdata_12
            yydata.spdata_13 = data.spdata_13
            yydata.spdata_14 = data.spdata_14
            yydata.spdata_15 = data.spdata_15
            yydata.spdata_16 = data.spdata_16
            yydata.spdata_17 = data.spdata_17
            yydata.spdata_18 = data.spdata_18
            yydata.sp_yydjb_id = @yydjb.id
            yydata.save
          end
        end
      end
      redirect_to "/yycz/dj"
    else
			flash[:error] = @yydjb.errors.first.last
      redirect_to "/yycz/dj"
    end
  end

  def gzap
    if params[:current_tab].to_i == 0
      @yyczs = SpYydjb.where(:current_state => SpYydjb::State::LOGGED).order("created_at ASC")
    else
      @yyczs = SpYydjb.where(:current_state => SpYydjb::State::ASSIGNED).order("created_at ASC")
    end

    if current_user.yyadmin != 1
      @yyczs = @yyczs.where("bcydwsf = ? or bsscqysf = ?", current_user.user_s_province, current_user.user_s_province)
    end
  end

  def cztb
    @begin_at = params[:begin_at].blank? ? (Time.now - 1.year) : DateTime.parse(params[:begin_at]).beginning_of_day
    @end_at = params[:end_at].blank? ? Time.now : DateTime.parse(params[:end_at]).end_of_day
    @yyczs = SpYydjb.select("y.*").joins("as y left join sp_bsbs as s on y.cjbh = s.sp_s_16")

    if params[:current_tab].to_i == 0
      @yyczs = @yyczs.where("y.current_state = ? and (bcydws =? or bsscqys =?)", SpYydjb::State::ASSIGNED,current_user.prov_city,current_user.prov_city).order("y.created_at ASC")
    else
      @yyczs = @yyczs.where("y.current_state = ? and (bcydws =? or bsscqys =?)", SpYydjb::State::FILLED,current_user.prov_city,current_user.prov_city).order("y.created_at ASC")
    end

    if current_user.yyadmin != 1
      @yyczs = @yyczs.where("y.bcydwsf = ? or y.bsscqysf = ?", current_user.user_s_province, current_user.user_s_province)
    end

    # 样品名称
    unless params[:ypmc].blank?
      @yyczs = @yyczs.where("y.ypmc like ?", "%#{params[:ypmc]}%")
    end

    unless params[:bcydwmc].blank?
      @yyczs = @yyczs.where("s.sp_s_1 like ?", "%#{params[:bcydwmc]}%")
    end

    # 被抽样单位名称
		unless params[:bcydw_sheng].blank?
			@yyczs = @yyczs.where("s.sp_s_3 = ?", params[:bcydw_sheng])
		end

		# 表示生产企业名称
		unless params[:bsscqymc].blank?
			@yyczs = @yyczs.where("s.sp_s_64 like ?", "%#{params[:bsscqymc]}%")
		end

    # 表示生产企业省份
		unless params[:bsscqy_sheng].blank?
			@yyczs = @yyczs.where("s.sp_s_202 = ?", params[:bsscqy_sheng])
		end

		unless params[:cjbh].blank?
			@yyczs = @yyczs.where("y.cjbh like ?", "%#{params[:cjbh]}%")
		end

		unless params[:rwly].blank?
			case params[:rwly].to_i
			when 1
				@yyczs = @yyczs.where("y.cjbh LIKE ?", "____00%")
			when 2
				@yyczs = @yyczs.where("y.cjbh NOT LIKE ?", "____00%")
			end
		end 
  end

  def czsh
    @begin_at = params[:begin_at].blank? ? (Time.now - 1.year) : DateTime.parse(params[:begin_at]).beginning_of_day
    @end_at = params[:end_at].blank? ? Time.now : DateTime.parse(params[:end_at]).end_of_day
    @yyczs = SpYydjb.select("y.*").joins("as y left join sp_bsbs as s on y.cjbh = s.sp_s_16")

    if params[:current_tab].to_i == 0
      @yyczs = @yyczs.where("y.current_state = ?", SpYydjb::State::FILLED).order("y.created_at ASC")
    else
      @yyczs = @yyczs.where("y.current_state = ?", SpYydjb::State::PASSED).order("y.created_at ASC")
    end

    if current_user.yyadmin != 1
      @yyczs = @yyczs.where("y.bcydwsf = ? or y.bsscqysf = ?", current_user.user_s_province, current_user.user_s_province)
    end
    # 样品名称
    unless params[:ypmc].blank?
      @yyczs = @yyczs.where("y.ypmc like ?", "%#{params[:ypmc]}%")
    end

    unless params[:bcydwmc].blank?
      @yyczs = @yyczs.where("s.sp_s_1 like ?", "%#{params[:bcydwmc]}%")
    end

    # 被抽样单位名称
		unless params[:bcydw_sheng].blank?
			@yyczs = @yyczs.where("s.sp_s_3 = ?", params[:bcydw_sheng])
		end

		# 表示生产企业名称
		unless params[:bsscqymc].blank?
			@yyczs = @yyczs.where("s.sp_s_64 like ?", "%#{params[:bsscqymc]}%")
		end

    # 表示生产企业省份
		unless params[:bsscqy_sheng].blank?
			@yyczs = @yyczs.where("s.sp_s_202 = ?", params[:bsscqy_sheng])
		end

		unless params[:cjbh].blank?
			@yyczs = @yyczs.where("y.cjbh like ?", "%#{params[:cjbh]}%")
		end

		unless params[:rwly].blank?
			case params[:rwly].to_i
			when 1
				@yyczs = @yyczs.where("y.cjbh LIKE ?", "____00%")
			when 2
				@yyczs = @yyczs.where("y.cjbh NOT LIKE ?", "____00%")
			end
		end 
  end

  def dj
    if params[:cjbh].blank?
      @sp_bsbs = []
    else
      @sp_bsbs = SpBsb.select("s.*").group('s.sp_s_16').order('s.updated_at DESC').joins("AS s LEFT JOIN sp_yydjbs AS y ON s.sp_s_16=y.cjbh").where("y.current_state NOT IN (1, 2, 3) OR y.cjbh IS NULL").where("(s.sp_s_71 LIKE ? OR s.sp_s_71 LIKE ?) AND s.sp_i_state = 9", "%问题样品%", "%不合格样品%")

      if current_user.yyadmin != 1
        @sp_bsbs = @sp_bsbs.where("s.sp_s_3 = ? OR s.sp_s_202 = ?", current_user.user_s_province, current_user.user_s_province)
	@sp_bsbs = @sp_bsbs.where("s.sp_s_4 = ? OR s.sp_s_220 = ?", current_user.prov_city, current_user.prov_city)	
      end

      if !params[:cjbh].blank?
        @sp_bsbs = @sp_bsbs.where("s.sp_s_16 like ? ", "%#{params[:cjbh]}%")
      end
      @sp_bsbs = @sp_bsbs.paginate(:page => params[:page], :per_page => 30)
    end
  end

  def show
    @djb = SpYydjb.find(params[:id])
    @spdata = SpYydjbSpdata.where(:sp_yydjb_id => @djb.id)
    @sp_bsb =SpBsb.find_by_sp_s_16(@djb.cjbh)
    @attachments = Attachment.where("id in (?)", (@djb.attachments||"").split(","))

    respond_to do |format|
      format.html
    end
  end

  def download_file
    @yydjb = SpYydjb.find(params[:id])
    send_file("#{@yydjb.attachment_file}", :filename => "#{@yydjb.cjbh}#{File.extname(@yydjb.attachment_file)}", :disposition => 'inline')
  end

  def update
    @djb = SpYydjb.find(params[:id])
    @djb.session = session
    @djb.current_user = current_user

    if params[:current_step_finished].to_i == 1
      case @djb.current_state
      when SpYydjb::State::LOGGED
        @djb.current_state = SpYydjb::State::ASSIGNED
        @djb.blr = current_user.tname
        @djb.blr_user_id = current_user.id
        @djb.blbm = current_user.jg_bsb.jg_name
        @djb.blsj = Time.now
      when SpYydjb::State::ASSIGNED
        @djb.current_state = SpYydjb::State::FILLED
        @djb.tbr = current_user.tname
        @djb.tbr_user_id = current_user.id
        @djb.tbbm = current_user.jg_bsb.jg_name
        @djb.tbsj = Time.now
        @djb.yyczbm = current_user.jg_bsb.jg_name
        @djb.yyczfzr = current_user.tname
        @djb.fjwcsj = Time.now
      when SpYydjb::State::FILLED
        @djb.current_state = SpYydjb::State::PASSED
        @djb.shr = current_user.tname
        @djb.shr_user_id = current_user.id
        @djb.shbm = current_user.jg_bsb.jg_name
        @djb.shsj = Time.now

				if @djb.fjzt.eql?('复检合格')
					WtypCzbPart.where(cjbh: @djb.cjbh).update_all(current_state: -10)
					SpBsb.where(sp_s_16: @djb.cjbh).update_all(czb_reverted_flag: true)
					#WtypCzb.where(cjbh: @djb.cjbh).update_all(current_state: -10)
				end

      when SpYydjb::State::PASSED
        # TODO: 这里应该处理为什么步骤
      end
    end

    @bsb = SpBsb.find_by_sp_s_16(@djb.cjbh)

    params[:data].each do |data|
      logger.debug data.to_json
      spdata = SpYydjbSpdata.find(data["id"])
      spdata.fjjg = data["fjjg"]
      spdata.jgdw = data["jgdw"]
      if !data["fjjl"].blank?
        spdata.fjjl = data["fjjl"]
      end
      spdata.save
    end unless params[:data].blank?

    respond_to do |format|
      if params[:djb].blank?
        @djb.save
      else
        @djb.update_attributes(djb_params)
      end

      if params[:current_step_finished].to_i == 0
        format.html { redirect_to :back }
      else
        case @djb.current_state
        when SpYydjb::State::ASSIGNED
          format.html { redirect_to "/yycz/gzap"}
        when SpYydjb::State::FILLED
          format.html { redirect_to "/yycz/cztb"}
        when SpYydjb::State::PASSED
          format.html { redirect_to "/yycz/czsh"}
        else
          format.html { redirect_to :back }
        end
      end
    end
  end

  def yycz_info_by_cydbh
      @sp_bsb = SpBsb.find_by_sp_s_16(params[:cydbh])
      respond_to do |format|
        if @sp_bsb.is_bad_report?
          format.json { render :json => { :status => "OK", :msg => @sp_bsb}}
        else
          format.json { render :json => { :status => "ERR", :msg => "该样品检验结论不符合异议提出条件"}}
        end
      end
  end

  def assign_task
    respond_to do |format|
      @djbs = SpYydjb.where(:id => params[:ids].split(','))
      @bsbs = SpBsb.where(:sp_s_16 => @djbs.map{|djb| djb.cjbh })

      if @djbs.update_all(:yyczbm => params[:czbm], :yyczfzr => params[:czfzr], :current_state => SpYydjb::State::ASSIGNED, :blr => current_user.tname, :blbm => current_user.jg_bsb.jg_name, :blsj => Time.now)
        format.json { render :json => {:status => 'OK'}}
      else
        format.json { render :json => {:status => 'ERR', :msg => '失败！'}}
      end
    end
  end

  def from_bsb
    @yycz = SpYydjb.new
    @yycz.djsj = Time.now
    @bsb = SpBsb.find(params[:id])

    @yycz.cjbh = @bsb.sp_s_16
    @yycz.ypmc = @bsb.sp_s_14
    @yycz.ypgg = @bsb.sp_s_26
    @yycz.ypph = @bsb.sp_s_27
    @yycz.scrq = @bsb.sp_d_28
    @yycz.jyjl = @bsb.sp_s_71
    @yycz.bcydw = @bsb.sp_s_1
    @yycz.bcydwsf = @bsb.sp_s_3
    @yycz.cydw = @bsb.sp_s_35
    @yycz.cydwsf = @bsb.sp_s_52
    @yycz.bsscqy = @bsb.sp_s_64
    @yycz.bsscqysf = @bsb.sp_s_202

    render 'new'
  end

	def renew
		@result = []
		if params[:cjbh].blank?
			flash[:error] = "请提供编号列表"
		else
			params[:cjbh].split(/\r?\n/).each do |bh|
				if SpBsb.exists?(sp_s_16: bh)
					bsb = SpBsb.find_by_sp_s_16(bh)
					if bsb.renew_yydj_valid_time
						@result.push({cjbh: bh, result: "已延期15天"})
					else
						@result.push({cjbh: bh, result: "延期失败"})
					end
				else
					@result.push({cjbh: bh, result: "不存在"})
				end
			end
		end
	end

  def yycz_revert
    @djbs = SpYydjb.where(:id => params[:ids].split(','))
    
    @djbs.each do |djb|
      djb.session = session
      djb.current_user = current_user
      djb.thyy = (djb.thyy || "") + "<br>" + "操作时间：" + Time.now.to_s + ", 原因：" + params[:thyy] + ", 操作人员：" + current_user.tname + "(#{current_user.uid})"
      case djb.current_state
      when SpYydjb::State::LOGGED
        djb.current_state = SpYydjb::State::CANCEL
      when SpYydjb::State::ASSIGNED
        djb.current_state = SpYydjb::State::CANCEL
      when SpYydjb::State::FILLED
        djb.current_state = SpYydjb::State::ASSIGNED
      when SpYydjb::State::PASSED
				if current_user.yyadmin == 1
					djb.current_state = SpYydjb::State::ASSIGNED
				else
					djb.current_state = SpYydjb::State::FILLED
				end
      end
      djb.save
    end

    respond_to do |format|
      format.json { render :json => { :status => 'OK', :msg => ''}}
    end
  end

  private
  def yydjb_params
    params.require(:yycz).permit(:bcydws,:bsscqys,:attachments, :attachment_file, :sp_bsb_id, :yyczqk, :yyczzt, :yyczjg, :fjzt, :fjsqqk, :bcydw, :bcydwsf, :cydw, :cydwsf, :bsscqy, :bsscqysf, :yysdsj, :yytcsj, :yyfl, :yyczbm, :yyczfzr, :cjbh, :ypmc, :ypgg, :ypph, :jyjl, :scrq, :yytcr, :yynr, :fjsqr, :fjsqsj, :fjslrq, :fjwcsj, :fjjg, :bljg, :djbm, :djr, :djsj, :blbm, :blr, :blsj, :tbbm, :tbr, :tbsj, :shbm, :shr, :shsj, :dj_delayed,:gzscqyrq,:gzbcydwrq)
  end

  def djb_params
    params.require(:djb).permit(:bcydws,:bsscqys,:attachments, :attachment_file, :sp_bsb_id, :yyczqk, :yyczzt, :yyczjg, :fjzt, :fjsqqk, :bcydw, :bcydwsf, :cydw, :cydwsf, :bsscqy, :bsscqysf, :yysdsj, :yytcsj, :yyfl, :yyczbm, :yyczfzr, :cjbh, :ypmc, :ypgg, :ypph, :jyjl, :scrq, :yytcr, :yynr, :fjsqr, :fjsqsj, :fjslrq, :fjwcsj, :fjjg, :bljg, :djbm, :djr, :djsj, :blbm, :blr, :blsj, :tbbm, :tbr, :tbsj, :shbm, :shr, :shsj, :dj_delayed,:gzscqyrq,:gzbcydwrq)
  end
end
