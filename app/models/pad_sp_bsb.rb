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

 # before_save :check_bsb_validity
 # before_save :check_benji_company
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

  attr_accessor :sp_bsb_checked_count_info, :force_check

  # 1. 同一被抽样单位(sp_s_215: 营业执照号)，一个抽样周期内，流通环节，上传只能5个；
  # 2. DELETED. 同一生产企业(sp_s_13: 生产号)，无论环节，不同产品，最多上传5个任务；
  # 3. 同一生产企业，同一样品名称，同一生产批次，不能下达第二次；
  # 4. 不看QS号,同一生产企业,一个季度(90天), 同一食品大类最多抽取3批
  def check_bsb_validity
    #return true if self.sp_s_215.blank? or self.sp_s_13.blank? or %w{抽检监测（总局本级一司） 抽检监测（总局本级三司） 抽检监测（三司专项）}.include?(self.sp_s_70)
    if self.sp_s_215.blank? or self.sp_s_13.blank? or self.sp_s_64.blank? or %w{抽检监测（总局本级一司） 抽检监测（三司专项）}.include?(self.sp_s_70) or self.sp_i_state == 18 or self.sp_s_2 == '网购' or %w{GC16000463016 GC16000463015 GC16000463014 GC16000463052 GC16000463051 GC16000463048 GC1600373049 GC1600373029 GC1600373030 GC1600373041 GC1600373039 GC1600373040 GC1600373031 GC1600373013 GC16000373013 GC16000373012 GC1600373014 GC1600373015 GC1600373017 GC1600373016 GC1600373010 GC1600373011 GC1600373035 GC1600373033 GC1600373021 GC16000373005 GC1600410160 GC1600133044 GC1600430012 GC1600430016 GC1600430116 GC1600430115 GC1600463386 GC1600463387 GC16000463011 GC1600463431 GC1600463329 GC1600463328 GC1600463327 GC1600463404 GC1600463403 GC1600463345 GC16000243033 GC16000243034 GC16000243035}.include?(self.sp_s_16)
      if self.sp_s_2.eql?('网购')
        self.sp_bsb_checked_count_info = '网购类无抽样限制'
      end
      return true
    end
    if self.force_check or (self.changes[:sp_i_state].present? and (([0, 1].include?(self.changes['sp_i_state'][0]) and self.changes['sp_i_state'][1] == 12) or ([14].include?(self.changes['sp_i_state'][0]) and self.changes['sp_i_state'][1] == 15)))
      now = Time.now

      result = true

      self.sp_bsb_checked_count_info = ''

      # 条件: 1
      if !%w{餐饮 生产}.include?(self.sp_s_68) and !%w{/ 、 - \ 无 ／}.include?(self.sp_s_215)
        pad_sp_bsbs = PadSpBsb.where("sp_s_215 = ? AND sp_s_68 = '流通' AND sp_i_state NOT IN (1,14,16,18) AND sp_s_2 <> '网购'", self.sp_s_215).where(created_at: now.all_quarter)

        sp_bsbs = SpBsb.where("sp_s_215 = ? AND sp_s_68 = '流通' AND sp_i_state NOT IN (0, 1) AND sp_s_2 <> '网购'", self.sp_s_215).where(created_at: now.all_quarter)
        if pad_sp_bsbs.count != 0
          sp_bsbs = sp_bsbs.where('sp_s_16 NOT IN (?)', pad_sp_bsbs.pluck(:sp_s_16))
        end
        sp_bsb_checked_count = sp_bsbs.count + pad_sp_bsbs.count
        info = "同一被抽样单位，当前季度内，流通环节，最多抽取10批, 已经抽取#{sp_bsb_checked_count}批次"
        self.sp_bsb_checked_count_info = info + "\n\n"
        if sp_bsb_checked_count > 10
          errors.add(:base, info)
          result = false
        end
      end

      # 条件: 2
=begin
      unless %w{/ 、 - \ 无}.include?(self.sp_s_13)
        pad_sp_bsbs = PadSpBsb.where("sp_s_13 = ? AND sp_s_64 = ? AND sp_i_state NOT IN (1,14,16,18) AND sp_s_2 <> '网购'", self.sp_s_13, self.sp_s_64).where(created_at: now.all_quarter)

        sp_bsbs = SpBsb.where("sp_s_13 = ? AND sp_s_64 = ? AND sp_i_state NOT IN (0, 1) AND sp_s_2 <> '网购'", self.sp_s_13, self.sp_s_64).where(created_at: now.all_quarter)

        if pad_sp_bsbs.count != 0
          sp_bsbs = sp_bsbs.where('sp_s_16 NOT IN (?)', pad_sp_bsbs.pluck(:sp_s_16))
        end

        sp_bsb_checked_count = sp_bsbs.count + pad_sp_bsbs.count
        info = "同一生产企业，同一个抽样周期内, 无论环节，不同产品，最多抽取5批, 已抽取#{sp_bsb_checked_count}批次"
        self.sp_bsb_checked_count_info += (info + "\n")
        if sp_bsb_checked_count > 5
          errors.add(:base, info)
          result = false
        end
      end
