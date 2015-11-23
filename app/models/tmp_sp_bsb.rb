class TmpSpBsb < ActiveRecord::Base
	def is_bad_report?
  	result = sp_s_71 || ''
  	result.include?('问题样品') or result.include?('不合格样品')
	end
end
