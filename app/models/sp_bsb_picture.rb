class SpBsbPicture < ActiveRecord::Base
  # attr_accessible :desc, :md5, :path, :sort_index, :sp_bsb_id

	before_save :move_file
  after_destroy :remove_file

	attr_accessor :tmp_file

	def absolute_path
		"#{Rails.application.config.attachment_path}/#{path}/#{md5}"
	end

	private
    def move_file
			return if tmp_file.blank?
      self.md5 = Digest::MD5.file(tmp_file.path).hexdigest.upcase
      self.path = Time.now.strftime("%Y/%m/%d")

      FileUtils.mkdir_p "#{Rails.application.config.attachment_path}/#{path}" unless Dir.exists? "#{Rails.application.config.attachment_path}/#{path}"

      FileUtils.mv(tmp_file.path, "#{Rails.application.config.attachment_path}/#{path}/#{md5}")
    end 

    def remove_file
      unless path.nil?
				begin
					FileUtils.remove_file(self.absolute_path)
				rescue Exception => e
					# TODO:
				end
      end 
    end 
end
