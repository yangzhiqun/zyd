#encoding: utf-8
class SpBsb < ActiveRecord::Base
  include ApplicationHelper

  trigger.after(:insert) do
    "INSERT INTO tmp_sp_bsbs(sp_s_reason, id, sp_i_state, sp_s_16, sp_s_3, sp_s_202, sp_s_14, sp_s_43, sp_s_2_1, sp_s_35, sp_s_64, sp_s_1, sp_s_17, sp_s_20, sp_s_85, created_at, updated_at, sp_s_214, sp_s_71, fail_report_path, tname, user_id, uid, sp_s_18, sp_s_70, sp_s_215, sp_s_68, sp_s_13, sp_s_27, czb_reverted_flag) values(NEW.sp_s_reason, NEW.id, NEW.sp_i_state, NEW.sp_s_16, NEW.sp_s_3, NEW.sp_s_202, NEW.sp_s_14, NEW.sp_s_43, NEW.sp_s_2_1, NEW.sp_s_35, NEW.sp_s_64, NEW.sp_s_1, NEW.sp_s_17, NEW.sp_s_20, NEW.sp_s_85, NEW.created_at, NEW.updated_at, NEW.sp_s_214, NEW.sp_s_71, NEW.fail_report_path, NEW.tname, NEW.user_id, NEW.uid, NEW.sp_s_18, NEW.sp_s_70, NEW.sp_s_215, NEW.sp_s_68, NEW.sp_s_13, NEW.sp_s_27, NEW.czb_reverted_flag)"
  end

  trigger.after(:update).of(:updated_at, :sp_i_state) do
    "UPDATE tmp_sp_bsbs SET sp_s_reason=NEW.sp_s_reason, sp_i_state=NEW.sp_i_state, sp_s_16=NEW.sp_s_16, sp_s_3=NEW.sp_s_3, sp_s_202=NEW.sp_s_202, sp_s_14=NEW.sp_s_14, sp_s_43=NEW.sp_s_43, sp_s_2_1=NEW.sp_s_2_1, sp_s_35=NEW.sp_s_35, sp_s_64=NEW.sp_s_64, sp_s_1=NEW.sp_s_1, sp_s_17=NEW.sp_s_17, sp_s_20=NEW.sp_s_20, sp_s_85=NEW.sp_s_85, created_at=NEW.created_at, updated_at=NEW.updated_at, sp_s_214=NEW.sp_s_214, sp_s_71=NEW.sp_s_71, fail_report_path=NEW.fail_report_path, tname=NEW.tname, user_id=NEW.user_id, uid=NEW.uid, sp_s_18=NEW.sp_s_18, sp_s_70=NEW.sp_s_70, sp_s_215=NEW.sp_s_215, sp_s_68=NEW.sp_s_68, sp_s_13=NEW.sp_s_13, sp_s_27=NEW.sp_s_27, czb_reverted_flag=NEW.czb_reverted_flag where id=NEW.id"
  end

  trigger.after(:delete) do
    "DELETE FROM tmp_sp_bsbs where id=OLD.id"
  end

  attr_accessor :ca_source, :ca_sign
  validates_presence_of :sp_s_16, message: '请提供抽检单编号'
  validates_uniqueness_of :sp_s_16, message: '该单号已存在', allow_nil: true

  before_save :check_bsb_validity
  before_save :check_benji_company
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
 ## 判断是否为风险报告
  def is_jiance?
     self.sp_s_44.present? and (self.sp_s_44.include?('抽检监测') or self.sp_s_44.eql?('风险监测'))
  end
  # 判断是否为监督报告
  def is_jiandu?
     self.sp_s_44.present? and (self.sp_s_44.include?('监督抽检') or self.sp_s_44.eql?('抽检监测'))
  end

  def absolute_report_path(preview=false)
     #if self.report_path.blank? and !preview
      # return  Rails.root.join('tmp', "sp_bsbs_#{self.id}_print.pdf")
     #else
      # return nil
     #end
     logger.error self.report_path
     logger.error self.report_path.blank?
     return Rails.root.join('tmp', "sp_bsbs_#{self.id}_print.pdf")  if self.report_path.blank?
    return File.expand_path('../reports', Rails.root).to_s + self.report_path unless preview
    return Rails.root.join('tmp', 'report_preview').to_s + self.report_path if preview
  end

  PUSH_BASE_DATA_FIELDS = [
      'sp_s_2_1', 'sp_s_70', 'sp_s_67', 'sp_s_1', 'sp_s_68', 'sp_s_2', 'sp_s_23', 'sp_s_215', 'sp_s_bsfl', 'sp_s_201', 'sp_s_3', 'sp_s_4', 'sp_s_5', 'sp_s_7', 'sp_s_10', 'sp_s_8', 'sp_s_9', 'sp_s_11', 'sp_s_12', 'sp_xkz', 'sp_xkz_id', 'sp_s_14', 'sp_s_203', 'sp_n_15', 'sp_s_6', 'sp_s_16', 'sp_s_17', 'sp_s_18', 'sp_s_19', 'sp_s_20', 'sp_s_61', 'sp_s_62', 'sp_s_63', 'sp_s_21', 'sp_s_24', 'sp_s_25', 'sp_s_26', 'sp_s_27', 'sp_d_28', 'sp_n_29', 'sp_s_13', 'sp_s_72', 'sp_s_73', 'sp_s_74', 'sp_s_204', 'sp_s_205', 'sp_s_206', 'sp_s_222', 'sp_s_208', 'sp_s_202', 'sp_s_220', 'sp_s_221', 'sp_s_65', 'sp_s_64', 'sp_s_75', 'sp_s_76', 'sp_s_30', 'sp_n_31', 'sp_n_32', 'sp_s_33', 'sp_s_34', 'sp_s_35', 'sp_s_36', 'sp_s_52', 'sp_s_37', 'sp_d_38', 'sp_s_39', 'sp_s_40', 'sp_s_41', 'sp_s_42', 'sp_s_211', 'sp_s_212', 'sp_s_213', 'sp_s_43', 'sp_s_44', 'sp_s_45', 'sp_d_46', 'sp_d_47', 'sp_s_48', 'sp_s_49', 'sp_s_50', 'sp_s_51', 'sp_s_71', 'sp_s_214', 'sp_s_84', 'sp_s_85', 'sp_d_86', 'sp_s_87', 'sp_s_88'

  ]

  CA_FIELDS = [
      'sp_s_2_1', 'sp_s_70', 'sp_s_67', 'sp_s_1', 'sp_s_68', 'sp_s_2', 'sp_s_23', 'sp_s_215', 'sp_s_bsfl', 'sp_s_201', 'sp_s_3', 'sp_s_4', 'sp_s_5', 'sp_s_7', 'sp_s_10', 'sp_s_8', 'sp_s_9', 'sp_s_11', 'sp_s_12', 'sp_xkz', 'sp_xkz_id', 'sp_s_14', 'sp_s_203', 'sp_n_15', 'sp_s_6', 'sp_s_16', 'sp_s_17', 'sp_s_18', 'sp_s_19', 'sp_s_20', 'sp_s_61', 'sp_s_62', 'sp_s_63', 'sp_s_21', 'sp_d_22', 'sp_s_24', 'sp_s_25', 'sp_s_26', 'sp_s_27', 'sp_d_28', 'sp_n_29', 'sp_s_13', 'sp_s_72', 'sp_s_73', 'sp_s_74', 'sp_s_204', 'sp_s_205', 'sp_s_206', 'sp_s_207', 'sp_s_208', 'sp_s_64', 'sp_s_65', 'sp_s_202', 'sp_s_75', 'sp_s_76', 'sp_s_30', 'sp_n_31', 'sp_s_33', 'sp_n_32', 'sp_s_209', 'sp_s_210', 'sp_s_34', 'sp_s_35', 'sp_s_36', 'sp_s_52', 'sp_s_37', 'sp_d_38', 'sp_s_39', 'sp_s_40', 'sp_s_41', 'sp_s_42', 'sp_s_211', 'sp_s_212', 'sp_s_213', 'sp_s_43', 'sp_s_44', 'sp_s_45', 'sp_d_46', 'sp_d_47', 'sp_s_48', 'sp_s_49', 'sp_s_50', 'sp_s_51', 'sp_s_71', 'sp_s_214', 'sp_s_84', 'sp_s_85', 'sp_d_86', 'sp_s_87', 'sp_s_88'
  ]
  def publication_status
    p = self.published_sp_bsb
    if p.nil?
      return '<i style="color: red;">未发布</i>'
    else
      return '<i style="color: green;">已发布</i>'
    end
  end
  API_FIELDS = {
      :sp_s_2_1 => "任务来源",
      :sp_s_70 => "报送分类1",
      :sp_s_67 => "报送分类2",
      :sp_s_1 => "被抽样单位名称",
      :sp_s_68 => "抽样地点[生产/流通/餐饮]",
      :sp_s_2 => "抽样地点[原辅料库/生产线/半成品库]",
      :sp_s_23 => "年销售额",
      :sp_s_215 => "营业执照号",
      :sp_s_bsfl => "传真",
      :sp_s_201 => "区域类型",
      :sp_s_3 => "省(被抽样单位)",
      :sp_s_4 => "市(被抽样单位) ",
      :sp_s_5 => "县(被抽样单位)",
      :sp_s_7 => "单位地址(被抽样单位)",
      :sp_s_10 => "邮编(被抽样单位)",
      :sp_s_8 => "被抽样单位法人（负责人）",
      :sp_s_9 => "电话(被抽样单位法人)",
      :sp_s_11 => "被抽样单位负责（联系）人",
      :sp_s_12 => "电话(被抽样单位负责人)",
      :sp_xkz => "许可证",
      :sp_xkz_id => "许可证号",
      :sp_s_14 => "样品名称",
      :sp_s_203 => "样品属性",
      :sp_n_15 => "抽样数量",
      :sp_s_6 => "单位",
      :sp_s_16 => "抽样编号",
      :sp_s_17 => "食品大类",
      :sp_s_18 => "食品亚类",
      :sp_s_19 => "食品次亚类",
      :sp_s_20 => "食品细类",
      :sp_s_61 => "样品形态",
      :sp_s_62 => "样品类型*",
      :sp_s_63 => "包装分类",
      :sp_s_21 => "样品来源",
      # :sp_d_22 => "生产/加工/购进日期",
      :sp_s_24 => "抽样方式",
      :sp_s_25 => "抽样工具",
      :sp_s_26 => "样品规格",
      :sp_s_27 => "样品批号",
      :sp_d_28 => "生产日期",
      :sp_n_29 => "保质期",
      # :sp_s_66 => "保质期单位",
      :sp_s_13 => "生产许可证号",
      :sp_s_72 => "执行标准/技术文件",
      :sp_s_73 => "质量等级",
      :sp_s_74 => "商标",
      :sp_s_204 => "单价",
      :sp_s_205 => "是否出口",
      :sp_s_206 => "抽样基数/批量",
      :sp_s_222 => "条形码",
      # :sp_s_207 => "抽样数",
      :sp_s_208 => "备样数量",
      :sp_s_64 => "标识生产企业名称",
      :sp_s_65 => "标识生产企业地址",
      :sp_s_202 => "标识生产企业省",
      :sp_s_220 => "标识生产企业市",
      :sp_s_221 => "标识生产企业县",
      :sp_s_75 => "生产企业联系人",
      :sp_s_76 => "生产企业电话",
      :sp_s_30 => "抽样时样品存储状态",
      :sp_n_31 => "温度(℃)",
      :sp_s_33 => "抽样样品包装",
      :sp_n_32 => "湿度(%)",
      # :sp_s_209 => "寄、送样品截止日期",
      # :sp_s_210 => "寄送样品地址",
      :sp_s_33 => "样品包装",
      :sp_s_34 => "备注(样品)",
      :sp_s_35 => "抽样单位名称",
      :sp_s_36 => "单位级别*",
      :sp_s_52 => "所在省份",
      :sp_s_37 => "抽样人员",
      :sp_d_38 => "抽样时间",
      :sp_s_39 => "电话",
      :sp_s_40 => "抽样单位负责（联系）人*",
      :sp_s_41 => "电话(抽样单位负责人)*",
      :sp_s_42 => "电子邮箱(抽样单位负责人)*",
      :sp_s_211 => "单位地址（抽样单位）",
      :sp_s_212 => "邮编（抽样单位）",
      :sp_s_213 => "传真（抽样单位）",
      :sp_s_43 => "检验机构名称",
      :sp_s_44 => "检验目的/任务类别",
      :sp_s_45 => "报告书编号",
      :sp_d_46 => "收检日期",
      :sp_d_47 => "报告日期",
      :sp_s_48 => "报告签发人",
      :sp_s_49 => "联系人(检验机构)",
      :sp_s_50 => "电话(检验机构)",
      :sp_s_51 => "电子邮箱(检验机构)",
      :sp_s_71 => "结论",
      :sp_s_214 => "确认情况",
      :sp_s_84 => "备注(检验机构)",
      :sp_s_85 => "填报人(检验机构)",
      :sp_d_86 => "填报日期",
      :sp_s_87 => "电话(检验机构填报人)",
      :sp_s_88 => "电子邮箱(检验机构填报人)",
      #:jyxx_jyr => "检验人",
      #:jyxx_shhr => "审核人",
      #:jyxx_pzr => "批准人",
  }

  # 生成API json
  def to_api_json
    json = {spdata: []}
    SpBsb::API_FIELDS.keys.each do |key|
      json[key.to_sym] = self.send(key)
    end

    self.spdata.each do |data|
      j = {}
      ::Spdatum::API_FIELDS.keys.each do |key|
        j[key.to_sym] = data.send(key)
      end
      json[:spdata].push(j)
    end

    return json
  end

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
    @log = SpLog.where(sp_bsb_id: self.id, sp_i_state: state, ca_key_status: 0).last
    unless @log.nil?
      @user = User.find(@log.user_id)
      if !@user.tname.blank?
        return "-#{@user.tname}-".html_safe
      else
       # return "<img src='data:image/png;base64,#{@user.user_sign}'>".html_safe
       return "<font color='#999'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>".html_safe
	end
    else
      return "<font color='#999'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>".html_safe
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
    @logfive = SpLog.where(sp_bsb_id: self.id, sp_i_state: 5,ca_key_status: 0).order('id asc').last
    if @logfive.nil?
      return "<font color='#999'>&nbsp;&nbsp;&nbsp;</font>".html_safe
    else
      @log = SpLog.where("sp_bsb_id = ? and sp_i_state = ? and id > ?", self.id, state, @logfive.id).order('id asc').first
      if @log.nil?
        @log = SpLog.where(sp_bsb_id: self.id, sp_i_state: 16,ca_key_status: 0).order('sp_i_state asc').last
      end
      unless @log.nil?
        @user = User.find(@log.user_id)
        if !@user.tname.blank?
          return "-#{@user.tname}-".html_safe
        else
          #return "<img src='data:image/png;base64,#{@user.user_sign}'>".html_safe
         return "<font color='#999'>&nbsp;&nbsp;&nbsp;</font>".html_safe
	end
      else
        return "<font color='#999'>&nbsp;&nbsp;&nbsp;</font>".html_safe
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
  has_many :sp_bsb_stamp_rules
  has_many :sp_logs
  has_many :wtyp_czb_parts
  has_one :published_sp_bsb, foreign_key: 'cjbh', primary_key: 'sp_s_16'

  def wtyp_czbs
    WtypCzb.where(wtyp_sp_bsbs_id: self.id)
  end

  def is_bad_report?
    result = sp_s_71 || ''
    result.include?('问题样品') or result.include?('不合格样品')
  end

  # 1. 同一被抽样单位(sp_s_215: 营业执照号)，一个抽样周期内，流通环节，上传只能5个；
  # 2. DELETED. 同一生产企业(sp_s_13: 生产号)，无论环节，不同产品，最多上传5个任务；
  # 3. 同一生产企业，同一样品名称，同一生产批次，不能下达第二次；
  # 4. 不看QS号,同一生产企业,一个季度(90天), 同一食品大类最多抽取3批
  def check_bsb_validity
    #return true #if self.sp_s_215.blank? or self.sp_s_13.blank? or %w{抽检监测（总局本级一司） 抽检监测（总局本级三司） 抽检监测（三司专项）}.include?(self.sp_s_70)
    return true if self.sp_s_215.blank? or self.sp_s_13.blank? or %w{抽检监测（总局本级一司）}.include?(self.sp_s_70) or self.sp_s_64.blank? or self.sp_i_state == 18 or self.sp_s_2 == '网购' or %w{GC1600243697 GC1600243696 SC1622590001 SC1622590003 SC1622590004 SC1622590015 SC1622590016}.include?(self.sp_s_16)
    #return true if self.sp_s_215.blank? or self.sp_s_13.blank? or self.sp_s_64.blank? or self.sp_i_state == 18 or self.sp_s_2 == '网购' or %w{GC1600333159 GC1600153105 GC1600153106 GC1600153103 GC1600153066 GC1600153070 GC1600333182 GC1600333183 GC1600333160 GC1600333179 GC1600333247 GC1600333202 GC1600333240 GC1600333249 GC1600333181 GC1600333034 GC1600333033 GC1600333180 GC1551022141 GC1500162095 GC1600153104 GC1600183151 GC1600183035 GC1600153104 GC1600153177 GC1600153037 GC1600153042 GC1600153044 GC1600153119 GC1600153118 GC1600183151 GC1600183035 GC1600333262 GC1600333261 GC1600333263 GC1600333239 GC1600333238 GC1600333237 GC1600333227 GC1600333270 GC1600333271 GC1600333272 GC160033145 GC1600333146 GC1600333147 GC1600333148 GC1600333151 GC1600333191 GC1600333195 GC1600333194 GC1600333193 GC1600333192 GC1600153045 GC1600153041 GC1600153075 GC1600183136 GC1600183137 GC1600183138 GC1600183139 GC1600183141 GC1600183142 GC1600183143 GC1600183144 GC1600183145 GC1600183146 GC1600183159 GC1600183160 GC1600183108 GC1600183109 GC1600183110 GC1600183111 GC1600183112 GC1600183113 GC1600183114 GC1600183116 GC1600183120 GC1600183121 GC1600181114 GC1600181115 GC1600153060 GC1600153059 GC1600153043 GC1600153041 GC1600153075 GC1600153151 GC1600153152 GC1600333040 GC1600333041 GC1600333043 GC1600333044 GC1600333049 GC1600333050 GC1600333051 GC1600333052 GC1600333053 GC1600333042 GC1600333080 GC1600333081 GC1600333082 GC1600333083 GC1600333084 GC1600333085 GC1600333086 GC1600333087 GC1600333088 GC1600333089 GC1642010066 GC1600333015 GC1600333016 GC1600333018 GC1600333019 GC1600333020 GC1600333024 GC1600333025 GC1600333026 GC1600333039 GC1600333017 GC1600333054 GC1600333055 GC1600333064 GC1600333065 GC1600333066 GC1600333067 GC1600333068 GC1600333069 GC1600333070 GC1600333071 GC1600333130 GC1600333131 GC1600333090 GC1600333091 GC1600333092 GC1600333093 GC1600333094 GC1600333095 GC1600333117 GC1600333128 GC1600333129 GC1600333184 GC1600333187 GC1600333210 GC1600333110 GC1600433038 GC1600433035 GC1600433045 GC1600433046 GC1600433041 GC1600433040 GC1600433036 GC1600433037 GC1600433039 GC1600433044 GC1600433043 GC1600433042 GC1600363243 GC1600363244 GC1600363211 GC1600153034 GC1600153052 GC1600153208 GC1600153210 GC1600153243 GC1600153074 GC1600153028 GC1600153010 GC1600153032 GC1600153033 GC1600153046 GC1600153038 GC1600153051 GC1637088004 GC1600343052 GC1600343075 GC1600343073 GC1600343072 GC1600343043 GC1600343068 GC1600153261 GC1600153262 GC1600153260 GC1600153027 GC1622014039 GC1622014040 GC1622014041 GC1622014042 GC1622014043 GC1622014044 GC1622014005 GC1622014006 GC1622014012 GC1622013979 GC1622014023 GC1600153006 GC1600153083 GC1600153242 GC1600153239 GC1600153017 GC1600153211 GC1622014236 GC1622013985 GC1661033016 GC1661033025 GC1661033027 GC1661013020 GC1661013023 GC1661013019}.include?(self.sp_s_16)
    return true if self.sp_s_reason.present?
    if self.changes[:sp_i_state].present? and [0, 1].include?(self.changes['sp_i_state'][0]) and self.changes['sp_i_state'][1] == 2
      now = Time.now

      # 条件: 1
      if !%w{餐饮 生产}.include?(self.sp_s_68.strip) and !%w{/ 、 - \ 无　／}.include?(self.sp_s_215.strip)
        pad_sp_bsbs = PadSpBsb.where("sp_s_215 = ? AND sp_s_68 = '流通' AND sp_i_state NOT IN (1,14,16,18) AND sp_s_2 <> '网购'", self.sp_s_215).where(created_at: now.all_quarter)

        sp_bsb_count = SpBsb.where("sp_s_16 NOT IN (?) AND sp_s_215 = ? AND sp_s_68 = '流通' AND sp_i_state NOT IN (0, 1) AND sp_s_2 <> '网购'", pad_sp_bsbs.pluck(:sp_s_16), self.sp_s_215).where(created_at: now.all_quarter).count
    #    if sp_bsb_count + pad_sp_bsbs.count > 10 and PadSpBsb.where(sp_s_16: self.sp_s_16).count == 0
     #     errors.add(:base, '同一被抽样单位，当前季度内，流通环节，最多抽取10批')
      #    return false
      #  end
      end

      # 条件: 2
