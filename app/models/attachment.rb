#encoding: utf-8
class Attachment < ActiveRecord::Base

	# attr_accessible :tmp_file, :filename, :content_type, :md5, :path

	attr_accessor :tmp_file

	before_create :move_file
	after_destroy :remove_file

	def absolute_path
		"#{Rails.application.config.attachment_path}/#{path}/#{md5}"
	end

	private
		def move_file
			self.path = Time.now.strftime("%Y/%m/%d")
			if tmp_file.is_a?(File)
				raise Exception.new('请提供filename') if self.filename.blank?
				self.filename = filename
				self.content_type = "image/jpeg"
				puts tmp_file.path
				self.md5 = Digest::MD5.file(tmp_file.path).hexdigest.upcase
				FileUtils.mkdir_p "#{Rails.application.config.attachment_path}/#{path}" unless Dir.exists? "#{Rails.application.config.attachment_path}/#{path}"
				FileUtils.cp(tmp_file.path, "#{Rails.application.config.attachment_path}/#{path}/#{md5}")
			else
				self.filename = filename || tmp_file.original_filename
				self.content_type = tmp_file.content_type
				self.md5 = Digest::MD5.file(tmp_file.path).hexdigest.upcase
				FileUtils.mkdir_p "#{Rails.application.config.attachment_path}/#{path}" unless Dir.exists? "#{Rails.application.config.attachment_path}/#{path}"
				FileUtils.mv(tmp_file.path, "#{Rails.application.config.attachment_path}/#{path}/#{md5}")
			end
		end

		def remove_file
			unless path.nil?
				FileUtils.remove_file(self.absolute_path)
			end
		end
end
