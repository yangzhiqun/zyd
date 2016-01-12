#encoding: utf-8
require 'digest/sha1'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include ApplicationHelper

  validates_presence_of :function_type
  validates_numericality_of :function_type, greater_than: 0, message: '请选择用户职能'

  validates_uniqueness_of :uid, allow_blank: true
  validates_presence_of :uid, allow_blank: true

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_uniqueness_of :id_card, message: "身份证号已绑定", allow_nil: true, allow_blank: true
  validates_format_of :id_card, with: /(^\d{15}$)|(^\d{17}([0-9]|X)$)/i, message: '身份证格式不正确'
  validates_format_of :mobile, with: /(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}/i, message: '手机号格式不正确'
  validates_uniqueness_of :user_sign, message: "签名已存在", allow_nil: true, allow_blank: true
  validates_confirmation_of :password
  validate :password_non_blank

  def is_info_complete?
    !id_card.blank? and !tname.blank? and !tel.blank?
  end

  attr_accessor :password_confirmation
  # attr_accessible :jg_bsb_id, :id_card, :user_sign, :pub_xxfb, :pub_xxfb_sh, :user_s_city, :user_s_lcity, :yyadmin, :jsyp, :hcz_admin, :car_sys_id, :zxcy, :rwbs, :rwxd, :enable_api,:hcz_sc, :hcz_lt, :hcz_czap, :hcz_czbl, :hcz_czsh, :yysl, :zhxt, :yybl, :yysh, :yycz_permission, :name, :password, :password_confirmation,:tname,:tel,:eaddress,:company,:user_s_province,:user_d_authority,:user_d_authority_1,:user_jcjg,:user_jcjg_lxr,:user_jcjg_tel,:user_jcjg_mail,:user_cyjg,:user_cyjg_lxr,:user_cyjg_tel,:user_cyjg_mail,:user_d_authority_2,:user_d_authority_3,:user_d_authority_4,:user_d_authority_5,:user_i_js,:user_i_switch,:user_i_sp,:user_i_hzp,:user_i_bjp,:user_s_dl,:user_i_spys,:user_i_spss

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

  FuncType = {
      '任务部署' => 1,
      '任务下达' => 2,
      '抽样人员' => 3,
      '接样人员' => 4,
      '机构主检人' => 5,
      '机构审核人' => 6,
      '机构批准人' => 7,
      '省局审核人' => 8,
      '牵头机构审核人' => 9,
      '核查处置安排人' => 10,
      '核查处置办理人' => 11,
      '核查处置审核人' => 12,
      '异议登记' => 13,
      '异议办理' => 14,
      '异议审核' => 15
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
      self.hcz_permission |= HczPermission::CZBL
    else
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

  def email_required?
    false
  end

  def province
    SysProvince.where(name: self.user_s_province).last
  end

  # 生成唯一编号
  def generate_uid
    if self.uid.blank?
      prov = self.province
      if prov.nil?
        Rails.logger.error('用户省份不存在')
        return nil
      end

      if self.jg_bsb.nil?
        Rails.logger.error('用户机构未设置')
        return nil
      end

      if self.function_type == -1
        Rails.logger.error('用户职能未设置')
        return nil
      end

      self.uid = "#{Time.now.strftime('%Y%m%d')}#{'%.3i' % self.id}"

      self.uid = "#{'%.2i' % prov.code.to_i}#{'%.2i' % self.jg_bsb.code.to_i }#{'%.2i' % self.function_type}"
      available_ids = (1..99).to_a - User.where('uid LIKE ?', "#{self.uid}%").map{|u| u[6..7].to_i}
      if available_ids.blank?
        Rails.logger.error('满员')
        return nil
      end
      self.uid = "#{self.uid}#{'%.2i' % available_ids.first.to_i }"

      self.save
    end
    self.uid
  end

  API_URL = 'http://gw.api.taobao.com/router/rest?%s'

  def send_sms_msg
    form = {method: 'alibaba.aliqin.fc.sms.num.send', app_key: '23293361', timestamp: Time.now.strftime('%Y-%m-%d %H:%M:%S'), format: 'json', v: '2.0', sign_method: 'md5', sms_type: 'normal', sms_free_sign_name: '身份验证', sms_param: {uid: self.uid}.to_json, rec_num: self.mobile, sms_template_code: 'SMS_4025594'}

    form[:sign] = Digest::MD5.hexdigest('eb21d46b595e70ba0c6055bbb6b36781' + form.sort.flatten.join('') + 'eb21d46b595e70ba0c6055bbb6b36781').upcase

    response = JSON.parse(Net::HTTP.get(URI.parse(api_url % [form.to_query])), :symbolize_names => true)
    result = response[:alibaba_aliqin_fc_sms_num_send_response][:result]
    if result[:err_code].to_i == 0
      return true
    else
      return false
    end
  end

  private
  def password_non_blank
    errors.add(:password, "Missing password") if hashed_password.blank?
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

  def self._encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end
end

