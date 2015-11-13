#encoding: utf-8
class CompanyStandard < ActiveRecord::Base
  attr_accessible :attachment_id, :author_company, :name, :number, :valid_at, :user_id, :attachment_path_file

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

  def attachment_path_file=(file)
    # 10M
    if File.size(file.path) > 5242880
      self.errors.add(:attachment_path, "上传失败！请上传不大于5M的报告文件")
      return false
    end
    self.attachment_path = handle_uploaded_file("company_standards", file) unless file.blank?
  end 

  def attachment_path_file
    Rails.application.config.attachment_path + "/" + self.attachment_path unless self.attachment_path.blank?
  end 
end
