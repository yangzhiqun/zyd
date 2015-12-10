#encoding: utf-8
class PadSpBsb < ActiveRecord::Base
  # attr_accessible :sp_s_1,:sp_s_2,:sp_s_3,:sp_s_4,:sp_s_5,:sp_s_6,:sp_s_7,:sp_s_8,:sp_s_9,:sp_s_10,:sp_s_11,:sp_s_12,:sp_s_13,:sp_s_14,:sp_n_15,:sp_s_16,:sp_s_17,:sp_s_18,:sp_s_19,:sp_s_20,:sp_s_21,:sp_d_22,:sp_s_23,:sp_s_24,:sp_s_25,:sp_s_26,:sp_s_27,:sp_d_28,:sp_n_29,:sp_s_30,:sp_n_31,:sp_n_32,:sp_s_33,:sp_s_34,:sp_s_35,:sp_s_36,:sp_s_37,:sp_d_38,:sp_s_39,:sp_s_40,:sp_s_41,:sp_s_42,:sp_s_43,:sp_s_44,:sp_s_45,:sp_d_46,:sp_d_47,:sp_s_48,:sp_s_49,:sp_s_50,:sp_s_51,:sp_s_52,:sp_s_53,:sp_s_54,:sp_s_55,:sp_s_56,:sp_s_57,:sp_s_58,:sp_s_59,:sp_s_60,:sp_s_61,:sp_s_62,:sp_s_63,:sp_s_64,:sp_s_65,:sp_s_66,:sp_s_67,:sp_s_68,:sp_s_69,:sp_s_70,:sp_s_71,:sp_s_72,:sp_s_73,:sp_s_74,:sp_s_75,:sp_s_76,:sp_s_77,:sp_s_78,:sp_s_79,:sp_s_80,:sp_s_81,:sp_s_82,:sp_s_83,:sp_s_84,:sp_s_85,:sp_d_86,:sp_s_87,:sp_s_88,:tname,
		# :cyd_file, :cyjygzs_file,
  #   :sp_n_jcxcount,
  #   :sp_s_bsfl,
  #   :sp_s_2_1,
  #   :sp_s_18_1,
  #   :sp_s_30_1,
  #   :sp_s_33_1,
  #   :sp_s_110_1,
  #   :sp_s_110_2,
  #   :sp_s_110_3,
  #   :sp_s_110_4,
  #   :sp_s_110_5,
  #   :sp_s_110_6,
  #   :sp_s_110_7,
  #   :sp_s_110_8,
  #   :sp_s_111_1,
  #   :sp_s_111_2,
  #   :sp_s_111_3,
  #   :sp_s_111_4,
  #   :sp_s_111_5,
  #   :sp_s_111_6,
  #   :sp_s_111_7,
  #   :sp_s_111_8,
  #   :sp_s_112_1,
  #   :sp_s_112_2,
  #   :sp_s_112_3,
  #   :sp_s_112_4,
  #   :sp_s_112_5,
  #   :sp_s_112_6,
  #   :sp_s_112_7,
  #   :sp_s_112_8,
  #   :sp_s_113_1,
  #   :sp_s_113_2,
  #   :sp_s_113_3,
  #   :sp_s_113_4,
  #   :sp_s_113_5,
  #   :sp_s_113_6,
  #   :sp_s_113_7,
  #   :sp_s_113_8,
  #   :sp_s_114_1,
  #   :sp_s_114_2,
  #   :sp_s_114_3,
  #   :sp_s_114_4,
  #   :sp_s_114_5,
  #   :sp_s_114_6,
  #   :sp_s_114_7,
  #   :sp_s_114_8,
  #   :sp_s_115_1,
  #   :sp_s_115_2,
  #   :sp_s_115_3,
  #   :sp_s_115_4,
  #   :sp_s_115_5,
  #   :sp_s_115_6,
  #   :sp_s_115_7,
  #   :sp_s_115_8,
  #   :sp_s_116_1,
  #   :sp_s_116_2,
  #   :sp_s_116_3,
  #   :sp_s_116_4,
  #   :sp_s_116_5,
  #   :sp_s_116_6,
  #   :sp_s_116_7,
  #   :sp_s_116_8,
  #   :sp_s_117_1,
  #   :sp_s_117_2,
  #   :sp_s_117_3,
  #   :sp_s_117_4,
  #   :sp_s_117_5,
  #   :sp_s_117_6,
  #   :sp_s_117_7,
  #   :sp_s_117_8,
  #   :sp_s_118_1,
  #   :sp_s_118_2,
  #   :sp_s_118_3,
  #   :sp_s_118_4,
  #   :sp_s_118_5,
  #   :sp_s_118_6,
  #   :sp_s_118_7,
  #   :sp_s_118_8,
  #   :sp_s_119_1,
  #   :sp_s_119_2,
  #   :sp_s_119_3,
  #   :sp_s_119_4,
  #   :sp_s_119_5,
  #   :sp_s_119_6,
  #   :sp_s_119_7,
  #   :sp_s_119_8,
  #   :sp_s_120_1,
  #   :sp_s_120_2,
  #   :sp_s_120_3,
  #   :sp_s_120_4,
  #   :sp_s_120_5,
  #   :sp_s_120_6,
  #   :sp_s_120_7,
  #   :sp_s_120_8,
  #   :sp_s_121_1,
  #   :sp_s_121_2,
  #   :sp_s_121_3,
  #   :sp_s_121_4,
  #   :sp_s_121_5,
  #   :sp_s_121_6,
  #   :sp_s_121_7,
  #   :sp_s_121_8,
  #   :sp_s_122_1,
  #   :sp_s_122_2,
  #   :sp_s_122_3,
  #   :sp_s_122_4,
  #   :sp_s_122_5,
  #   :sp_s_122_6,
  #   :sp_s_122_7,
  #   :sp_s_122_8,
  #   :sp_s_123_1,
  #   :sp_s_123_2,
  #   :sp_s_123_3,
  #   :sp_s_123_4,
  #   :sp_s_123_5,
  #   :sp_s_123_6,
  #   :sp_s_123_7,
  #   :sp_s_123_8,
  #   :sp_s_124_1,
  #   :sp_s_124_2,
  #   :sp_s_124_3,
  #   :sp_s_124_4,
  #   :sp_s_124_5,
  #   :sp_s_124_6,
  #   :sp_s_124_7,
  #   :sp_s_124_8,
  #   :sp_s_125_1,
  #   :sp_s_125_2,
  #   :sp_s_125_3,
  #   :sp_s_125_4,
  #   :sp_s_125_5,
  #   :sp_s_125_6,
  #   :sp_s_125_7,
  #   :sp_s_125_8,
  #   :sp_s_126_1,
  #   :sp_s_126_2,
  #   :sp_s_126_3,
  #   :sp_s_126_4,
  #   :sp_s_126_5,
  #   :sp_s_126_6,
  #   :sp_s_126_7,
  #   :sp_s_126_8,
  #   :sp_s_127_1,
  #   :sp_s_127_2,
  #   :sp_s_127_3,
  #   :sp_s_127_4,
  #   :sp_s_127_5,
  #   :sp_s_127_6,
  #   :sp_s_127_7,
  #   :sp_s_127_8,
  #   :sp_s_128_1,
  #   :sp_s_128_2,
  #   :sp_s_128_3,
  #   :sp_s_128_4,
  #   :sp_s_128_5,
  #   :sp_s_128_6,
  #   :sp_s_128_7,
  #   :sp_s_128_8,
  #   :sp_s_129_1,
  #   :sp_s_129_2,
  #   :sp_s_129_3,
  #   :sp_s_129_4,
  #   :sp_s_129_5,
  #   :sp_s_129_6,
  #   :sp_s_129_7,
  #   :sp_s_129_8,
  #   :sp_s_130_1,
  #   :sp_s_130_2,
  #   :sp_s_130_3,
  #   :sp_s_130_4,
  #   :sp_s_130_5,
  #   :sp_s_130_6,
  #   :sp_s_130_7,
  #   :sp_s_130_8,
  #   :sp_s_131_1,
  #   :sp_s_131_2,
  #   :sp_s_131_3,
  #   :sp_s_131_4,
  #   :sp_s_131_5,
  #   :sp_s_131_6,
  #   :sp_s_131_7,
  #   :sp_s_131_8,
  #   :sp_s_132_1,
  #   :sp_s_132_2,
  #   :sp_s_132_3,
  #   :sp_s_132_4,
  #   :sp_s_132_5,
  #   :sp_s_132_6,
  #   :sp_s_132_7,
  #   :sp_s_132_8,
  #   :sp_s_133_1,
  #   :sp_s_133_2,
  #   :sp_s_133_3,
  #   :sp_s_133_4,
  #   :sp_s_133_5,
  #   :sp_s_133_6,
  #   :sp_s_133_7,
  #   :sp_s_133_8,
  #   :sp_s_134_1,
  #   :sp_s_134_2,
  #   :sp_s_134_3,
  #   :sp_s_134_4,
  #   :sp_s_134_5,
  #   :sp_s_134_6,
  #   :sp_s_134_7,
  #   :sp_s_134_8,
  #   :sp_s_135_1,
  #   :sp_s_135_2,
  #   :sp_s_135_3,
  #   :sp_s_135_4,
  #   :sp_s_135_5,
  #   :sp_s_135_6,
  #   :sp_s_135_7,
  #   :sp_s_135_8,
  #   :sp_s_136_1,
  #   :sp_s_136_2,
  #   :sp_s_136_3,
  #   :sp_s_136_4,
  #   :sp_s_136_5,
  #   :sp_s_136_6,
  #   :sp_s_136_7,
  #   :sp_s_136_8,
  #   :sp_s_137_1,
  #   :sp_s_137_2,
  #   :sp_s_137_3,
  #   :sp_s_137_4,
  #   :sp_s_137_5,
  #   :sp_s_137_6,
  #   :sp_s_137_7,
  #   :sp_s_137_8,
  #   :sp_s_138_1,
  #   :sp_s_138_2,
  #   :sp_s_138_3,
  #   :sp_s_138_4,
  #   :sp_s_138_5,
  #   :sp_s_138_6,
  #   :sp_s_138_7,
  #   :sp_s_138_8,
  #   :sp_s_139_1,
  #   :sp_s_139_2,
  #   :sp_s_139_3,
  #   :sp_s_139_4,
  #   :sp_s_139_5,
  #   :sp_s_139_6,
  #   :sp_s_139_7,
  #   :sp_s_139_8,
  #   :sp_s_140_1,
  #   :sp_s_140_2,
  #   :sp_s_140_3,
  #   :sp_s_140_4,
  #   :sp_s_140_5,
  #   :sp_s_140_6,
  #   :sp_s_140_7,
  #   :sp_s_140_8,
  #   :sp_s_110_9,
  #   :sp_s_111_9,
  #   :sp_s_112_9,
  #   :sp_s_113_9,
  #   :sp_s_114_9,
  #   :sp_s_115_9,
  #   :sp_s_116_9,
  #   :sp_s_117_9,
  #   :sp_s_118_9,
  #   :sp_s_119_9,
  #   :sp_s_120_9,
  #   :sp_s_121_9,
  #   :sp_s_122_9,
  #   :sp_s_123_9,
  #   :sp_s_124_9,
  #   :sp_s_125_9,
  #   :sp_s_126_9,
  #   :sp_s_127_9,
  #   :sp_s_128_9,
  #   :sp_s_129_9,
  #   :sp_s_130_9,
  #   :sp_s_131_9,
  #   :sp_s_132_9,
  #   :sp_s_133_9,
  #   :sp_s_134_9,
  #   :sp_s_135_9,
  #   :sp_s_136_9,
  #   :sp_s_137_9,
  #   :sp_s_138_9,
  #   :sp_s_139_9,
  #   :sp_s_140_9,
  #   :sp_s_110_0,
  #   :sp_s_111_0,
  #   :sp_s_112_0,
  #   :sp_s_113_0,
  #   :sp_s_114_0,
  #   :sp_s_115_0,
  #   :sp_s_116_0,
  #   :sp_s_117_0,
  #   :sp_s_118_0,
  #   :sp_s_119_0,
  #   :sp_s_120_0,
  #   :sp_s_121_0,
  #   :sp_s_122_0,
  #   :sp_s_123_0,
  #   :sp_s_124_0,
  #   :sp_s_125_0,
  #   :sp_s_126_0,
  #   :sp_s_127_0,
  #   :sp_s_128_0,
  #   :sp_s_129_0,
  #   :sp_s_130_0,
  #   :sp_s_131_0,
  #   :sp_s_132_0,
  #   :sp_s_133_0,
  #   :sp_s_134_0,
  #   :sp_s_135_0,
  #   :sp_s_136_0,
  #   :sp_s_137_0,
  #   :sp_s_138_0,
  #   :sp_s_139_0,
  #   :sp_s_140_0,
  #   :sp_i_state,
  #   :sp_i_jgback,
  #   :sp_i_backtimes,
  #   :sp_s_reason,
  #   :submit_d_flag,
  #   :sp_t_procedure,
  #   :sp_s_200,
  #   :sp_s_201,
  #   :sp_s_202,
  #   :sp_s_203,
  #   :sp_s_204,
  #   :sp_s_205,
  #   :sp_s_206,
  #   :sp_s_207,
  #   :sp_s_208,
  #   :sp_s_209,
  #   :sp_s_210,
  #   :sp_s_211,
  #   :sp_s_212,
  #   :sp_s_213,
  #   :sp_s_214,
  #   :sp_s_215,
  #   :fail_report_path,
  #   :bgfl,
  #   :a_category_id,
  #   :b_category_id,
  #   :c_category_id,
  #   :d_category_id,
  #   :sys_province_id,
  #   :jg_bsb_id,
  #   :accept_or_not,
  #   :accept_file,
		# :gps,
  #   :refuse_reason,
  #   :sp_xkz,
  #   :sp_xkz_id

  attr_accessor :accept_or_not, :session

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

  def accept_file=(file)
    self.accept_file_path = handle_uploaded_file("accept_files", file) unless file.blank?
  end 

  def accept_file
    Rails.application.config.attachment_path + "/" + self.accept_file_path unless self.accept_file_path.blank?
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

  has_many :spdata, :foreign_key => :sp_bsb_id, :dependent => :delete_all
	has_many :sp_bsb_pictures, :foreign_key => 'sp_bsb_id'
  after_save :generate_id_number

  before_save :check_bsb_validity
  after_save :callback_when_updated

  module Step
    TMP_SAVE = 1
    DEPLOYED = 12
    ACCEPTED = 13
    ARRIVED = 14
    FINISHED = 15
    FAILED = 16
    SAMPLE_ACCEPTED = 17
    SAMPLE_REFUSED = 18
  end

  def is_bad_report?
    result = sp_s_71 || ''
    result.include?('问题样品') or result.include?('不合格样品')
  end

    # 日志记录
    def callback_when_updated
        remark_tmp = '123'
        if self.sp_i_state == 1
          remark_tmp = '临时保存'
        end
        if self.sp_i_state == 12
          remark_tmp = '下达任务'
        end
        if self.sp_i_state == 13
          remark_tmp = '接受任务'
        end
        if self.sp_i_state == 14
          remark_tmp = '到达现场'
        end
        if self.sp_i_state == 15
          remark_tmp = '提交'
        end
        if self.sp_i_state == 16
          remark_tmp = '无法抽检'
        end
        if self.sp_i_state == 17
          remark_tmp = '接收样品'
        end
        if self.sp_i_state == 18
          remark_tmp = '拒绝样品'
        end
        PadSpLogs.create({
            :remark => remark_tmp,
            :pad_sp_bsb_id => self.id,
            :sp_s_16 => self.sp_s_16,
            :sp_i_state => self.sp_i_state
           # :user_id => session[:user_id]
        })

    end

  # 1. 同一被抽样单位(sp_s_215: 营业执照号)，一个抽样周期内，流通环节，上传只能5个；
  # 2. 同一生产企业(sp_s_13: 生产号)，无论环节，不同产品，最多上传5个任务；
  # 3. 同一生产企业，同一样品名称，同一生产批次，不能下达第二次；
  def check_bsb_validity
    return true if self.sp_s_215.blank? or self.sp_s_13.blank?
    now = Time.now

    # 条件: 1
    if !%w{餐饮}.include?(self.sp_s_68) or !%w{/ 、- \\ 无}.include?(self.sp_s_215)
		sp_bsb_count = TmpSpBsb.where("sp_s_215 = ? AND sp_s_68 = '流通' AND created_at BETWEEN ? AND ? AND sp_i_state NOT IN (0, 1)", self.sp_s_215, (now - 60.days), now).count
    pad_sp_bsb_count = PadSpBsb.where("sp_s_215 = ? AND sp_s_68 = '流通' AND created_at BETWEEN ? AND ? AND sp_i_state NOT IN (1, 16, 18)", self.sp_s_215, (now - 60.days), now).count
    if sp_bsb_count + pad_sp_bsb_count >= 20
      errors.add(:base, '同一被抽样单位，同一个抽样周期内，流通环节，只能下达10批')
      return false
    end
    end

    # 条件: 2
		if !%w{/ 、- \\ 无}.include?(self.sp_s_13) and !self.sp_s_13.blank?
			sp_bsb_count = TmpSpBsb.where('sp_s_13 = ? AND created_at BETWEEN ? AND ? AND sp_i_state NOT IN (0, 1)', self.sp_s_13, (now - 60.days), now).count
			pad_sp_bsb_count = PadSpBsb.where('sp_s_13 = ? AND created_at BETWEEN ? AND ? AND sp_i_state NOT IN (1, 16, 18)', self.sp_s_13, (now - 60.days), now).count
			if sp_bsb_count + pad_sp_bsb_count >= 10
				errors.add(:base, '同一生产企业，同一个抽样周期内, 无论环节，不同产品，最多下达5批')
				return false
			end
    end

    # 条件: 3
    if !%w{/ 、- \\ 无}.include?(self.sp_s_13) and !self.sp_s_13.blank?  
	  sp_bsb_count = TmpSpBsb.where('sp_s_14 = ? AND sp_s_13 = ? AND sp_s_27 = ? AND created_at BETWEEN ? AND ? AND sp_i_state NOT IN (0, 1)', self.sp_s_14, self.sp_s_13, self.sp_s_27, (now - 60.days), now).count
    pad_sp_bsb_count = PadSpBsb.where('sp_s_14 = ? AND sp_s_13 = ? AND sp_s_27 = ? AND created_at BETWEEN ? AND ? AND sp_i_state not in (1, 16, 18)', self.sp_s_14, self.sp_s_13, self.sp_s_27, (now - 60.days), now).count

    if sp_bsb_count + pad_sp_bsb_count >= 3
      errors.add(:base, '同一生产企业，同一个抽样周期内, 同一样品名称，同一生产批次，不能下达第2批')
      return false
    end
		end
  end
	
	# 生成规则
  def generate_id_number
    if self.sp_s_16.blank? and self.sp_i_state == ::PadSpBsb::Step::DEPLOYED
			i = 0
			loop do
				i = i + 1
				@id_parts = ["GC"]
				@id_parts.push(Time.now.year.to_s[2..3])
				if self.sys_province_id == -1
					@id_parts.push("00")
				else
					@id_parts.push(SysProvince.level1.find(self.sys_province_id.to_i).code)
				end
				@id_parts.push(JgBsb.find(self.jg_bsb_id).code)
				count = 3000 + PadSpBsb.where(:sys_province_id => self.sys_province_id.to_i, :jg_bsb_id => self.jg_bsb_id).count + i
				@id_parts.push("%.4i" % count)

				break if !SpBsb.exists?(['sp_s_16 = ?', @id_parts.join('')]) and !PadSpBsb.exists?(['sp_s_16 = ?', @id_parts.join('')])
			end 

			self.sp_s_16 = @id_parts.join("")
			self.save
    end
  end
end
