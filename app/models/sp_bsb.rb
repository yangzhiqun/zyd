#encoding: utf-8
class SpBsb < ActiveRecord::Base
  include ApplicationHelper

  trigger.after(:insert) do
    "INSERT INTO tmp_sp_bsbs(id, sp_i_state, sp_s_16, sp_s_3, sp_s_202, sp_s_14, sp_s_43, sp_s_2_1, sp_s_35, sp_s_64, sp_s_1, sp_s_17, sp_s_20, sp_s_85, created_at, updated_at, sp_s_214, sp_s_71, fail_report_path, tname, user_id, uid, sp_s_18, sp_s_70, sp_s_215, sp_s_68, sp_s_13, sp_s_27, czb_reverted_flag) values(NEW.id, NEW.sp_i_state, NEW.sp_s_16, NEW.sp_s_3, NEW.sp_s_202, NEW.sp_s_14, NEW.sp_s_43, NEW.sp_s_2_1, NEW.sp_s_35, NEW.sp_s_64, NEW.sp_s_1, NEW.sp_s_17, NEW.sp_s_20, NEW.sp_s_85, NEW.created_at, NEW.updated_at, NEW.sp_s_214, NEW.sp_s_71, NEW.fail_report_path, NEW.tname, NEW.user_id, NEW.uid, NEW.sp_s_18, NEW.sp_s_70, NEW.sp_s_215, NEW.sp_s_68, NEW.sp_s_13, NEW.sp_s_27, NEW.czb_reverted_flag)"
  end

  trigger.after(:update).of(:updated_at, :sp_i_state) do
    "UPDATE tmp_sp_bsbs SET sp_i_state=NEW.sp_i_state, sp_s_16=NEW.sp_s_16, sp_s_3=NEW.sp_s_3, sp_s_202=NEW.sp_s_202, sp_s_14=NEW.sp_s_14, sp_s_43=NEW.sp_s_43, sp_s_2_1=NEW.sp_s_2_1, sp_s_35=NEW.sp_s_35, sp_s_64=NEW.sp_s_64, sp_s_1=NEW.sp_s_1, sp_s_17=NEW.sp_s_17, sp_s_20=NEW.sp_s_20, sp_s_85=NEW.sp_s_85, created_at=NEW.created_at, updated_at=NEW.updated_at, sp_s_214=NEW.sp_s_214, sp_s_71=NEW.sp_s_71, fail_report_path=NEW.fail_report_path, tname=NEW.tname, user_id=NEW.user_id, uid=NEW.uid, sp_s_18=NEW.sp_s_18, sp_s_70=NEW.sp_s_70, sp_s_215=NEW.sp_s_215, sp_s_68=NEW.sp_s_68, sp_s_13=NEW.sp_s_13, sp_s_27=NEW.sp_s_27, czb_reverted_flag=NEW.czb_reverted_flag where id=NEW.id"
  end

  trigger.after(:delete) do
    "DELETE FROM tmp_sp_bsbs where id=OLD.id"
  end

  attr_accessor :ca_source, :ca_sign
  validates_presence_of :sp_s_16, message: '请提供抽检单编号'
  validates_uniqueness_of :sp_s_16, message: '该单号已存在', allow_nil: true

	before_save :check_bsb_validity
	after_update :callback_when_updated

  # 核查处置完成情况
  def status_desc
    parts = WtypCzbPart.where(sp_bsb_id: self.id).select("wtyp_czb_type, current_state, id").as_json
    if parts.empty?
      return "未开始"
    end

    parts.each do |part|
      if part['wtyp_czb_type'] == ::WtypCzbPart::Type::SC
        @sc_state = part['current_state']
      elsif part['wtyp_czb_type'] == ::WtypCzbPart::Type::LT
        @lt_state = part['current_state']
      end
    end

    if @sc_state == ::WtypCzb::State::PASSED and @lt_state == ::WtypCzb::State::PASSED
      "已完成"
    elsif @sc_state == ::WtypCzb::State::PASSED and @lt_state != ::WtypCzb::State::PASSED
      "已完成-生产"
    elsif @sc_state != ::WtypCzb::State::PASSED and @lt_state == ::WtypCzb::State::PASSED
      "已完成-流通"
    elsif @sc_state != ::WtypCzb::State::PASSED and @lt_state != ::WtypCzb::State::PASSED
      "进行中"
    else
      "未知"
    end
  end

  def absolute_report_path
    return nil if self.report_path.blank?
    return File.expand_path('../reports', Rails.root).to_s + self.report_path
  end

  PUSH_BASE_DATA_FIELDS = [
      'sp_s_2_1', 'sp_s_70', 'sp_s_67', 'sp_s_1', 'sp_s_68', 'sp_s_2', 'sp_s_23', 'sp_s_215', 'sp_s_bsfl', 'sp_s_201', 'sp_s_3', 'sp_s_4', 'sp_s_5', 'sp_s_7', 'sp_s_10', 'sp_s_8', 'sp_s_9', 'sp_s_11', 'sp_s_12', 'sp_xkz', 'sp_xkz_id', 'sp_s_14', 'sp_s_203', 'sp_n_15', 'sp_s_6', 'sp_s_16', 'sp_s_17', 'sp_s_18', 'sp_s_19', 'sp_s_20', 'sp_s_61', 'sp_s_62', 'sp_s_63', 'sp_s_21', 'sp_d_22', 'sp_s_24', 'sp_s_25', 'sp_s_26', 'sp_s_27', 'sp_d_28', 'sp_n_29', 'sp_s_13', 'sp_s_72', 'sp_s_73', 'sp_s_74', 'sp_s_204', 'sp_s_205', 'sp_s_206', 'sp_s_207', 'sp_s_208', 'sp_s_64', 'sp_s_65', 'sp_s_202', 'sp_s_75', 'sp_s_76', 'sp_s_30', 'sp_n_31', 'sp_s_33', 'sp_n_32', 'sp_s_209', 'sp_s_210', 'sp_s_34', 'sp_s_35', 'sp_s_36', 'sp_s_52', 'sp_s_37', 'sp_d_38', 'sp_s_39', 'sp_s_40', 'sp_s_41', 'sp_s_42', 'sp_s_211', 'sp_s_212', 'sp_s_213', 'sp_s_43', 'sp_s_44', 'sp_s_45', 'sp_d_46', 'sp_d_47', 'sp_s_48', 'sp_s_49', 'sp_s_50', 'sp_s_51', 'sp_s_71', 'sp_s_214', 'sp_s_84', 'sp_s_85', 'sp_d_86', 'sp_s_87', 'sp_s_88'
  ]

  CA_FIELDS = [
      'sp_s_2_1', 'sp_s_70', 'sp_s_67', 'sp_s_1', 'sp_s_68', 'sp_s_2', 'sp_s_23', 'sp_s_215', 'sp_s_bsfl', 'sp_s_201', 'sp_s_3', 'sp_s_4', 'sp_s_5', 'sp_s_7', 'sp_s_10', 'sp_s_8', 'sp_s_9', 'sp_s_11', 'sp_s_12', 'sp_xkz', 'sp_xkz_id', 'sp_s_14', 'sp_s_203', 'sp_n_15', 'sp_s_6', 'sp_s_16', 'sp_s_17', 'sp_s_18', 'sp_s_19', 'sp_s_20', 'sp_s_61', 'sp_s_62', 'sp_s_63', 'sp_s_21', 'sp_d_22', 'sp_s_24', 'sp_s_25', 'sp_s_26', 'sp_s_27', 'sp_d_28', 'sp_n_29', 'sp_s_13', 'sp_s_72', 'sp_s_73', 'sp_s_74', 'sp_s_204', 'sp_s_205', 'sp_s_206', 'sp_s_207', 'sp_s_208', 'sp_s_64', 'sp_s_65', 'sp_s_202', 'sp_s_75', 'sp_s_76', 'sp_s_30', 'sp_n_31', 'sp_s_33', 'sp_n_32', 'sp_s_209', 'sp_s_210', 'sp_s_34', 'sp_s_35', 'sp_s_36', 'sp_s_52', 'sp_s_37', 'sp_d_38', 'sp_s_39', 'sp_s_40', 'sp_s_41', 'sp_s_42', 'sp_s_211', 'sp_s_212', 'sp_s_213', 'sp_s_43', 'sp_s_44', 'sp_s_45', 'sp_d_46', 'sp_d_47', 'sp_s_48', 'sp_s_49', 'sp_s_50', 'sp_s_51', 'sp_s_71', 'sp_s_214', 'sp_s_84', 'sp_s_85', 'sp_d_86', 'sp_s_87', 'sp_s_88'
  ]

  # 推送基本信息
  def push_base_data
    if self.sp_s_43.blank?
      return "该样品未指定送检机构"
    else
      jg_bsb = JgBsb.find_by_jg_name(self.sp_s_43)
      if jg_bsb.nil?
        return "该样品指定的送检机构不存在"
      else
        if jg_bsb.api_ip_address.blank?
          return "未设置推送接口IP地址"
        else
          form = {}

          PUSH_BASE_DATA_FIELDS.each do |field|
            form[field] = self.send(field)
          end
          Rails.logger.error "sending: #{form}"

          response = RestClient.post(jg_bsb.api_ip_address, form)
          json = JSON.parse(response)
          if json['status'] == 'OK'
            self.update_attributes({:synced => true})
            return nil
          else
            return json['msg']
          end
        end
      end
    end
  end

  def attachments_dir(folder)
    "#{Rails.application.config.attachment_path}/#{folder}"
  end

  def handle_uploaded_file(folder_name, file)
    path = "#{folder_name}/#{Time.now.strftime("%Y/%m/%d")}"
    target_folder = self.attachments_dir("#{path}")
    ext = File.extname(file.original_filename)
    file_md5 = Digest::MD5.file(file.path).hexdigest.upcase
    FileUtils.mkdir_p "#{target_folder}" unless Dir.exists? "#{target_folder}"
    FileUtils.mv(file.path, "#{target_folder}/#{file_md5}#{ext}")
    return "#{path}/#{file_md5}#{ext}"
  end

  # 抽样单电子版
  def cyd_file=(file)
    self.cyd_file_path = handle_uploaded_file("cyd_files", file) unless file.blank?
  end

  def cyd_file
    Rails.application.config.attachment_path + "/" + self.cyd_file_path unless self.cyd_file_path.blank?
  end

  # 抽样检验告知书
  def cyjygzs_file=(file)
    self.cyjygzs_file_path = handle_uploaded_file("cyjygzs_files", file) unless file.blank?
  end

  def cyjygzs_file
    Rails.application.config.attachment_path + "/" + self.cyjygzs_file_path unless self.cyjygzs_file_path.blank?
  end

  def is_wtyp_czb_processing?(user)
    WtypCzbPart.where("sp_bsb_id = ? AND current_state IN (1, 2, 3) AND ((wtyp_czb_type = #{::WtypCzbPart::Type::LT} AND bcydw_sheng = ?) OR (wtyp_czb_type = #{::WtypCzbPart::Type::SC} AND bsscqy_sheng = ?))", self.id, user.user_s_province, user.user_s_province).count > 0
  end

  def user_sign_for(state)
    @log = SpLog.where(sp_bsb_id: self.id, sp_i_state: state).last
    unless @log.nil?
      @user = User.find(@log.user_id)
      if @user.user_sign.blank?
        return "-#{@user.tname}-".html_safe
      else
        return "<img src='data:image/png;base64,#{@user.user_sign}'>".html_safe
      end
    else
      return "<font color='#999'>未记录</font>".html_safe
    end
  end

  def user_sign_forpz(state)
    spxlxz = self.sp_s_70
    if (spxlxz == "抽检监测（总局本级三司）" || spxlxz == "抽检监测（总局本级一司）" || spxlxz == "抽检监测（三司专项）")
      state = 9
    elsif (spxlxz == "三司专项检验")
      state = 9
    elsif (spxlxz == "网络专项检验")
      state = 9
    else
      state = 6
    end
    @logfive = SpLog.where(sp_bsb_id: self.id, sp_i_state: 5).order('id asc').last
		if @logfive.nil?
			return "<font color='#999'>未记录</font>".html_safe
		else
			@log = SpLog.where("sp_bsb_id = ? and sp_i_state = ? and id > ?",self.id, state, @logfive.id).order('id asc').first
			if @log.nil?
				@log = SpLog.where(sp_bsb_id: self.id, sp_i_state: 8).order('sp_i_state asc').last
			end
			unless @log.nil?
				@user = User.find(@log.user_id)
				if @user.user_sign.blank?
					return "-#{@user.tname}-".html_safe
				else
					return "<img src='data:image/png;base64,#{@user.user_sign}'>".html_safe
				end
			else
				return "<font color='#999'>未记录</font>".html_safe
			end
		end
  end

  # 延长15天异议登记时间
  def renew_yydj_valid_time
    self.update_attributes(yydj_enabled_by_admin_at: Time.now)
  end

  # 异议登记是否逾期15天
  def is_yydj_overdue?
    if !self.yydj_enabled_by_admin_at.nil?
      if Time.now.to_i - self.yydj_enabled_by_admin_at.to_i > 15.days.to_i
        return true
      else
        return false
      end
    end

    @passed_log = SpLog.where(sp_bsb_id: self.id, sp_i_state: 9).last

    return Time.now.to_i - self.updated_at.to_i > 15.days.to_i if @passed_log.nil?

    if Time.now.to_i - @passed_log.created_at.to_i > 15.days.to_i
      return true
    else
      return false
    end
  end

  # 用户是否有生产问题样品处置权限
  def sc_wtypcz_enabled?(user_prov)
    return false if user_prov.nil?
    self.sp_s_202.eql?(user_prov)
  end

  # 用户是否有经营问题样品处置权限
  def lt_wtypcz_enabled?(user_prov)
    return false if user_prov.nil?
    self.sp_s_3.eql?(user_prov)
  end

  def yydjb
    SpYydjb.find_by_cjbh(self.sp_s_16)
  end

  # 是否已经存在问题样品处理
  def wtyp_cz_present?
    WtypCzb.where('wtyp_sp_bsbs_id = ?', self.id).count > 0
  end

  has_many :spdata, :dependent => :delete_all
  has_many :api_exchange_pools, :dependent => :delete_all

  def is_bad_report?
    result = sp_s_71 || ''
    result.include?('问题样品') or result.include?('不合格样品')
  end

  # 1. 同一被抽样单位(sp_s_215: 营业执照号)，一个抽样周期内，流通环节，上传只能5个；
  # 2. 同一生产企业(sp_s_13: 生产号)，无论环节，不同产品，最多上传5个任务；
  # 3. 同一生产企业，同一样品名称，同一生产批次，不能下达第二次；
  def check_bsb_validity
    return true #if self.sp_s_215.blank? or self.sp_s_13.blank? or %w{抽检监测（总局本级一司） 抽检监测（总局本级三司） 抽检监测（三司专项）}.include?(self.sp_s_70)
		return true if self.sp_s_reason.present?
		if self.changes[:sp_i_state].present? and [0, 1].include?(self.changes['sp_i_state'][0]) and self.changes['sp_i_state'][1] == 2
			now = Time.now

			# 条件: 1
			if !%w{餐饮 生产}.include?(self.sp_s_68.strip) or !%w{/ 、 - \ 无}.include?(self.sp_s_215.strip)
			sp_bsb_count = TmpSpBsb.where("sp_s_215 = ? AND sp_s_68 = '流通' AND created_at BETWEEN ? AND ? AND sp_i_state NOT IN (0, 1)", self.sp_s_215, (now - 60.days), now).count
			pad_sp_bsb_count = PadSpBsb.where("sp_s_215 = ? AND sp_s_68 = '流通' AND created_at BETWEEN ? AND ? AND sp_i_state NOT IN (1, 16, 18)", self.sp_s_215, (now - 60.days), now).count
			if sp_bsb_count + pad_sp_bsb_count >= 20
				errors.add(:base, '同一被抽样单位，同一个抽样周期内，流通环节，只能下达10批')
				return false
			end
      end

			# 条件: 2
			if !%w{/ 、 - \ 无}.include?(self.sp_s_13.strip)
				sp_bsb_count = TmpSpBsb.where('sp_s_13 = ? AND created_at BETWEEN ? AND ? AND sp_i_state NOT IN (0, 1)', self.sp_s_13, (now - 60.days), now).count
				pad_sp_bsb_count = PadSpBsb.where('sp_s_13 = ? AND created_at BETWEEN ? AND ? AND sp_i_state NOT IN (1, 16, 18)', self.sp_s_13, (now - 60.days), now).count
				if sp_bsb_count + pad_sp_bsb_count >= 10
					errors.add(:base, '同一生产企业，同一个抽样周期内, 无论环节，不同产品，最多下达5批')
					return false
				end
			end

			# 条件: 3
		if !%w{/ 、 - \ 无}.include?(self.sp_s_13.strip)
			sp_bsb_count = TmpSpBsb.where('sp_s_14 = ? AND sp_s_13 = ? AND sp_s_27 = ? AND created_at BETWEEN ? AND ? AND sp_i_state NOT IN (0, 1)', self.sp_s_14, self.sp_s_13, self.sp_s_27, (now - 60.days), now).count
			pad_sp_bsb_count = PadSpBsb.where('sp_s_14 = ? AND sp_s_13 = ? AND sp_s_27 = ? AND created_at BETWEEN ? AND ? AND sp_i_state not in (1, 16, 18)', self.sp_s_14, self.sp_s_13, self.sp_s_27, (now - 60.days), now).count

			if sp_bsb_count + pad_sp_bsb_count >= 3
				errors.add(:base, '同一生产企业，同一个抽样周期内, 同一样品名称，同一生产批次，不能下达第2批')
				return false
			end
		end
		end
  end

	def callback_when_updated
		if self.via_api
			pool = ApiExchangePool.where(sp_s_16: self.sp_s_16, application_id: self.application_id, sp_bsb_id: self.id, fetched: false).last
			if pool.present?
				pool.attributes_changed = [pool.attributes_changed, self.changed_attributes.keys.join(',')].join(',')
				pool.save
			else
				ApiExchangePool.create(sp_s_16: self.sp_s_16, application_id: self.application_id, sp_bsb_id: self.id, attributes_changed: self.changed_attributes.keys.join(','))
			end
		end
	end
end
