#encoding: utf-8
class SpBsb < ActiveRecord::Base
  include ApplicationHelper
  # attr_accessible :report_path, :sp_s_1,:sp_s_2,:sp_s_3,:sp_s_4,:sp_s_5,:sp_s_6,:sp_s_7,:sp_s_8,:sp_s_9,:sp_s_10,:sp_s_11,:sp_s_12,:sp_s_13,:sp_s_14,:sp_n_15,:sp_s_16,:sp_s_17,:sp_s_18,:sp_s_19,:sp_s_20,:sp_s_21,:sp_d_22,:sp_s_23,:sp_s_24,:sp_s_25,:sp_s_26,:sp_s_27,:sp_d_28,:sp_n_29,:sp_s_30,:sp_n_31,:sp_n_32,:sp_s_33,:sp_s_34,:sp_s_35,:sp_s_36,:sp_s_37,:sp_d_38,:sp_s_39,:sp_s_40,:sp_s_41,:sp_s_42,:sp_s_43,:sp_s_44,:sp_s_45,:sp_d_46,:sp_d_47,:sp_s_48,:sp_s_49,:sp_s_50,:sp_s_51,:sp_s_52,:sp_s_53,:sp_s_54,:sp_s_55,:sp_s_56,:sp_s_57,:sp_s_58,:sp_s_59,:sp_s_60,:sp_s_61,:sp_s_62,:sp_s_63,:sp_s_64,:sp_s_65,:sp_s_66,:sp_s_67,:sp_s_68,:sp_s_69,:sp_s_70,:sp_s_71,:sp_s_72,:sp_s_73,:sp_s_74,:sp_s_75,:sp_s_76,:sp_s_77,:sp_s_78,:sp_s_79,:sp_s_80,:sp_s_81,:sp_s_82,:sp_s_83,:sp_s_84,:sp_s_85,:sp_d_86,:sp_s_87,:sp_s_88,:tname,
  # :sp_n_jcxcount,
  # :cyd_file, :cyjygzs_file,
  # :yydj_enabled_by_admin_at,
  # :sp_s_bsfl,
  # :sp_s_2_1,
  # :sp_s_18_1,
  # :sp_s_30_1,
  # :sp_s_33_1,
  # :sp_s_110_1,
  # :sp_s_110_2,
  # :sp_s_110_3,
  # :sp_s_110_4,
  # :sp_s_110_5,
  # :sp_s_110_6,
  # :sp_s_110_7,
  # :sp_s_110_8,
  # :sp_s_111_1,
  # :sp_s_111_2,
  # :sp_s_111_3,
  # :sp_s_111_4,
  # :sp_s_111_5,
  # :sp_s_111_6,
  # :sp_s_111_7,
  # :sp_s_111_8,
  # :sp_s_112_1,
  # :sp_s_112_2,
  # :sp_s_112_3,
  # :sp_s_112_4,
  # :sp_s_112_5,
  # :sp_s_112_6,
  # :sp_s_112_7,
  # :sp_s_112_8,
  # :sp_s_113_1,
  # :sp_s_113_2,
  # :sp_s_113_3,
  # :sp_s_113_4,
  # :sp_s_113_5,
  # :sp_s_113_6,
  # :sp_s_113_7,
  # :sp_s_113_8,
  # :sp_s_114_1,
  # :sp_s_114_2,
  # :sp_s_114_3,
  # :sp_s_114_4,
  # :sp_s_114_5,
  # :sp_s_114_6,
  # :sp_s_114_7,
  # :sp_s_114_8,
  # :sp_s_115_1,
  # :sp_s_115_2,
  # :sp_s_115_3,
  # :sp_s_115_4,
  # :sp_s_115_5,
  # :sp_s_115_6,
  # :sp_s_115_7,
  # :sp_s_115_8,
  # :sp_s_116_1,
  # :sp_s_116_2,
  # :sp_s_116_3,
  # :sp_s_116_4,
  # :sp_s_116_5,
  # :sp_s_116_6,
  # :sp_s_116_7,
  # :sp_s_116_8,
  # :sp_s_117_1,
  # :sp_s_117_2,
  # :sp_s_117_3,
  # :sp_s_117_4,
  # :sp_s_117_5,
  # :sp_s_117_6,
  # :sp_s_117_7,
  # :sp_s_117_8,
  # :sp_s_118_1,
  # :sp_s_118_2,
  # :sp_s_118_3,
  # :sp_s_118_4,
  # :sp_s_118_5,
  # :sp_s_118_6,
  # :sp_s_118_7,
  # :sp_s_118_8,
  # :sp_s_119_1,
  # :sp_s_119_2,
  # :sp_s_119_3,
  # :sp_s_119_4,
  # :sp_s_119_5,
  # :sp_s_119_6,
  # :sp_s_119_7,
  # :sp_s_119_8,
  # :sp_s_120_1,
  # :sp_s_120_2,
  # :sp_s_120_3,
  # :sp_s_120_4,
  # :sp_s_120_5,
  # :sp_s_120_6,
  # :sp_s_120_7,
  # :sp_s_120_8,
  # :sp_s_121_1,
  # :sp_s_121_2,
  # :sp_s_121_3,
  # :sp_s_121_4,
  # :sp_s_121_5,
  # :sp_s_121_6,
  # :sp_s_121_7,
  # :sp_s_121_8,
  # :sp_s_122_1,
  # :sp_s_122_2,
  # :sp_s_122_3,
  # :sp_s_122_4,
  # :sp_s_122_5,
  # :sp_s_122_6,
  # :sp_s_122_7,
  # :sp_s_122_8,
  # :sp_s_123_1,
  # :sp_s_123_2,
  # :sp_s_123_3,
  # :sp_s_123_4,
  # :sp_s_123_5,
  # :sp_s_123_6,
  # :sp_s_123_7,
  # :sp_s_123_8,
  # :sp_s_124_1,
  # :sp_s_124_2,
  # :sp_s_124_3,
  # :sp_s_124_4,
  # :sp_s_124_5,
  # :sp_s_124_6,
  # :sp_s_124_7,
  # :sp_s_124_8,
  # :sp_s_125_1,
  # :sp_s_125_2,
  # :sp_s_125_3,
  # :sp_s_125_4,
  # :sp_s_125_5,
  # :sp_s_125_6,
  # :sp_s_125_7,
  # :sp_s_125_8,
  # :sp_s_126_1,
  # :sp_s_126_2,
  # :sp_s_126_3,
  # :sp_s_126_4,
  # :sp_s_126_5,
  # :sp_s_126_6,
  # :sp_s_126_7,
  # :sp_s_126_8,
  # :sp_s_127_1,
  # :sp_s_127_2,
  # :sp_s_127_3,
  # :sp_s_127_4,
  # :sp_s_127_5,
  # :sp_s_127_6,
  # :sp_s_127_7,
  # :sp_s_127_8,
  # :sp_s_128_1,
  # :sp_s_128_2,
  # :sp_s_128_3,
  # :sp_s_128_4,
  # :sp_s_128_5,
  # :sp_s_128_6,
  # :sp_s_128_7,
  # :sp_s_128_8,
  # :sp_s_129_1,
  # :sp_s_129_2,
  # :sp_s_129_3,
  # :sp_s_129_4,
  # :sp_s_129_5,
  # :sp_s_129_6,
  # :sp_s_129_7,
  # :sp_s_129_8,
  # :sp_s_130_1,
  # :sp_s_130_2,
  # :sp_s_130_3,
  # :sp_s_130_4,
  # :sp_s_130_5,
  # :sp_s_130_6,
  # :sp_s_130_7,
  # :sp_s_130_8,
  # :sp_s_131_1,
  # :sp_s_131_2,
  # :sp_s_131_3,
  # :sp_s_131_4,
  # :sp_s_131_5,
  # :sp_s_131_6,
  # :sp_s_131_7,
  # :sp_s_131_8,
  # :sp_s_132_1,
  # :sp_s_132_2,
  # :sp_s_132_3,
  # :sp_s_132_4,
  # :sp_s_132_5,
  # :sp_s_132_6,
  # :sp_s_132_7,
  # :sp_s_132_8,
  # :sp_s_133_1,
  # :sp_s_133_2,
  # :sp_s_133_3,
  # :sp_s_133_4,
  # :sp_s_133_5,
  # :sp_s_133_6,
  # :sp_s_133_7,
  # :sp_s_133_8,
  # :sp_s_134_1,
  # :sp_s_134_2,
  # :sp_s_134_3,
  # :sp_s_134_4,
  # :sp_s_134_5,
  # :sp_s_134_6,
  # :sp_s_134_7,
  # :sp_s_134_8,
  # :sp_s_135_1,
  # :sp_s_135_2,
  # :sp_s_135_3,
  # :sp_s_135_4,
  # :sp_s_135_5,
  # :sp_s_135_6,
  # :sp_s_135_7,
  # :sp_s_135_8,
  # :sp_s_136_1,
  # :sp_s_136_2,
  # :sp_s_136_3,
  # :sp_s_136_4,
  # :sp_s_136_5,
  # :sp_s_136_6,
  # :sp_s_136_7,
  # :sp_s_136_8,
  # :sp_s_137_1,
  # :sp_s_137_2,
  # :sp_s_137_3,
  # :sp_s_137_4,
  # :sp_s_137_5,
  # :sp_s_137_6,
  # :sp_s_137_7,
  # :sp_s_137_8,
  # :sp_s_138_1,
  # :sp_s_138_2,
  # :sp_s_138_3,
  # :sp_s_138_4,
  # :sp_s_138_5,
  # :sp_s_138_6,
  # :sp_s_138_7,
  # :sp_s_138_8,
  # :sp_s_139_1,
  # :sp_s_139_2,
  # :sp_s_139_3,
  # :sp_s_139_4,
  # :sp_s_139_5,
  # :sp_s_139_6,
  # :sp_s_139_7,
  # :sp_s_139_8,
  # :sp_s_140_1,
  # :sp_s_140_2,
  # :sp_s_140_3,
  # :sp_s_140_4,
  # :sp_s_140_5,
  # :sp_s_140_6,
  # :sp_s_140_7,
  # :sp_s_140_8,
  # :sp_s_110_9,
  # :sp_s_111_9,
  # :sp_s_112_9,
  # :sp_s_113_9,
  # :sp_s_114_9,
  # :sp_s_115_9,
  # :sp_s_116_9,
  # :sp_s_117_9,
  # :sp_s_118_9,
  # :sp_s_119_9,
  # :sp_s_120_9,
  # :sp_s_121_9,
  # :sp_s_122_9,
  # :sp_s_123_9,
  # :sp_s_124_9,
  # :sp_s_125_9,
  # :sp_s_126_9,
  # :sp_s_127_9,
  # :sp_s_128_9,
  # :sp_s_129_9,
  # :sp_s_130_9,
  # :sp_s_131_9,
  # :sp_s_132_9,
  # :sp_s_133_9,
  # :sp_s_134_9,
  # :sp_s_135_9,
  # :sp_s_136_9,
  # :sp_s_137_9,
  # :sp_s_138_9,
  # :sp_s_139_9,
  # :sp_s_140_9,
  # :sp_s_110_0,
  # :sp_s_111_0,
  # :sp_s_112_0,
  # :sp_s_113_0,
  # :sp_s_114_0,
  # :sp_s_115_0,
  # :sp_s_116_0,
  # :sp_s_117_0,
  # :sp_s_118_0,
  # :sp_s_119_0,
  # :sp_s_120_0,
  # :sp_s_121_0,
  # :sp_s_122_0,
  # :sp_s_123_0,
  # :sp_s_124_0,
  # :sp_s_125_0,
  # :sp_s_126_0,
  # :sp_s_127_0,
  # :sp_s_128_0,
  # :sp_s_129_0,
  # :sp_s_130_0,
  # :sp_s_131_0,
  # :sp_s_132_0,
  # :sp_s_133_0,
  # :sp_s_134_0,
  # :sp_s_135_0,
  # :sp_s_136_0,
  # :sp_s_137_0,
  # :sp_s_138_0,
  # :sp_s_139_0,
  # :sp_s_140_0,
  # :sp_i_state,
  # :sp_i_jgback,
  # :sp_i_backtimes,
  # :sp_s_reason,
  # :submit_d_flag,
  # :sp_t_procedure,
  # :sp_s_200,
  # :sp_s_201,
  # :sp_s_202,
  # :sp_s_203,
  # :sp_s_204,
  # :sp_s_205,
  # :sp_s_206,
  # :sp_s_207,
  # :sp_s_208,
  # :sp_s_209,
  # :sp_s_210,
  # :sp_s_211,
  # :sp_s_212,
  # :sp_s_213,
  # :sp_s_214,
  # :sp_s_215,
  # :fail_report_path,
  # :fail_report_at,
  # :bgfl,
  # :sp_xkz,
  # :sp_xkz_id,
  # :updated_at,
  # :czb_reverted_flag,
  # :synced, :ca_source, :ca_sign

	attr_accessor :ca_source, :ca_sign

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
    @log = SpLog.where(sp_bsb_id: self.id, sp_i_state: state).order('sp_i_state asc').last
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
    WtypCzb.count(:conditions => ["wtyp_sp_bsbs_id = ?", self.id]) > 0
  end

	has_many :spdata, :dependent => :delete_all
	def is_bad_report?
  	result = sp_s_71 || ''
  	result.include?('问题样品') or result.include?('不合格样品')
	end
end