=begin
      unless %w{/ 、 - \ 无}.include?(self.sp_s_13)
        pad_sp_bsbs = PadSpBsb.where("sp_s_13 = ? AND sp_s_64 = ? AND sp_i_state NOT IN (1,14,16,18) AND sp_s_2 <> '网购'", self.sp_s_13, self.sp_s_64).where(created_at: now.all_quarter)

        sp_bsb_count = SpBsb.where("sp_s_16 NOT IN (?) AND sp_s_13 = ? AND sp_s_64 = ? AND sp_i_state NOT IN (0, 1) AND sp_s_2 <> '网购'", pad_sp_bsbs.pluck(:sp_s_16), self.sp_s_13, self.sp_s_64).where(created_at: now.all_quarter).count
       # end
      end
=end

      # 条件: 3
     # unless %w{/ 、 - \ 无}.include?(self.sp_s_13)
      #  pad_sp_bsbs = PadSpBsb.where("sp_s_14 = ? AND (sp_s_13 = ? AND sp_s_64 = ?) AND sp_d_28 = ? AND sp_i_state not in (1,14,16,18) AND sp_s_2 <> '网购'", self.sp_s_14, self.sp_s_13, self.sp_s_64, self.sp_d_28).where(created_at: now.all_quarter)
       # sp_bsb_count = SpBsb.where("sp_s_16 NOT IN (?) AND sp_s_14 = ? AND (sp_s_13 = ? AND sp_s_64 = ?) AND sp_d_28 = ? AND sp_i_state NOT IN (0, 1) AND sp_s_2 <> '网购'", pad_sp_bsbs.pluck(:sp_s_16), self.sp_s_14, self.sp_s_13, self.sp_s_64, self.sp_d_28).where(created_at: now.all_quarter).count

