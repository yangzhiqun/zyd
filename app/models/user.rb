#encoding: utf-8
require 'digest/sha1'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include ApplicationHelper

  validates_presence_of :function_type, message: '请设置用户职能'

  validates_presence_of :jg_bsb_id, message: '所在机构不可为空'

  validates_uniqueness_of :uid, allow_blank: true
  validates_presence_of :uid, allow_blank: true

  # validates_presence_of :name, message: '姓名不可为空'
  validates_presence_of :user_s_province, message: '省份不可为空'
 # validates_exclusion_of :jg_type,  :in => [0] ,  :message  => '请选择机构类型'
  validates_uniqueness_of :id_card, message: "该身份证号已绑定", allow_nil: true, allow_blank: true
  #validates_format_of :id_card, with: /(^\d{15}$)|(^\d{17}([0-9]|X)$)/i, message: '身份证格式不正确', allow_blank: true, allow_nil: true
  validates_format_of :mobile, with: /(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}/i, message: '手机号格式不正确', allow_nil: true
  validates_uniqueness_of :user_sign, message: "签名已存在", allow_nil: true, allow_blank: true
  validates_confirmation_of :password
  # validate :password_non_blank

  #before_save :generate_uid
  before_create :config_user_state
  after_create :cleanup_after_create

  has_many :user_audit_logs

  def is_info_complete?
    !tname.blank?
  end

  def is_signup_sms_code_available?
    sms_log = SmsLog.where(used_at: nil, sms_type: 'signup', msg: self.sms_code, mobile: self.mobile).last
    if sms_log.present? and Time.now - sms_log.created_at < 5.minutes
      return true
    end
    self.errors.add(:sms_code, '验证码无效或过期')
    false
  end

  module State
    ReviewJG = 0
    Blocked = 1
    ReviewSJ = 3
    Rejected = 4
    InUse = 9
  end

  attr_accessor :password_confirmation, :sms_code

  # TODO: finish me.
  def function=(fs)
    # 为用户各权限赋值
    self.user_i_sp = 1
    fs.each do |f|
      case f.to_i
        when 1
          self.rwbs = 1
        when 2
          self.rwxd = 1
        when 3
          self.zxcy = 1
        when 4
          self.jsyp = 1
          self.user_d_authority = 1
        when 5
          self.user_d_authority_1 = 1
        when 6
          self.user_d_authority_2 = 1
        when 7
          self.user_d_authority_5 = 1
        when 8
          self.user_i_js = 1
          self.user_d_authority_5 = 1
        when 9
          self.user_i_switch = 1
          self.user_d_authority_5 = 1
        when 10
          self.hcz_czap = 1
        when 11
          self.hcz_czbl = 1
        when 12
          self.hcz_czsh = 1
        when 13
          self.yysl = 1
        when 14
          self.yybl = 1
        when 15
          self.yysh = 1
       when 16
         self.jbxx_sh=1
      end
    end

    self.function_type = fs.join(',')
  end

  def function
    self.function_type.split(',')
  end

  belongs_to :jg_bsb

  # 异议处置权限
  module YyczPermission
    # 异议受理
    YYSL = 0x0000000000001
    # 综合协调
    ZHXT = 0x0000000000010
    # 异议办理
    YYBL = 0x0000000000100
    # 异议审核
    YYSH = 0x0000000001000
    # 管理
    GL = 0x0000000010000
  end

  def func_type_desc
    FuncType.invert[self.function_type]
  end

  FuncType = {
      '任务部署' => 1,
      '任务下达' => 2,
      '抽样人员' => 3,
      '接样人员' => 4,
      '机构主检人' => 5,
      '机构审核人' => 6,
      '机构批准人' => 7,
      '省局审核人' => 8,
      # '牵头机构审核人' => 9,
     # '核查处置安排人' => 10,
      '核查处置领取人' => 11,
      '核查处置审核人' => 12,
      '异议登记' => 13,
      '异议办理' => 14,
      '异议审核' => 15,
     '报告发送人'=> 16
  }

  # 后处置权限
  module HczPermission
    # 工作安排
    CZAP = 0x0000000000001
    # 处置办理
    CZBL = 0x0000000000010
    # 处置审核
    CZSH = 0x0000000000100
    # 生产
    SC = 0x0000000001000
    # 流通
    LT = 0x0000000010000
    # 管理
    GL = 0x0000000100000
  end

  module PadPermission
    # 任务部署
    RWBS = 0x0000000000001
    # 任务下达
    RWXD = 0x0000000000010
    # 执行采样
    ZXCY = 0x0000000000100
    # 接收样品
    JSYP = 0x0000000001000
  end

  module PublicationPermission
    # 信息发布人员
    XXFB = 0x0000000000001
    # 信息发布审核人员
    XXFBSH = 0x0000000000010
  end

  module HcczType
    SC = 1
    CY = 2
  end

  module HcczLevel
    Sheng = 1
    Shi = 2
    Xian = 3
  end
  # 信息发布审核人员
  def pub_xxfb_sh
    ((self.publication_permission || 0) & PublicationPermission::XXFBSH > 0) ? 1 : 0
  end

  # 信息发布审核人员=
  def pub_xxfb_sh=(v)
    if v.to_i == 1
      self.publication_permission |= PublicationPermission::XXFBSH
    else
      self.publication_permission &= ~PublicationPermission::XXFBSH
    end
  end

  # 信息发布人员
  def pub_xxfb
    ((self.publication_permission || 0) & PublicationPermission::XXFB > 0) ? 1 : 0
  end

  # 信息发布人员=
  def pub_xxfb=(v)
    if v.to_i == 1
      self.publication_permission |= PublicationPermission::XXFB
    else
      self.publication_permission &= ~PublicationPermission::XXFB
    end
  end

  # 接收样品
  def jsyp
    ((self.pad_permission || 0) & PadPermission::JSYP > 0) ? 1 : 0
  end

  # 接收样品=
  def jsyp=(v)
    if v.to_i == 1
      self.pad_permission |= PadPermission::JSYP
    else
      self.pad_permission &= ~PadPermission::JSYP
    end
  end

  # 执行采样
  def zxcy
    ((self.pad_permission || 0) & PadPermission::ZXCY > 0) ? 1 : 0
  end

  # 执行采样=
  def zxcy=(v)
    if v.to_i == 1
      self.pad_permission |= PadPermission::ZXCY
    else
      self.pad_permission &= ~PadPermission::ZXCY
    end
  end

  # 任务部署
  def rwbs
    ((self.pad_permission || 0) & PadPermission::RWBS > 0) ? 1 : 0
  end

  # 任务部署=
  def rwbs=(v)
    if v.to_i == 1
      self.pad_permission |= PadPermission::RWBS
    else
      self.pad_permission &= ~PadPermission::RWBS
    end
  end

  # 任务下达
  def rwxd
    ((self.pad_permission || 0) & PadPermission::RWXD > 0) ? 1 : 0
  end

  # 任务下达=
  def rwxd=(v)
    if v.to_i == 1
      self.pad_permission |= PadPermission::RWXD
    else
      self.pad_permission &= ~PadPermission::RWXD
    end
  end

  # 异议受理
  def yysl=(v)
    if v.to_i == 1
      self.yycz_permission |= YyczPermission::YYSL
    else
      self.yycz_permission &= ~YyczPermission::YYSL
    end
  end

  # 异议管理员
  def yyadmin=(v)
    if v.to_i == 1
      self.yycz_permission |= YyczPermission::GL
    else
      self.yycz_permission &= ~YyczPermission::GL
    end
  end

  # 异议综合协调
  def zhxt=(v)
    if v.to_i == 1
      self.yycz_permission |= YyczPermission::ZHXT
    else
      self.yycz_permission &= ~YyczPermission::ZHXT
    end
  end

  # 异议办理
  def yybl=(v)
    if v.to_i == 1
      self.yycz_permission |= YyczPermission::YYBL
    else
      self.yycz_permission &= ~YyczPermission::YYBL
    end
  end

  # 异议审核
  def yysh=(v)
    if v.to_i == 1
      self.yycz_permission |= YyczPermission::YYSH
    else
      self.yycz_permission &= ~YyczPermission::YYSH
    end
  end

  # 异议 管理员
  def yyadmin
    ((self.yycz_permission || 0) & YyczPermission::GL > 0) ? 1 : 0
  end

  # 异议受理
  def yysl
    ((self.yycz_permission || 0) & YyczPermission::YYSL > 0) ? 1 : 0
  end

  # 综合协调 
  def zhxt
    ((self.yycz_permission || 0) & YyczPermission::ZHXT > 0) ? 1 : 0
  end

  # 异议办理
  def yybl
    ((self.yycz_permission || 0) & YyczPermission::YYBL > 0) ? 1 : 0
  end

  # 异议审核
  def yysh
    ((self.yycz_permission || 0) & YyczPermission::YYSH > 0) ? 1 : 0
  end

  # 后处理 处置安排
  def hcz_czap
    (self.hcz_permission & HczPermission::CZAP > 0) ? 1 : 0
  end

  # 后处理 处置安排
  def hcz_czap=(v)
    if v.to_i == 1
      self.hcz_permission |= HczPermission::CZAP
    else
      self.hcz_permission &= ~HczPermission::CZAP
    end
  end

  # 后处理 处置办理
  def hcz_czbl
    (self.hcz_permission & HczPermission::CZBL > 0) ? 1 : 0
  end

  # 后处理 处置办理
  def hcz_czbl=(v)
    if v.to_i == 1
      self.hcz_permission |= HczPermission::CZAP
      self.hcz_permission |= HczPermission::CZBL
    else
      self.hcz_permission &= ~HczPermission::CZAP
      self.hcz_permission &= ~HczPermission::CZBL
    end
  end

  # 后处理 管理权限
  def hcz_admin
    (self.hcz_permission & HczPermission::GL > 0) ? 1 : 0
  end

  # 后处理 管理权限
  def hcz_admin=(v)
    if v.to_i == 1
      self.hcz_permission |= HczPermission::GL
    else
      self.hcz_permission &= ~HczPermission::GL
    end
  end

  # 后处理 处置审核
  def hcz_czsh
    (self.hcz_permission & HczPermission::CZSH > 0) ? 1 : 0
  end

  # 后处理 处置审核
  def hcz_czsh=(v)
    if v.to_i == 1
      self.hcz_permission |= HczPermission::CZSH
    else
      self.hcz_permission &= ~HczPermission::CZSH
    end
  end

  # 后处理 生产
  def hcz_sc
    (self.hcz_permission & HczPermission::SC > 0) ? 1 : 0
  end

  # 后处理 生产
  def hcz_sc=(v)
    if v.to_i == 1
      self.hcz_permission |= HczPermission::SC
    else
      self.hcz_permission &= ~HczPermission::SC
    end
  end

  # 后处理 流通
  def hcz_lt
    (self.hcz_permission & HczPermission::LT > 0) ? 1 : 0
  end

  # 后处理 流通
  def hcz_lt=(v)
    if v.to_i == 1
      self.hcz_permission |= HczPermission::LT
    else
      self.hcz_permission &= ~HczPermission::LT
    end
  end

  def self._authenticate(name, password)
    user = self.find_by_name(name)
    if user
      expected_password = _encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end

  # 'password' is a virtual attribute

  # def password
  #   @password
  # end

  # def password=(pwd)
  #   @password = pwd
  #   return if pwd.blank?
  #   create_new_salt
  #   self.hashed_password = User.encrypted_password(self.password, self.salt)
  # end

  # 当前用户是否为Admin用户
  def is_admin?
    ['admin', 'superadmin'].include? name
  end

  def is_super?
    self.name.eql?('superadmin')
  end

  def is_prov_manager?
    self.is_account_manager? and self.user_i_js == 1
  end

  def is_jg_manager?
    self.is_account_manager? and self.user_i_js == 0
  end

  def email_required?
    false
  end

  def province
    SysProvince.where(name: self.user_s_province).last
  end


  # 根据 用户的 原有角色 为functype赋值
  def assign_function_type
    if self.function_type.blank? or self.function_type.to_i == -1
      if self.rwbs == 1
        self.function_type = '1'
      elsif self.rwxd
        self.function_type = '2'
      elsif self.zxcy
        self.function_type = '3'
      elsif self.jsyp
        self.function_type = '4'
      elsif self.user_d_authority_1 == 1
        self.function_type = '5'
      elsif self.user_d_authority_2 == 1
        self.function_type = '6'
      elsif self.user_d_authority_5 == 1
        self.function_type = '7'
      elsif self.user_i_js == 1
        self.function_type = '8'
      elsif self.user_i_switch == 1
        self.function_type = '9'
      elsif self.hcz_czap == 1
        self.function_type = '10'
      elsif self.hcz_czbl == 1
        self.function_type = '11'
      elsif self.hcz_czsh == 1
        self.function_type = '12'
      elsif self.yysl == 1
        self.function_type = '13'
      elsif self.yybl == 1
        self.function_type = '14'
      elsif self.yysh == 1
        self.function_type = '15'
      elsif self.jbxx_sh == 1
	self.function_type = '16'
      else
        self.function_type = rand(17..99).to_s
      end
    end
  end

  # 生成唯一编号
  def generate_uid
    # 检查function_type
    assign_function_type

    if self.mobile.present? and self.uid.blank?
      prov = self.province
      if prov.nil?
        self.errors.add(:uid, '用户省份不存在')
        Rails.logger.error('用户省份不存在')
        return false
      end

      if self.jg_bsb.nil?
        self.errors.add(:uid, '用户机构未设置')
        Rails.logger.error('用户机构未设置')
        return false
      end

      if self.function_type.blank?
        self.errors.add(:uid, '用户职能未设置')
        Rails.logger.error('用户职能未设置')
        return false
      end

      self.uid = "#{'%.2i' % prov.code.to_i}#{'%.2i' % self.jg_bsb.code.to_i }#{'%.2i' % self.function_type.split(',')[0]}"
      Rails.logger.error "CANDICATE PART: #{self.uid}"

      Rails.logger.error User.where('uid LIKE ?', "#{self.uid}%").map { |u| u.uid[6..7].to_i }
      existed_ids = User.where('uid LIKE ?', "#{self.uid}%").map { |u| u.uid[6..7].to_i }
      Rails.logger.error "Existed IDs: #{existed_ids.to_json}"
      available_ids = (1..99).to_a - existed_ids
      if available_ids.blank?
        self.errors.add(:uid, '满员')
        Rails.logger.error('满员')
        return false
      end
      self.uid = "#{self.uid}#{'%.2i' % available_ids.first.to_i }"
      Rails.logger.error "message send result: #{send_sms_msg({platform: "#{SysConfig.get(SysConfig::Key::PROV)}食品抽检报送平台",uid: self.uid}, TMPL_CODE[:SFYZ])}"
    end
    return true
  end

  def api_generate_uid
    if self.province.nil?
      return {"type" => false, "msg" => "用户省份不存在"}
    end
    if self.jg_bsb.nil?
      return {"type" => false, "msg" =>"用户机构不存在"}
    end
    uid = "#{'%.2i' % self.province.code.to_i}#{'%.2i' % self.jg_bsb.code.to_i }"
    existed_ids = User.where('uid LIKE ?', "#{uid}%").map { |u| u.uid[4..7].to_i }
    available_ids = (1..99999).to_a - existed_ids
    if available_ids.blank?
      return {"type" => false, "msg" =>"满员"}
    end
    uid = "#{uid}#{'%.5i' % available_ids.first.to_i }"
    return {"type" => true, "msg" => uid}
  end

  API_URL = 'http://gw.api.taobao.com/router/rest?%s'
  TMPL_CODE = {
      SFYZ: 'SMS_6700288',
  }

  def send_sms_msg(params, template_code)
    form = {method: 'alibaba.aliqin.fc.sms.num.send', app_key: '23293361', timestamp: Time.now.strftime('%Y-%m-%d %H:%M:%S'), format: 'json', v: '2.0', sign_method: 'md5', sms_type: 'normal', sms_free_sign_name: '食品抽检报送平台', sms_param: params.to_json, rec_num: self.mobile, sms_template_code: template_code}

    form[:sign] = Digest::MD5.hexdigest('eb21d46b595e70ba0c6055bbb6b36781' + form.sort.flatten.join('') + 'eb21d46b595e70ba0c6055bbb6b36781').upcase

    response = JSON.parse(Net::HTTP.get(URI.parse(API_URL % [form.to_query])), :symbolize_names => true)
    result = response[:alibaba_aliqin_fc_sms_num_send_response][:result]
    if result[:err_code].to_i == 0
      true
    else
      false
    end
  end

  # 该账号是否通过审核
  def is_passed?
    self.state == User::State::InUse
  end

  def is_rejected?
    self.state == User::State::Rejected
  end

  def self.jg_type_map
    {"监管用户" =>1 ,"机构用户" =>3}
  end

  def jg_type_name
    User.jg_type_map.invert[self.jg_type]
  end

 def is_county_level?
    self.is_account_manager && self.user_i_js == 1 && self.admin_level == 3
 end

 def is_city?
   self.is_account_manager && self.user_i_js == 1 && self.admin_level == 2
 end

 def is_sheng?
   self.is_account_manager && self.user_i_js == 1 && self.admin_level == 1
 end

  def jgname
    JgBsbName.where(jg_bsb_id: self.jg_bsb.id).order("updated_at asc").last
  end
  private
  # def password_non_blank
  #   errors.add(:password, "Missing password") if hashed_password.blank?
  # end

  # 如果申请的用户机构类型为省局,则直接由省局管理员审核,否则走二级审核流程
  def config_user_state
    if self.jg_bsb.present? and self.state != State::InUse
      if self.jg_bsb.jg_type == 1
        self.state = State::ReviewSJ
      else
        self.state = State::ReviewJG
      end
    end
  end

  def cleanup_after_create
    Rails.logger.error 'Do cleaning work after user create'
    sms = SmsLog.where(sms_type: 'signup', mobile: self.mobile).last
		sms.update_attributes(used_at: Time.now) unless sms.nil?
    UserAuditLog.create(user_id: self.id, operator_id: self.id, action: UserAuditLog::Action::UserReq, msg: '新注册')
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

  def self._encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end
   # 用户检索表单虚拟类
  class UserSearchForm
    include ActiveModel::Model
    include Virtus.model

    attribute :tname, String
    attribute :prov, String
    attribute :uid, String
    attribute :jg_id, Integer

    attribute :tbjbxx, Integer, default: 0
    attribute :jbjcsj, Integer, default: 0
    attribute :sbsh, Integer, default: 0
    attribute :sbpz, Integer, default: 0
    attribute :jbxxsh, Integer, default: 0

    attribute :yy_gly, Integer, default: 0
    attribute :yy_yysl, Integer, default: 0
    attribute :yy_zhxt, Integer, default: 0
    attribute :yy_yybl, Integer, default: 0
    attribute :yy_yysh, Integer, default: 0

    attribute :pad_jsyp, Integer, default: 0
    attribute :pad_zxcy, Integer, default: 0
    attribute :pad_rwbs, Integer, default: 0
    attribute :pad_rwxd, Integer, default: 0

    attribute :hcl_gly, Integer, default: 0
    attribute :hcl_czap, Integer, default: 0
    attribute :hcl_czbl, Integer, default: 0
    attribute :hcl_czsh, Integer, default: 0
    attribute :qtjg, Integer, default: 0
  end
end

