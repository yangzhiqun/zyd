class JgBsbStamp < ActiveRecord::Base
  # attr_accessible :jg_bsb_id, :note, :stamp_no, :image_path, :image_file

  validates_presence_of :stamp_no, message: '签章规则号不可为空'
  validates_presence_of :jg_bsb_id, message: '机构信息不可为空'

  belongs_to :jg_bsb
  attr_accessor :image_file

	module Type
		# 骑缝
		QF = 0
		# 资质
		ZZ = 1
		# 专用
		ZY = 2
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

  def image_file=(file)
    # attachment file size <= 0.5M
    if File.size(file.path) > 5242880
      @file_size_exceed = true
      return false
    end

    self.image_path = handle_uploaded_file("jg_bsb_stamps", file) unless file.blank?
  end

  def image_file
    Rails.application.config.attachment_path + "/" + self.image_path unless self.image_path.blank?
  end
end