#        if (sp_bsb_count + pad_sp_bsbs.count > 0) and PadSpBsb.where(sp_s_16: self.sp_s_16).count == 0
 #         errors.add(:base, '同一生产企业，当前季度内, 同一样品名称，同一生产日期，最多抽取1批')
  #        return false
   #     end
    #  end

      # 条件: 3
      unless %w{/ 、 - \ 无　／}.include?(self.sp_s_13)
        pad_sp_bsbs = PadSpBsb.where("sp_s_14 = ? AND sp_s_13 = ? AND sp_d_28 = ? AND sp_i_state not in (1,14,16,18) AND sp_s_2 <> '网购'", self.sp_s_14, self.sp_s_13, self.sp_d_28).where(created_at: now.all_quarter)
        sp_bsb_count = SpBsb.where("sp_s_16 NOT IN (?) AND sp_s_14 = ? AND sp_s_13 = ? AND sp_d_28 = ? AND sp_i_state NOT IN (0, 1) AND sp_s_2 <> '网购'", pad_sp_bsbs.pluck(:sp_s_16), self.sp_s_14, self.sp_s_13, self.sp_d_28).where(created_at: now.all_quarter).count

        #if (sp_bsb_count + pad_sp_bsbs.count > 0) and PadSpBsb.where(sp_s_16: self.sp_s_16).count == 0
         # errors.add(:base, '同一生产企业，当前季度内, 同一样品名称，同一生产日期，最多抽取1批')
       # end
      end

      # --> 条件: 4
     # unless %w{/ 、 - \ 无}.include?(self.sp_s_64)
      #  pad_sp_bsbs = PadSpBsb.where("sp_s_17 = ? AND sp_s_64 = ? AND sp_i_state not in (1,14,16,18) AND sp_s_2 <> '网购'", self.sp_s_17, self.sp_s_64).where(created_at: now.all_quarter)
       # sp_bsb_count = SpBsb.where("sp_s_16 NOT IN (?) AND sp_s_17 = ? AND sp_s_64 = ? AND sp_i_state NOT IN (0, 1) AND sp_s_2 <> '网购'", pad_sp_bsbs.pluck(:sp_s_16), self.sp_s_17, self.sp_s_64).where(created_at: now.all_quarter).count

        #if (sp_bsb_count + pad_sp_bsbs.count > 3) and PadSpBsb.where(sp_s_16: self.sp_s_16).count == 0
         # errors.add(:base, '同一生产企业, 当前季度内, 同一食品大类最多抽取3批')
         # return false
        #end
      #end
      # <-- 条件: 4

      # --> 条件: 4
      unless %w{/ 、 - \ 无　／}.include?(self.sp_s_13)
        pad_sp_bsbs = PadSpBsb.where("sp_s_17 = ? AND sp_s_13 = ? AND sp_i_state not in (1,14,16,18) AND sp_s_2 <> '网购'", self.sp_s_17, self.sp_s_13).where(created_at: now.all_quarter)
        sp_bsb_count = SpBsb.where("sp_s_16 NOT IN (?) AND sp_s_17 = ? AND sp_s_13 = ? AND sp_i_state NOT IN (0, 1) AND sp_s_2 <> '网购'", pad_sp_bsbs.pluck(:sp_s_16), self.sp_s_17, self.sp_s_13).where(created_at: now.all_quarter).count

        #if (sp_bsb_count + pad_sp_bsbs.count > 3) and PadSpBsb.where(sp_s_16: self.sp_s_16).count == 0
         # errors.add(:base, '同一生产企业, 当前季度内, 同一食品大类最多抽取3批')
         # return false
       # end
      end
      # <-- 条件: 4
    end
  end

  def check_benji_company
    if self.sp_s_70.eql?('抽检监测（地方）') and SpProductionInfo.where('benji_only = 1').pluck(:qymc).include?(self.sp_s_64)
      if self.sp_s_reason.blank? and (self.changes[:sp_i_state].present? and [2, 15].include?(self.changes[:sp_i_state][1]))
        self.errors.add(:base, '该大型企业仅限局本级抽检')
        return false
      else
        return true
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

    if self.changes.include?('sp_i_state') and self.sp_i_state == 3
      self.sp_logs.destroy_all
      self.wtyp_czbs.destroy_all
      self.wtyp_czb_parts.destroy_all
    end

    # 生成核查处置信息
    if self.changes.include?('sp_i_state') and ((self.sp_i_state == 9 and self.is_bad_report?) or (self.sp_i_state == 4 and self.bgfl.eql?('24小时限时报告')))
      wtyp_czb = WtypCzb.find_by_wtyp_sp_bsbs_id(self.id)
      if wtyp_czb.nil?
        wtyp_czb = WtypCzb.new
        wtyp_czb.wtyp_sp_bsbs_id = self.id
        wtyp_czb.cjbh = self.sp_s_16
        wtyp_czb.ypmc = self.sp_s_14
        wtyp_czb.ypgg = self.sp_s_26
        wtyp_czb.ypph = self.sp_s_27
        wtyp_czb.bcydwmc = self.sp_s_1
        wtyp_czb.bcydw_sheng = self.sp_s_3
        wtyp_czb.bcydw_shi = self.sp_s_4
        wtyp_czb.bcydw_xian = self.sp_s_5
        wtyp_czb.cydwmc = self.sp_s_35
        wtyp_czb.cydwsf = self.sp_s_52
        wtyp_czb.bsscqymc = self.sp_s_64
        wtyp_czb.bsscqy_sheng = self.sp_s_202
        wtyp_czb.sp_s_220 = self.sp_s_220
        wtyp_czb.sp_s_221 = self.sp_s_221
        wtyp_czb.scrq = self.sp_d_28
        wtyp_czb.bgfl = self.bgfl
        wtyp_czb.jyjl = self.sp_s_71
        wtyp_czb.bgsbh = self.sp_s_45
        wtyp_czb.cydd = self.sp_s_68
        wtyp_czb.bcydwdz = self.sp_s_7
        wtyp_czb.bsscqydz = self.sp_s_65
        wtyp_czb.cyjs = self.sp_s_206
        wtyp_czb.jymd = self.sp_s_44
        wtyp_czb.SPDL = self.sp_s_17
        wtyp_czb.SPYL = self.sp_s_18
        wtyp_czb.SPCYL = self.sp_s_19
        wtyp_czb.SPXL = self.sp_s_20
        # TODO: 要做好事务处理 2015-04-25
        if wtyp_czb.save
          @spdata = []
          self.spdata.each do |data|
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
              hczdata.wtyp_czb_id = wtyp_czb.id
              hczdata.save
            end
          end
        end
      end

      # 生产部分
      # 生产部分核查处置仅包含：生产 & 流通
      if !self.sp_s_68.eql?('餐饮') or (self.sp_s_68.eql?('餐饮') and self.sp_s_63.eql?('预包装'))
        @part_sc = WtypCzbPart.where(wtyp_czb_type: WtypCzbPart::Type::SC, wtyp_czb_id: wtyp_czb.id).first
        if @part_sc.nil?
          @part_sc = WtypCzbPart.new(wtyp_czb_type: WtypCzbPart::Type::SC, wtyp_czb_id: wtyp_czb.id)
          @part_sc.sp_bsb_id = self.id
          @part_sc.cjbh = self.sp_s_16
          @part_sc.ypmc = self.sp_s_14
          @part_sc.ypgg = self.sp_s_26
          @part_sc.ypph = self.sp_s_27
          @part_sc.bcydwmc = self.sp_s_1
          @part_sc.bcydw_sheng = self.sp_s_3
          @part_sc.bcydw_shi = self.sp_s_4
          @part_sc.bcydw_xian = self.sp_s_5
          @part_sc.cydwmc = self.sp_s_35
          @part_sc.cydwsf = self.sp_s_52
          @part_sc.bsscqymc = self.sp_s_64
          @part_sc.bsscqy_sheng = self.sp_s_202
          @part_sc.sp_s_220 = self.sp_s_220
          @part_sc.sp_s_221 = self.sp_s_221
          @part_sc.scrq = self.sp_d_28
          @part_sc.bgfl = self.bgfl
          @part_sc.jyjl = self.sp_s_71
          @part_sc.bgsbh = self.sp_s_45
          @part_sc.cydd = self.sp_s_68
          @part_sc.bcydwdz = self.sp_s_7
          @part_sc.bsscqydz = self.sp_s_65
          @part_sc.current_state = 0
          @part_sc.cyjs = self.sp_s_206
          @part_sc.jymd = self.sp_s_44
          @part_sc.jymd = self.sp_s_44
          @part_sc.SPDL = self.sp_s_17
          @part_sc.SPYL = self.sp_s_18
          @part_sc.SPCYL = self.sp_s_19
          @part_sc.SPXL = self.sp_s_20
          @part_sc.save
        end
      end

      # [流通/餐饮]部分
      if self.sp_s_68.eql?('流通')
        @lt_cy_type = WtypCzbPart::Type::LT
      elsif self.sp_s_68.eql?('餐饮')
        @lt_cy_type = WtypCzbPart::Type::CY
      end

      @part_lt_cy = WtypCzbPart.where(wtyp_czb_type: @lt_cy_type, wtyp_czb_id: wtyp_czb.id).first
      # #47 第10条，如果抽样环节是生产，则只处理生产，不处理流通
      if @part_lt_cy.nil? and !self.sp_s_68.eql?('生产')
        @part_lt_cy = WtypCzbPart.new(wtyp_czb_type: @lt_cy_type, wtyp_czb_id: wtyp_czb.id)
        @part_lt_cy.sp_bsb_id = self.id
        @part_lt_cy.cjbh = self.sp_s_16
        @part_lt_cy.ypmc = self.sp_s_14
        @part_lt_cy.ypgg = self.sp_s_26
        @part_lt_cy.ypph = self.sp_s_27
        @part_lt_cy.bcydwmc = self.sp_s_1
        @part_lt_cy.bcydw_sheng = self.sp_s_3
        @part_lt_cy.bcydw_shi = self.sp_s_4
        @part_lt_cy.bcydw_xian = self.sp_s_5
        @part_lt_cy.cydwmc = self.sp_s_35
        @part_lt_cy.cydwsf = self.sp_s_52
        @part_lt_cy.bsscqymc = self.sp_s_64
        @part_lt_cy.bsscqy_sheng = self.sp_s_202
        @part_lt_cy.sp_s_220 = self.sp_s_220
        @part_lt_cy.sp_s_221 = self.sp_s_221
        @part_lt_cy.scrq = self.sp_d_28
        @part_lt_cy.bgfl = self.bgfl
        @part_lt_cy.jyjl = self.sp_s_71
        @part_lt_cy.bgsbh = self.sp_s_45
        @part_lt_cy.cydd = self.sp_s_68
        @part_lt_cy.bcydwdz = self.sp_s_7
        @part_lt_cy.bsscqydz = self.sp_s_65
        @part_lt_cy.cyjs = self.sp_s_206
        @part_lt_cy.jymd = self.sp_s_44
        @part_lt_cy.current_state = 0
        @part_lt_cy.SPDL = self.sp_s_17
        @part_lt_cy.SPYL = self.sp_s_18
        @part_lt_cy.SPCYL = self.sp_s_19
        @part_lt_cy.SPXL = self.sp_s_20
        @part_lt_cy.save
      end
    end
  end
  # 生成检验报告
  def generate_bsb_report_pdf(pdf_rules, preview=true, user_id=nil, force_generate=false)
   
    if force_generate or preview  or (self.report_path.blank? and self.ca_key_status ==0) or !File.exists?(self.absolute_report_path)
      @jg_bsb = JgBsb.find_by_jg_name(self.sp_s_43)
      @jyxm_str = Spdatum.where('sp_bsb_id= ? and (spdata_2 = ? or spdata_2 = ?)', self.id, '合格项', '不合格项').limit(3).map { |s| s.spdata_0 }.join(",") + "等#{Spdatum.where("sp_bsb_id= ? and (spdata_2 = ? or spdata_2 = ?)", self.id, '合格项', '不合格项').count}项。"
     logger.error @jyxm_str      
