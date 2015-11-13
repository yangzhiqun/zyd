#encoding: utf-8
class SampleMember < ActiveRecord::Base
  attr_accessible :attachment_id, :gender, :edu_bg, :jg_name, :major, :mobile, :note, :title, :uid, :username, :work_history, :portrait_file

	validates_uniqueness_of :uid, :message => "已存在该用户", on: :create

	# 修改头像
	def portrait_file=(file)
		unless file.blank?
			attachment = Attachment.create(filename: "#{self.username}_头像", tmp_file: file)
			self.attachment_id = attachment.id
		end
	end
	
	# 获取头像
	def portrait_file
		#Attachment.find(self.attachment_id).absolute_path unless self.attachment_id.blank?
		nil
	end
end
