# encoding: UTF-8

# 应用系统向 UAMS 同步数据
module Api::DataSync
	
	Config = YAML.load_file("config/uams_sync.yml")
	Host, Port, Dir, Authid = Config["host"], Config["port"], Config["dir"], Config["authid"]

	# 机构管理接口
	class DeptInfo
		
		class << self	

			# 查询机构信息接口-webservice
			#def query_organization_vo(organizationVO)
			#end

			# 查询机构信息接口-rest
			def query_organization_vo(code)
				uri = URI.parse("http://#{Host}:#{Port}#{Dir}/rest/QueryOrganizationVO?authId=#{Authid}&orgNumber=#{code}")
				result = JSON(Net::HTTP.get_response(uri).body)
				p result
				if result["status"] == 0
					dept = JgBsb.where(jg_code: code).first
					dept_docking = API::DataDocking.convert_org(result["info"]) 
					if result["info"]["orgUpCodeNumber"] != "root"
						name = select_up_number(result["info"]["orgUpCodeNumber"])
						dept_docking["jg_province"] = name
					end
					if !dept.blank?
						up_result = dept.update_attributes(dept_docking)
						jg_bsb_name = JgBsbName.find_by_jg_bsb_id(dept.id)
						if !jg_bsb_name.nil?
							jg_bsb_name.update_attributes(name: result["info"]["orgName"])
						end
						return up_result
					else
						org = JgBsb.new(dept_docking)
						#return org.save
						if org.save
							p "1111111111111111111111"
							p org.id,result["info"]["orgName"]
							p "1111111111111111111111"
							JgBsbName.create(name: result["info"]["orgName"], jg_bsb_id: org.id)	
							return true
						else
							p org.errors.to_json
							return false
						end
					end
				else	
					return false
				end
			end

			def select_up_number(code)
				uri = URI.parse("http://#{Host}:#{Port}#{Dir}/rest/QueryOrganizationVO?authId=#{Authid}&orgNumber=#{code}")
				result = JSON(Net::HTTP.get_response(uri).body)
				if result["status"] == 0
					if result["info"]["orgUpCodeNumber"] == "root"
						return result["info"]["orgName"]
					else
						select_up_number(result["info"]["orgUpCodeNumber"])
					end
				end
			end
			
			# 添加以及修改机构信息接口	
			#def add_dept_info(obj,type)
			#	hash = API::DataDocking.convert_org(JSON(obj.to_json))
			#	uri  = URI("http://#{Host}:#{Port}#{Dir}/#{type}")
			#	dept = {"operatorId": Authid,"organizationVO": hash}
			#	res = Net::HTTP.post_form(uri,dept).body	
			#end
			
			# 删除机构信息接口
			#def del_dept_info(deptId) 
			#	uri = URI.parse("http://#{Host}:#{Port}#{Dir}/delDeptInfo?operatorId=#{Authid}&deptId=#{deptId}")
			#	result = JSON(Net::HTTP.get_response(uri).body)
			#end
		end
	end

	# 用户管理接口
	class UserInfo

		class << self

			# 查询用户信息接口-webservice
			#def get_user_info_detail(code)
			#	uri = URI.parse("http://#{Host}:#{Port}#{Dir}/getUserInfoDetail?operatorId=#{Authid}&userId=#{code}")
			#	result = JSON(Net::HTTP.get_response(uri).body)
			#end

			# 查询用户信息接口-rest
			def query_user_info_detail(code)
				uri = URI.parse("http://#{Host}:#{Port}#{Dir}/rest/QueryUserInfoDetail?authId=#{Authid}&userIdCode=#{code}")
				result = JSON(Net::HTTP.get_response(uri).body)
				p result
				if result["status"] == 0
					user = User.where(user_code: result["info"]["userIdCode"]).first
					user_docking = API::DataDocking.convert_user(result["info"]) 
					p "+"*100
					p user_docking
					p "+"*100
					if !user.blank?
						up_result = user.update_attributes(user_docking)
						return up_result
					else
						user = User.new(user_docking)
						p user
						if user.save
							return true
						else
							p user.errors.to_json
							return false
							#return user.save
						end
					end
				else
					return false
				end
			end
			
			# Api::DataSync::DeptInfo.query_organization_vo("220900")
			# 添加以及修改用户信息接口
			# type:addUserInfo;modUserInfo
			#def add_up_user_info(obj,type)
			#	hash = API::DataDocking.convert_user(JSON(obj.to_json))
			#	uri  = URI("http://#{Host}:#{Port}#{Dir}/#{type}")
			#	user = {"operatorId": Authid,"userInfoVO": hash}
			#	res = Net::HTTP.post_form(uri,user).body	
			#end

			# 删除用户信息接口
			#def del_user_info(code)
			#	uri = URI.parse("http://#{Host}:#{Port}#{Dir}/delUserInfo?operatorId=#{Authid}&userId=#{code}")
			#	result = JSON(Net::HTTP.get_response(uri).body)
			#	p "------------------------------------"
			#	p result
			#end

			# 修改用户状态信息接口
			#def change_user_status_info(userId,status)
			#	uri = URI.parse("http://#{Host}:#{Port}#{Dir}/changeUserStatusInfo?operatorId=#{Authid}&userId=#{userId}&userStatus=#{status}")
			#	result = JSON(Net::HTTP.get_response(uri).body)
			#end
		end
	end

	# 凭证管理接口
	class CredenceInfo
	end

	# 从账号管理接口
	class DeputyAccountInfo
	end
end