@jyjy_str = Spdatum.where('sp_bsb_id= ? and spdata_4 <> ?', self.id, '/').limit(2).map { |s| s.spdata_3 }.join(",")
      @jyjy_str4 = Spdatum.where('sp_bsb_id= ? and spdata_4 <> ?', self.id, '/').limit(2).map { |s| s.spdata_4 }.join(",")
      @jyjy_str1 = Spdatum.where('sp_bsb_id = ? and (spdata_4 = ? OR spdata_4 = ?)', self.id, '/', '-').map { |s| s.spdata_3 }.uniq.join(",")
      @splog = SpLog.where('sp_bsb_id = ? AND (sp_i_state = ? or sp_i_state =?)', self.id, '2','4').last
      #抽检项
      @cjx = Spdatum.where("sp_bsb_id = ? AND (spdata_2 LIKE '%合格项%' OR spdata_2 LIKE '%不合格项%')", self.id)
     logger.error @cjx
      @jyjy_struni = (@cjx.where('sp_bsb_id= ? and spdata_4 <> ?', self.id, '/').select('distinct spdata_4').limit(2).map { |s| s.spdata_4 }).uniq.join(",")
      @jyjy_FY = self.inspection_basis
      #风险项
      @fxx = Spdatum.where("sp_bsb_id = ? AND (spdata_2 LIKE '%不判定项%' OR spdata_2 LIKE '%问题项%')", self.id)
      @fxx_FY = (@fxx.where('sp_bsb_id= ?', self.id).select('distinct spdata_3').map { |s| s.spdata_3 }).uniq.join(';')

      #问题项
      @wtx = Spdatum.where('sp_bsb_id = ? AND spdata_2 LIKE ?', self.id, '%不合格%')
      @jyyj_hgx_str4 = '经抽样检验，所检项目符合' + Spdatum.where('sp_bsb_id= ? and spdata_4 <> ? and spdata_2 like ?', self.id, '/', '%合格项%').map { |s| s.spdata_4 }.uniq.join(',')+'要求。'

      #问题项字符串
      @wtx_str = Spdatum.where('sp_bsb_id = ? AND spdata_2 LIKE ?', self.id, '%问题%').map { |s| s.spdata_0 }.join(',')
      #检查封样人员      @padsplog_jcfy = PadSpLogs.where('sp_s_16 = ? AND remark = ?', self.sp_s_16, '接收样品').last

      @padsplog_jcfy = PadSpLogs.where('sp_s_16 = ? AND remark = ?', self.sp_s_16, '接收样品').last
     # @splog_jcfy = SpLog.with_deleted.where('sp_bsb_id = ? AND sp_i_state = ?', self.id, 2).first
      @splog_jcfy = SpLog.where('sp_bsb_id = ? AND sp_i_state = ?', self.id, 2).first
      @jcfy = '/'

      if !@splog_jcfy.nil?
        @jcfy = User.where('id = ?', @splog_jcfy.user_id).last.tname
      end

      if !@padsplog_jcfy.nil?
        u = User.where('id = ?', @padsplog_jcfy.user_id).last
        if !u.nil?
          @jcfy = u.tname
        end
      end
			tmp_file = Rails.root.join('tmp', "sp_bsbs_#{self.id}_print.pdf")
			if pdf_rules =='ca_file'
			 tmp_file = Rails.root.join('tmp/pdf_preview', "sp_bsbs_#{self.id}_print.pdf")
			end
      ApplicationController.new.render template: 'sp_bsbs/old.1.html.erb',
                                       save_to_file: tmp_file,
                                       save_only: true,
                                       pdf: 'home',
                                       wkhtmltopdf: '/usr/local/bin/wkhtmltopdf',
                                       encoding: 'utf-8',
                                       disable_javascript: true,
                                       print_media_type: true,
                                       lowquality: false,
                                       locals: {:@spbsb => self, :@splog_jcfy => @splog_jcfy, :@jcfy => @jcfy, :@padsplog_jcfy => @padsplog_jcfy, :@fxx => @fxx, :@fxx_FY => @fxx_FY, :@wtx => @wtx, :@jyyj_hgx_str4 => @jyyj_hgx_str4, :@wtx_str => @wtx_str, :@jyjy_FY => @jyjy_FY, :@splog => @splog, :@cjx => @cjx, :@jyjy_struni => @jyjy_struni, :@jg_bsb => @jg_bsb, :@jyxm_str => @jyxm_str, :@jyjy_str => @jyjy_str, :@jyjy_str4 => @jyjy_str4, :@jyjy_str1 => @jyjy_str1}

      target_path = "#{Time.now.strftime('/%Y/%m/%d')}"

      if preview and !force_generate
        abs_target_path = Rails.root.join('tmp', 'report_preview').to_s + target_path
        # if pdf_rules.blank?
        #   return tmp_file
        # end
      	logger.error "这应该是打印的"
	logger.error abs_target_path
	else
        abs_target_path = File.expand_path('../reports', Rails.root).to_s + target_path
      	logger.error "这应该是浏览的"
        logger.error abs_target_path
	end

      if pdf_rules.blank?
         if !self.sp_s_69.blank?
            pdf_rules =self.sp_s_69 
         else
           if @jg_bsb.jg_bsb_stamps.count > 0
             pdf_rules = @jg_bsb.jg_bsb_stamps.pluck(:stamp_no).join(',')
           else
	            Rails.logger.error '机构未进行数字签名认证，无法查看报告'
              self.report_path = "#{target_path}/#{self.id}.pdf"
		           if preview and !force_generate 
                  return tmp_file
               end
                 return nil
            end
	        end
			else
				if pdf_rules =='ca_file'
					return tmp_file
				end
				if preview and force_generate
						tmp_file = Rails.root.join('tmp/pdf_preview', "sp_bsbs_#{self.id}_print.pdf")
				end
      end

      FileUtils.mkdir_p abs_target_path unless Dir.exists? abs_target_path

      self.report_path = "#{target_path}/#{self.id}.pdf"
      # create stamp record
      userinfo = {userName: '吉林省食品药品监督局', channelId: 'CHN_3039394B3D71D6FD', creditCodes: {ORG: '092648364'}}
      documentInfo = {docuName: '云签章', fileDesc: '云签章'}
      content = []
      pdf_rules.split(',').each do |rule|
        content.push({ruleNum: rule, appId: '9ff70fce51874b62a5f136fdda43c4b7', userinfo: userinfo, documentInfo: documentInfo})
      end
      # logger.error content.to_json
			logger.error content
      content = Base64.strict_encode64(content.to_json)
      cmd = "java -jar #{Rails.root.join('bin', 'mssg-pdf-client-1.1.0.jar')} 111.26.194.57 8081 105 #{content} #{tmp_file} #{self.absolute_report_path(preview && !force_generate)}"
      logger.error cmd

      result = `#{cmd}`

  logger.error "result"

  logger.error result
    logger.error tmp_file
    logger.error self.absolute_report_path(preview && !force_generate)
      #cmd = "/usr/local/java-ppc64-80/jre/bin/java -jar #{Rails.root.join('bin', 'esspdf-client.jar')} #{Rails.application.config.site[:ca_pdf_address]} 8888 1 #{pdf_rules.split(',').join('#')} #{tmp_file} #{self.absolute_report_path(preview && !force_generate)}"
      Rails.logger.error cmd
      # cmd = "java -jar #{Rails.root.join('bin', 'mssg-pdf-client-1.0.0-SNAPSHOT-client.jar')} 172.16.88.126 80 105 #{content} #{tmp_file} #{@spbsb.absolute_report_path}"
      # logger.error cmd
      #
      # result = `#{cmd}`
      Rails.logger.error result

      FileUtils.rm_f(tmp_file)

      if result.strip.include?('200')
        if !preview or force_generate
          SpBsb.record_timestamps = false
          self.save
          SpBsb.record_timestamps = true
        end
        return self.absolute_report_path(preview && !force_generate)
      else
        self.report_path = nil
        return nil
      end

    else
      self.absolute_report_path
    end
  end

	def generate_ca_pdf_report(ca_filepath,new_ca_filepath,ruleNumList,signData,signCert,nonce)
	    tmp_file = ca_filepath
	    logger.error tmp_file 
	    #preview_file = "Rails.root.join('tmp/pdf_preview', "sp_bsbs_#{self.id}_print_preview.pdf")"
	   # preview_file= Rails.root.join('tmp/pdf_preview', "preview_sp_bsbs_#{self.id}_print.pdf")
	    #preview_file= File.expand_path('../reports', Rails.root).to_s+"preview_sp_bsbs_#{self.id}_print.pdf"
	    userinfo = {channelId: 'CHN_3039394B3D71D6FD'}
            documentInfo = {docuName: '云签章', fileDesc: '云签章'}
             #ruleNumList = []
            # pdf_rules.split(',').each do |rule|
	     #ruleNumList.push(rule)
           # end
	   reqMessage ={ruleNumList: ruleNumList, appId: '9ff70fce51874b62a5f136fdda43c4b7',policyType: 2, userinfo: userinfo, documentInfo: documentInfo,nonce: nonce, signCert: signCert,signData: signData}
      logger.error reqMessage
	   content = Base64.strict_encode64(reqMessage.to_json)
      cmd = "java -jar #{Rails.root.join('bin', 'mssg-pdf-client.jar')} 111.26.194.57 8081 114 #{content} #{tmp_file} #{new_ca_filepath}"
      result = `#{cmd}`
    logger.error result
      if result.strip.include?('200')
	return new_ca_filepath
      else
		return nil
	end
	end
    def client_sign_ca(pdfpath,sign_data,sealImg,signCert,filename)
    if [2, 3].include? self.sp_i_state
      keyword = '检验人：'
    elsif self.sp_i_state == 4
      keyword = '审核人：'
    elsif self.sp_i_state == 5
      keyword = '批准人：'
    end
     _QFRQ_keyword_ = '签发日期：'
     sign_date_result = (self.sp_i_state == 5 and sign_data.to_i == 1)
      if sign_date_result  #and self.sign_date.blank?
        self.update_attributes(sign_date: Time.now)
          sealImg = Time.new.strftime("%Y-%m-%d")
          keyword= '签发日期：'
      end
    clientSignMessages=[]
    clientSignMessage ={ruleType: 1,keyword: keyword,searchOrder: '2',fileUniqueId: '111111111111',heightMoveSize: 0,moveSize: 0,moveType: 3,searchOrder: 2}
    clientSignMessages.push(clientSignMessage)
    reqMessage ={appId: '9ff70fce51874b62a5f136fdda43c4b7',sealImg: sealImg, signCert: signCert,
                 sealWidth: 0,sealHeight: 0, clientSignMessages: clientSignMessages}
    logger.error reqMessage
    reqMessage = Base64.strict_encode64(reqMessage.to_json)
    #filename = Rails.root.join('tmp', "sp_bsbs_#{self.id}.txt")
    cmd = "java -jar #{Rails.root.join('bin', 'mssg-pdf-client-1.1.0.jar')}  111.26.194.57 8081 108  #{reqMessage} #{pdfpath} #{filename}"
    signSeal_result = `#{cmd}`
	logger.error signSeal_result
     return signSeal_result
  end

  def generate_report_context(report_type)
    jg_bsb = JgBsb.find_by_jg_name(self.sp_s_43)

    context = {sp_bsb: self.as_json, spdata: [], jg_bsb: jg_bsb.as_json, jg_bsb_obj: jg_bsb}
    context[:splog] = SpLog.where('sp_bsb_id = ? AND remark = ?', self.id, '检测机构批准').last
    context[:jyjy_str] = Spdatum.where('sp_bsb_id= ? and spdata_4 <> ?', self.id, '/').limit(2).map { |s| s.spdata_3 }.join(",")
    context[:jyjy_str4] = Spdatum.where('sp_bsb_id= ? and spdata_4 <> ?', self.id, '/').limit(2).map { |s| s.spdata_4 }.join(",")
    context[:jyjy_str1] = Spdatum.where('sp_bsb_id = ? and (spdata_4 = ? OR spdata_4 = ?)', self.id, '/', '-').map { |s| s.spdata_3 }.uniq.join(",")
    #批准人
    #logfive = SpLog.with_deleted.where(sp_bsb_id: self.id, sp_i_state: 5).order('id asc').last
