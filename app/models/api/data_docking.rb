# encoding: UTF-8

# UAMS的返回结果跟项目的字段对接
class API::DataDocking
	
	class << self
		
		# 用户对应Hash
		User_data_hash = {:tname=>"userName",:id_card=>"userIdcardNum",:email=>"userEmail",:state=>"userStatus",:user_s_province=>"",:user_code=>"userIdCode",:mobile=>"userPhone"}
			
		# 机构对应Hash
		Org_data_hash  = {:jg_name=>"orgName",:jg_province=>"orgName",:jg_code=>"orgNumber"}

		# 凭证信息对应Hash
		Credence_data_hash = {}

		# 从账号信息对应Hash
		DeputyAccount_data_hash = {}

		# 转换用户信息
		def convert_user(user)
			result = {}
			User_data_hash.each do |k,y|
				result[k] = user[y]
			end
			crendence = user['credenceList'][0]
			if crendence['credenceClass'].include?('002')
				result[:uid] = crendence["loginName"]
			end
			# 创建修时改开放用户权限
			result[:ca_user_status] = 0

			#--------------------------------
			result[:function_type] = "2"
			#result["jg_bsb_id"] = 10
			jg_bsb = JgBsb.find_by_jg_code(user['orglist'][0]['orgNumber'])	
			result[:jg_bsb_id] = jg_bsb.id unless jg_bsb.nil?
			result[:user_s_province] = "吉林省"
			#result["mobile"] = "13657853565"
			result[:password] = "12345678"
			#--------------------------------

			return result	
		end

		# 转换机构信息
		def convert_org(info_org)
			result = {}
			Org_data_hash.each do |k,y|
				result[k] = info_org[y]
			end
			#jg_province 省份名称
			#code 省份id 两位数
			#result["jg_province"] = "江西"
			#result["code"] = "28"
			return result	
		end
	end	
end
