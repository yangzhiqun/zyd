#encoding: utf-8
class PadSpBsb < ActiveRecord::Base

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

  attr_accessor :sp_bsb_checked_count

  # 1. 同一被抽样单位(sp_s_215: 营业执照号)，一个抽样周期内，流通环节，上传只能5个；
  # 2. 同一生产企业(sp_s_13: 生产号)，无论环节，不同产品，最多上传5个任务；
  # 3. 同一生产企业，同一样品名称，同一生产批次，不能下达第二次；
  def check_bsb_validity
    #return true if self.sp_s_215.blank? or self.sp_s_13.blank? or %w{抽检监测（总局本级一司） 抽检监测（总局本级三司） 抽检监测（三司专项）}.include?(self.sp_s_70)
    return true if self.sp_s_215.blank? or self.sp_s_13.blank? or self.sp_s_64.blank?
    now = Time.now

    # 条件: 1
    if !%w{餐饮 生产}.include?(self.sp_s_68) or !%w{/ 、 - \ 无}.include?(self.sp_s_215)
      pad_sp_bsbs = PadSpBsb.where("sp_s_215 = ? AND sp_s_68 = '流通' AND created_at BETWEEN ? AND ? AND sp_i_state NOT IN (1, 16, 18)", self.sp_s_215, (now - 60.days), now)

      sp_bsb_count = TmpSpBsb.where("sp_s_16 NOT IN (?) AND sp_s_215 = ? AND sp_s_68 = '流通' AND created_at BETWEEN ? AND ? AND sp_i_state NOT IN (0, 1)", pad_sp_bsbs.pluck(:sp_s_16), self.sp_s_215, (now - 60.days), now).count
      if sp_bsb_count + pad_sp_bsbs.count >= 10
        self.sp_bsb_checked_count = sp_bsb_count + pad_sp_bsbs.count
        errors.add(:base, '同一被抽样单位，同一个抽样周期内，流通环节，只能下达10批')
        return false
      end
    end

    # 条件: 2
    unless %w{/ 、 - \ 无}.include?(self.sp_s_13)
      pad_sp_bsbs = PadSpBsb.where('sp_s_13 = ? AND sp_s_64 = ? AND created_at BETWEEN ? AND ? AND sp_i_state NOT IN (1, 16, 18)', self.sp_s_13, self.sp_s_64, (now - 60.days), now)

      sp_bsb_count = TmpSpBsb.where('sp_s_16 NOT IN (?) AND sp_s_13 = ? AND sp_s_64 = ? AND created_at BETWEEN ? AND ? AND sp_i_state NOT IN (0, 1)', pad_sp_bsbs.pluck(:sp_s_16), self.sp_s_13, self.sp_s_64, (now - 60.days), now).count
      if sp_bsb_count + pad_sp_bsbs.count >= 5
        self.sp_bsb_checked_count = sp_bsb_count + pad_sp_bsbs.count
        errors.add(:base, '同一生产企业，同一个抽样周期内, 无论环节，不同产品，最多下达5批')
        return false
      end
    end

    # 条件: 3
    unless %w{/ 、 - \ 无}.include?(self.sp_s_13)
      pad_sp_bsbs = PadSpBsb.where('sp_s_14 = ? AND (sp_s_13 = ? AND sp_s_64 = ?) AND sp_s_27 = ? AND created_at BETWEEN ? AND ? AND sp_i_state not in (1, 16, 18)', self.sp_s_14, self.sp_s_13, self.sp_s_64, self.sp_s_27, (now - 60.days), now)
      sp_bsb_count = TmpSpBsb.where('sp_s_16 NOT IN (?) AND sp_s_14 = ? AND (sp_s_13 = ? AND sp_s_64 = ?) AND sp_s_27 = ? AND created_at BETWEEN ? AND ? AND sp_i_state NOT IN (0, 1)', pad_sp_bsbs.pluck(:sp_s_16), self.sp_s_14, self.sp_s_13, self.sp_s_64, self.sp_s_27, (now - 60.days), now).count

      if sp_bsb_count + pad_sp_bsbs.count >= 2
        self.sp_bsb_checked_count = sp_bsb_count + pad_sp_bsbs.count
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