=begin
    logfive = SpLog.where(sp_bsb_id: self.id, sp_i_state: 5).order('id asc').last
    if logfive.nil?
      #context[:sp_bsb][:pzr] = '未记录@1'
     else
      log = SpLog.where('sp_bsb_id = ? and sp_i_state = ? and id > ?', self.id, 16, logfive.id).order('id asc').first
      if log.nil?
        log = SpLog..where(sp_bsb_id: self.id, sp_i_state: 8).order('sp_i_state asc').last
      end
      unless log.nil?
        user = User.find(log.user_id)
   	 #context[:sp_bsb][:pzr] = @user.tname
      else
          #context[:sp_bsb][:pzr] = '未记录@2'
      end
    end
         #审核人检验人
      log = SpLog.where(sp_bsb_id: self.id, sp_i_state: 5).last
    unless log.nil?
      user = User.find(log.user_id)
     #context[:sp_bsb][:shr] = @user.tname
     else
      #context[:sp_bsb][:shr] = '未记录'
     end
      log = SpLog.where(sp_bsb_id: self.id, sp_i_state: 4).last
    unless log.nil?
      user = User.find(log.user_id)
      #context[:sp_bsb][:jyr] = @user.tname
    else
      #context[:sp_bsb][:jyr] = '未记录'
    end
