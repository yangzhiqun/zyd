#encoding: utf-8
class JgBsb < ActiveRecord::Base
  #validates_presence_of :jg_address, message: '请填写机构地址'
  validates_presence_of :jg_province, message: '请填写机构省份'
  # validates_uniqueness_of :jg_address, message: '机构地址重复'
  validates_uniqueness_of :code, message: '该编号已存在', scope: [:jg_province], allow_blank: true
  require 'RMagick'

  has_many :jg_bsb_names, dependent: :delete_all
  has_many :jg_bsb_stamps
  has_many :users
  has_many :jg_bsb_supers, foreign_key: :super_jg_bsb_id

  attr_accessor :super_jg_bsbs

  JG_TYPE = [{
                 name: '监管部门',
                 code: 1
             },
             # {
             #     name: '采样机构',
             #     code: 2
             # },
             {
                 name: '检验机构',
                 code: 3
             }
  ]

  after_save :doings_after_save
  before_save :generate_code

  def pdf_sign_rules
    #return super
    self.jg_bsb_stamps.pluck(:stamp_no).join('#')
  end

  def merge(src_jg)
    return false if src_jg.id == self.id
    ActiveRecord::Base.transaction do
      User.where(jg_bsb_id: src_jg.id).update_all(user_s_province: self.jg_province, jg_bsb_id: self.id)
      TaskJgBsb.where(jg_bsb_id: src_jg.id).update_all(jg_bsb_id: self.id)

      current_name = self.current.name
      self.current.destroy

      src_jg.update_attributes(status: 1)

      src_jg.jg_bsb_names.each do |jg_name|
        jg_name.update_attributes(jg_bsb_id: self.id, note: "由机构[#{src_jg.jg_name}]合并而来")
      end

      JgBsbName.create(name: current_name, jg_bsb_id: self.id, note: "合并机构[#{src_jg.id}]后重新生成")
    end
    return true
  end

  def self.find_by_history_name(name)
    jg_name = JgBsbName.where(name: name).last
    if jg_name.present?
      JgBsb.find(jg_name.jg_bsb_id)
    else
      nil
    end
  end

  def current
    self.jg_bsb_names.order('id ASC').last
  end

  def all_names
    self.jg_bsb_names.map { |jg_name| jg_name.name }
  end

#=begin
  def jg_name
    if self.current.nil?
      '<span class="text-danger"><未设置></span>'.html_safe
    else
      self.current.name
    end
  end

  def self.find_by_jg_name(name)
    return nil unless JgBsbName.exists?(name: name)
    return JgBsbName.where(name: name).first.jg_bsb
  end

#=end

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

  validate do |jg_bsb|
    self.errors.add(:attachment_path_file, "上传失败！上传文件不是png文件") if @file_format_invalid
    self.errors.add(:attachment_path_file, "上传失败！上传文件宽度或高度超过200像素") if @file_width_height_exceed
    self.errors.add(:attachment_path_file, "上传失败！请上传不大于0.5M的文件") if @file_size_exceed
  end

  def attachment_path_file=(file)
    unless File.extname(file.original_filename).downcase.eql?(".png")
      @file_format_invalid = true
      return false
    end

    # attachment file size <= 0.5M
    if File.size(file.path) > 524288
      @file_size_exceed = true
      return false
    end

    #check image width&height <=200
    img = Magick::Image.read(file.path).first
    width = img.columns
    height = img.rows
    if width > 200 or height > 200
      @file_width_height_exceed = true
      return false
    end

    self.attachment_path = handle_uploaded_file("jg_bsbs", file) unless file.blank?
  end

  def attachment_path_file
    Rails.application.config.attachment_path + "/" + self.attachment_path unless self.attachment_path.blank?
  end

  def doings_after_save
    update_super_jg_bsbs_info
    ActionController::Base.new.expire_fragment('jg_data', options = nil)
  end

  def update_super_jg_bsbs_info
    ids = self.super_jg_bsbs
    if ids.present?{
      ids.delete('')
      ids = ids.map { |j| j.to_i }
      self.jg_bsb_supers.where('id not in (?)', ids).destroy_all
      self.jg_bsb_supers.reload
      (ids - self.jg_bsb_supers.pluck(:id)).each do |i|
        JgBsbSuper.create(jg_bsb_id: self.id, super_jg_bsb_id: i)
      end
      }
    end
  end

# 对机构进行编号
  def generate_code
    if self.code.to_i == 0 or self.code.blank?
      self.code = '%.2i' % [((1..99).to_a - JgBsb.where(jg_province: self.jg_province).map { |j| j.code.to_i })[0]]
    end
  end
end
