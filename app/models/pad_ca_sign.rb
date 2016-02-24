class PadCaSign < ActiveRecord::Base
	validate :verify_signed_data

	private
	def verify_signed_data
		@ca_helper = Bjca::CaHelper.new
		sn = @ca_helper.get_cert_info(self.user_cert, 2)
		Rails.logger.error "SN: #{sn}"
		inData = "#{self.signed_data}##{Base64.encode64("#{sn}##{self.orig_data}").strip}"
		if @ca_helper.verify_signed_data_by_all_info(inData)
			return true
		else
			self.errors.add(:base, '签名验证失败')
			#return false
		end
		return true
	end
end
