# encoding: UTF-8
require 'csv'

module UpCode
	# num 1:用户 2:机构
	def self.process(route,num)
		if File.exist?(route)
			@csv = CSV.open(route).read
			@csv[1..-1].each do |c|
				if !c[0].nil?
					user = User.where("id = #{c[0]}").first
					if !user.blank? && !c[1].nil?
						p user
						p "-"*10
						org_num = c[1].gsub(/\s/,"")
						user.update_attributes(:user_code => org_num)
					end
				end
			end
		end
	end
end