=end
    if report_type.eql?('JYBG')
      context[:padsplog_jcfy] = PadSpLogs.where('sp_s_16 = ? AND remark = ?', self.sp_s_16, '接收样品').last
      context[:splog_jcfy] = SpLog.where('sp_bsb_id = ? AND sp_i_state = ?', self.id, 2).first
      context[:sp_bsb][:jcfy] = '/'
      if !context[:splog_jcfy].nil?
        context[:sp_bsb][:jcfy] = User.where('id = ?', context[:splog_jcfy].user_id).last.tname
      end
      if !context[:padsplog_jcfy].nil?
        u = User.where('id = ?', context[:padsplog_jcfy].user_id).last
        if !u.nil?
          context[:sp_bsb][:jcfy] = u.tname
        end
      end
       context[:sp_bsb][:jyyj_summary] = Spdatum.where("sp_bsb_id = ? AND (spdata_2 LIKE '%合格项%' OR spdata_2 LIKE '%不合格项%')", self.id).where('sp_bsb_id= ? and spdata_4 <> ?', self.id, '/').select('distinct spdata_4').limit(2).map { |s| s.spdata_4 }.uniq.join(',')
       context[:wtx] = Spdatum.where('sp_bsb_id = ? AND spdata_2 LIKE ?', self.id, '%不合格%')
      if context[:wtx].blank?
        context[:sp_bsb][:jyjl] = '经抽样检验，所检项目符合' + Spdatum.where('sp_bsb_id= ? and spdata_4 <> ? and spdata_2 like ?', self.id, '/', '%合格项%').map { |s| s.spdata_4 }.uniq.join(',')+'要求。'
      else
        context[:sp_bsb][:jyjl] = '经抽样检验，'
        context[:wtx].each do |wtx|
          context[:sp_bsb][:jyjl] += (wtx.spdata_0 + '项目不符合' + wtx.spdata_4 + '要求，')
        end
        context[:sp_bsb][:jyjl] += '检验结论为不合格。'
      end

      if self.sp_s_84.blank?
        context[:sp_bsb][:note] = '无'
      else
        context[:sp_bsb][:note] = self.sp_s_84
      end
     #抽检项
       context[:cjx] = Spdatum.where("sp_bsb_id = ? AND (spdata_2 LIKE '%合格项%' OR spdata_2 LIKE '%不合格项%')", self.id)
      context[:jyjy_struni] = (context[:cjx].where('sp_bsb_id= ? and spdata_4 <> ?', self.id, '/').select('distinct spdata_4').limit(2).map { |s| s.spdata_4 }).uniq.join(",")
      context[:cjx].each_with_index do |item, index|
        datum = {index: index + 1, JYXM: item.spdata_0, BZZB: '', SCZ: nil, DXPD: item.spdata_2.delete('项'), BZ: nil}
        # 处理检验项目
       unless %w{- / \ }.include?(item.spdata_18)
          datum[:JYXM] += ", #{item.spdata_18}"
        end

        # 处理标准指标
	if %w{0 0.0}.include?(item.spdata_11) and %w{0 0.0}.include?(item.spdata_15)
          datum[:BZZB] += '不得检出'
        elsif %w{- — / \_0 0.0}.include?(item.spdata_11)
          if %w{0 1 2 3 4 5 6 7 8 9}.include?(item.spdata_15[0, 1])
            datum[:BZZB] += '≤'
          end
          datum[:BZZB] += item.spdata_15
        elsif %w{- — / \_}.include?(item.spdata_15)
          datum[:BZZB] += '≥'
          datum[:BZZB] += item.spdata_11
        else
          datum[:BZZB] += item.spdata_11
          datum[:BZZB] += '～'
          datum[:BZZB] += item.spdata_15
        end

         # 处理实测值
        datum[:SCZ] = item.spdata_1
        if item.spdata_1.eql?('未检出')
          unless %w{- /}.include? item.spdata_7
            datum[:SCZ] += "(检出限: #{item.spdata_7} #{item.spdata_8})"
          end
        end

        # 处理备注
        if item.spdata_17.present?
          datum[:BZ] = item.spdata_17
        else
          datum[:BZ] = '/'
        end
        context[:spdata].push(datum)
      end
       #附页内容
      context[:FY] = (context[:cjx].where("sp_bsb_id= ? and spdata_3 not in ('-','—', '/', '_')", self.id).select('distinct spdata_3').map { |s| s.spdata_3 }).uniq.join(';')
      context[:sp_bsb][:jyxm] = Spdatum.where('sp_bsb_id= ? and (spdata_2 = ? or spdata_2 = ?)', self.id, '合格项', '不合格项').limit(3).map { |s| s.spdata_0 }.join(',') + "等#{Spdatum.where('sp_bsb_id= ? and (spdata_2 = ? or spdata_2 = ?)', self.id, '合格项', '不合格项').count}项。"
    elsif report_type.eql?('FXBG')
      if self.sp_d_28.blank?
        context[:sp_bsb][:sp_d_28] = '/'
      end
      #风险项
     context[:fxx] = Spdatum.where("sp_bsb_id = ? AND (spdata_2 LIKE '%不判定项%' OR spdata_2 LIKE '%问题项%')", self.id)

      # 检验结论
      context[:sp_bsb][:jyyj] = (context[:fxx].where('sp_bsb_id= ?', self.id).select('distinct spdata_3').map { |s| s.spdata_3 }).uniq.join(';')

      # 样品数量
     if self.sp_n_15.to_s[self.sp_n_15.to_s.length - 2, self.sp_n_15.to_s.length - 1]=='.0'
        context[:sp_bsb][:ypsl] = self.sp_n_15.to_s.chop.chop
      else
        context[:sp_bsb][:ypsl] = self.sp_n_15.to_s
      end
      context[:sp_bsb][:ypsl] += self.sp_s_6

      # 问题项目
    context[:sp_bsb][:wtxm] = Spdatum.where('sp_bsb_id = ? AND spdata_2 LIKE ?', self.id, '%问题%').map { |s| s.spdata_0 }.join(',')
      if context[:sp_bsb][:wtxm].blank?
        context[:sp_bsb][:wtxm] = '/'
      end

      context[:fxx].each_with_index do |item, index|
        datum = {index: index + 1, XMMC: item.spdata_0, DW: item.spdata_18, CKZ: '', JCSJ: ''}
        if "-,/\\".include? item.spdata_11 and "-,/\\".include? item.spdata_15
          datum[:CKZ] += '/'
        elsif "-,/\\".include? item.spdata_11
          if %w{0 1 2 3 4 5 6 7 8 9}.include?(item.spdata_15[0, 1])
            datum[:CKZ] += '≤'
          end
          datum[:CKZ] += item.spdata_15
        elsif "-,/,\\".include? item.spdata_15
          if %w{0 1 2 3 4 5 6 7 8 9}.include?(item.spdata_15[0, 1])
            datum[:CKZ] += '≥'
          end
          datum[:CKZ] += item.spdata_11
        else
          datum[:CKZ] += item.spdata_11
          datum[:CKZ] += '~'
          datum[:CKZ] += item.spdata_15
        end

        # 检测数据
          datum[:JCSJ] = item.spdata_1
        if item.spdata_1.eql?('未检出')
          unless %w{- /}.include? item.spdata_7
            datum[:JCSJ] += "(检出限: #{item.spdata_7} #{item.spdata_8})"
          end
        end

        context[:spdata].push(datum)
      end
    else
      return nil
    end
	return context
  end
 
  def generate_pdf_report(report_type)
	context = generate_report_context(report_type)
	if report_type.eql?('JYBG')
         template = 'sp_bsbs/1.html.erb'
   	 f_name = 'JYBG'	
	elsif report_type.eql?('FXBG')
         template = 'sp_bsbs/2.html.erb'
         f_name = 'FXBG'
	end
	now = Time.now
	outpath_folder = "#{Rails.application.config.attachment_path}"
	FileUtils.mkdir_p(outpath_folder) unless File.directory?(outpath_folder)
	outpath = "#{outpath_folder}/#{self.sp_s_16}-#{f_name}.pdf"
	ApplicationController.new.render template: template,
		              save_to_file: outpath,
			      save_only: true,
			      pdf: 'home',
          	              wkhtmltopdf: '/usr/local/bin/wkhtmltopdf',
		              encoding: 'utf-8',
			      disable_javascript: true,
			      print_media_type: true,
		              lowquality: false,
			      locals: {
				    :@spbsb => self, 
			            :@splog_jcfy => context[:splog_jcfy],
	                            :@jcfy => context[:sp_bsb][:jcfy], 
				    :@padsplog_jcfy => context[:padsplog_jcfy], 
			            :@fxx => context[:fxx], 
				    :@fxx_FY => context[:sp_bsb][:jyyj], 
			            :@wtx => context[:wtx], 
				    :@jyyj_hgx_str4 => context[:sp_bsb][:jyjl], 
	                            :@wtx_str => context[:sp_bsb][:wtxm], 
			            :@jyjy_FY => context[:FY], 
				    :@splog => context[:splog], 
				    :@cjx => context[:cjx], 
			            :@jyjy_struni => context[:jyjy_struni],#  不知何值
				    :@jg_bsb => context[:jg_bsb_obj], 
				    :@jyxm_str => context[:sp_bsb][:jyxm], 
				    :@jyjy_str => context[:jyjy_str], 
			            :@jyjy_str4 => context[:jyjy_str4], 
				    :@jyjy_str1 => context[:jyjy_str1]
				   }
	logger.error ":@fxx"
	logger.error context[:wtx]
      return "#{self.sp_s_16}-#{f_name}.pdf", "#{self.sp_s_16}-#{f_name}.pdf"
  end
end