=end

      # 条件: 3
      unless %w{/ 、 - \ 无 ／}.include?(self.sp_s_13)
        pad_sp_bsbs = PadSpBsb.where("sp_s_14 = ? AND sp_s_13 = ? AND sp_d_28 = ? AND sp_i_state not in (1,14,16,18) AND sp_s_2 <> '网购'", self.sp_s_14, self.sp_s_13, self.sp_d_28).where(created_at: now.all_quarter)
        sp_bsbs = SpBsb.where("sp_s_14 = ? AND sp_s_13 = ? AND sp_d_28 = ? AND sp_i_state NOT IN (0, 1) AND sp_s_2 <> '网购'", self.sp_s_14, self.sp_s_13, self.sp_d_28).where(created_at: now.all_quarter)

        if pad_sp_bsbs.count != 0
          sp_bsbs = sp_bsbs.where('sp_s_16 NOT IN (?)', pad_sp_bsbs.pluck(:sp_s_16))
        end


        sp_bsb_checked_count = sp_bsbs.count + pad_sp_bsbs.count
        info = "同一生产企业，当前季度内, 同一样品名称，同一生产日期，最多抽取1批, 已抽取#{sp_bsb_checked_count}批次"
        self.sp_bsb_checked_count_info += (info + "\n\n")
        if sp_bsb_checked_count > 0
          errors.add(:base, info)
          result = false
        end
      end

      # --> 条件: 4
      unless %w{/ 、 - \ 无 ／}.include?(self.sp_s_13)
        pad_sp_bsbs = PadSpBsb.where("sp_s_17 = ? AND sp_s_13 = ? AND sp_i_state not in (1,14,16,18) AND sp_s_2 <> '网购'", self.sp_s_17, self.sp_s_13).where(created_at: now.all_quarter)
        sp_bsbs = SpBsb.where("sp_s_17 = ? AND sp_s_13 = ? AND sp_i_state NOT IN (0, 1) AND sp_s_2 <> '网购'", self.sp_s_17, self.sp_s_13).where(created_at: now.all_quarter)

        if pad_sp_bsbs.count != 0
          sp_bsbs = sp_bsbs.where('sp_s_16 NOT IN (?)', pad_sp_bsbs.pluck(:sp_s_16))
        end

        sp_bsb_checked_count = sp_bsbs.count + pad_sp_bsbs.count
        info = "同一生产企业, 当前季度内, 同一食品大类最多抽取3批, 已抽取#{sp_bsb_checked_count}批次"
        self.sp_bsb_checked_count_info += (info + "\n\n")
        if sp_bsb_checked_count > 3
          errors.add(:base, info)
          result = false
        end
      end
      # <-- 条件: 4

      # --> 额外信息
      pad_sp_bsbs = PadSpBsb.where('sp_s_13 = ? AND created_at BETWEEN ? AND ? AND sp_i_state not in (1,14,16,18)', self.sp_s_13, now.beginning_of_year, now)
      sp_bsbs = SpBsb.where('sp_s_13 = ? AND created_at BETWEEN ? AND ? AND sp_i_state NOT IN (0, 1)', self.sp_s_13, now.beginning_of_year, now)

      if pad_sp_bsbs.count != 0
        sp_bsbs = sp_bsbs.where('sp_s_16 NOT IN (?)', pad_sp_bsbs.pluck(:sp_s_16))
      end

      #
      if self.sp_s_70.eql?('抽检监测（地方）') and SpProductionInfo.where('benji_only = 1').pluck(:qymc).include?(self.sp_s_64)
        self.sp_bsb_checked_count_info += '该大型企业仅限局本级抽检' + "\n\n"
      end

      sp_bsb_checked_count = sp_bsbs.count + pad_sp_bsbs.count
      info = "该生产企业本年度已被抽检#{sp_bsb_checked_count}批次"
      self.sp_bsb_checked_count_info += info
      #if sp_bsb_checked_count > 0
      #  errors.add(:base, info)
      #  result = false
      #end
      # <-- 额外信息
    end
    result
  end
  def check_benji_company
    if self.sp_s_70.eql?('抽检监测（地方）') and SpProductionInfo.where('benji_only = 1').pluck(:qymc).include?(self.sp_s_64)
      if self.sp_s_reason.blank? and (self.changes[:sp_i_state].present? and ([1, 14].include?(self.changes[:sp_i_state][0]) and [2, 15].include?(self.changes[:sp_i_state][1])))
        self.errors.add(:base, '该大型企业仅限局本级抽检')
        return false
      else
        return true
      end
    end
  end
  # 生成规则
  def generate_id_number
    if self.sp_s_16.blank? and self.sp_i_state == ::PadSpBsb::Step::DEPLOYED
      i = 0
      loop do
        i = i + 1
        @id_parts = ['SC']
        @id_parts.push(Time.now.year.to_s[2..3])
        # if self.sys_province_id == -1
        #   @id_parts.push("00")
        # else
        #   @id_parts.push(SysProvince.find(self.sys_province_id.to_i).code)
        # end
        @id_parts.push(SysProvince.find_by(:name => SysConfig.get(SysConfig::Key::PROV)).code)
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
