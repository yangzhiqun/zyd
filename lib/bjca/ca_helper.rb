module Bjca
	class CaHelper
		ResponseCode = {
				'code:1' => '成功',
				'code:-1' => '不是所信任的根',
				'code:-2' => '超过有效期',
				'code:-3' => '作废证书',
				'code:-4' => '已加入和名单',
				'code:-5' => '证书未生效',
				'code:0' => '未知错误'
		}

		def initialize
			@client = Savon.client(wsdl: "http://#{Rails.application.config.site[:ca_auth_address]}/webservice/services/SecurityEngineDeal?wsdl")
		end

		# 获取随机数
		def gen_random(length)
        begin
					response = @client.call(:gen_random, message: {appName: "SVSDefault", len: length})
					response.as_json['gen_random_response']['out']
        rescue Savon::SOAPFault => error
					Rails.logger.error "CAHelper#get_random: #{error.as_json}"
          nil
        end
		end

		# 获取服务器签名
		def get_server_certificate
        begin
					response = @client.call(:get_server_certificate, message: {appName: "SVSDefault"})
					response.as_json['get_server_certificate_response']['out']
        rescue Savon::SOAPFault => error
					Rails.logger.error "CAHelper#get_server_certificate: #{error.as_json}"
          nil
        end
		end

		# 数据签名
		def sign_data_re_all_info(data)
        begin
        	response = @client.call(:sign_data_re_all_info, message: {appName: 'SVSDefault', inData: data})
					out = response.as_json['sign_data_re_all_info_response']['out']
					return out
        rescue Savon::SOAPFault => error
					Rails.logger.error "CAHelper#sign_data_re_all_info: #{error.as_json}"
          nil
				end
		end

		# 验证签名
		def verify_signed_data_by_all_info(signedData)
        begin
					response = @client.call(:verify_signed_data_by_all_info, message: {appName: 'SVSDefault', verifySignedData: signedData})
					response.as_json['verify_signed_data_by_all_info_response']['out'].to_i == 1
					Rails.logger.error response.as_json
        rescue Savon::SOAPFault => error
					Rails.logger.error "CAHelper#verify_signed_data_by_all_info: #{error.as_json}"
          false
        end
		end
		def sign_data(inData)
			begin
				response = @client.call(:sign_data, message: {appName: 'SVSDefault', inData: inData})
				response.as_json['sign_data_response']['out'].to_i == 1
				Rails.logger.error response.as_json
			 rescue Savon::SOAPFault => error
				Rails.logger.error "CAHelper#sign_data: #{error.as_json}"
	         nil
			end
		end

		# 验证客户端cert
		def validate_cert(userCert)
			response = @client.call(:validate_cert, message: {appName: "SVSDefault", password: userCert})
			Rails.logger.error response.as_json
			response.as_json['validate_cert_response']['out'].to_i
		end

		# 获取用户信息
		def get_cert_info_by_oid(userCert)
				response = @client.call(:get_cert_info_by_oid, message: {appName: "SVSDefault", base64EncodeCert: userCert, oid: '1.2.156.112562.2.1.1.1'})
			Rails.logger.error response.as_json
			response.as_json['get_cert_info_by_oid_response']['out'].gsub(/SF/, '')
		end

		def get_cert_info(userCert, type)
			response = @client.call(:get_cert_info, message: {appName: "SVSDefault", base64EncodeCert: userCert, type: type})
			Rails.logger.error response.as_json
			response.as_json['get_cert_info_response']['out']
		end

		# 返回值: [随机数, 服务器证书, 签名值]
		def gen_client_verify_random_info
			ca_random = gen_random(32)
			t = { ca_random: ca_random, certificate: get_server_certificate, signed: sign_data_re_all_info(ca_random) }
			Rails.logger.error t.as_json
			t
		end
		#随机数
		def get_random
		 if !File::exists?(Rails.root.join('tmp', "random.txt") )
                    File.new(Rails.root.join('tmp', "random.txt"),"w+")
                 end
		 cmd = "java -jar #{Rails.root.join('bin', 'mssg-sign-client-1.0.7-SNAPSHOT-clientAll.jar')} #{Rails.application.config.site[:ip]} #{Rails.application.config.site[:port]} '9ff70fce51874b62a5f136fdda43c4b7' 'GENRANDOM' 32  #{Rails.root.join('tmp', "random.txt")}"  
	         result = `#{cmd}`
	         random =File.read(Rails.root.join('tmp', "random.txt"))
         	end
		#服务器证书
		def get_server_cert
	         ca_server_cert=Rails.application.config.site[:ca_server_cert]
		end
		#对随机数签名
	       def sign_data_info(ca_random)
		if !File::exists?(Rails.root.join('tmp', "signData.txt") )
                    File.new(Rails.root.join('tmp', "signData.txt"),"w+")
                 end
	 	appid= '9ff70fce51874b62a5f136fdda43c4b7'
	    	type ='SIGNDATA'
	    	#random_content =Base64.strict_encode64(ca_random.to_json)
		random_content =ca_random
	        keyID= 'KEY_856191b94857447fb88fd09cc483423b'
		zs=Rails.application.config.site[:ca_server_cert]
	       signDate =Rails.root.join('tmp', "signData.txt")
	       cmd = "java -jar #{Rails.root.join('bin', 'mssg-sign-client-1.0.7-SNAPSHOT-clientAll.jar')} #{Rails.application.config.site[:ip]} #{Rails.application.config.site[:port]} #{appid} #{type} #{random_content} #{keyID}  #{zs} #{signDate}"
               result = `#{cmd}`
               signDate =File.read(Rails.root.join('tmp', "signData.txt"))
	     end
	    # 返回值: [随机数, 服务器证书, 签名值]
	    def get_client_verify_random_info
	        #ca_random= Base64.strict_encode64(get_random.to_json)
		ca_random=get_random
		t = { ca_random: ca_random, certificate: get_server_cert, signed: sign_data_info(ca_random) }
		Rails.logger.error t.as_json
		t
	   end
	   #
	   def validate_ca_cert(userCert)
		if !File::exists?(Rails.root.join('tmp', "validate.txt") )
                    File.new(Rails.root.join('tmp', "validate.txt"),"w+")
                end
		appid= '9ff70fce51874b62a5f136fdda43c4b7'
		type ='VERIFYCERT'
                res =Rails.root.join('tmp', "validate.txt")
                cmd = "java -jar #{Rails.root.join('bin', 'mssg-sign-client-1.0.7-SNAPSHOT-clientAll.jar')} #{Rails.application.config.site[:ip]} #{Rails.application.config.site[:port]}  #{appid} #{type} #{userCert}  #{res}"
		result = `#{cmd}`
		signDate =File.read(Rails.root.join('tmp', "validate.txt"))
	   end
	
	   def validate_random(random,signData,userCert)
                if !File::exists?(Rails.root.join('tmp', "sign.txt") )
                    File.new(Rails.root.join('tmp', "sign.txt"),"w+")
                end
		appid= '9ff70fce51874b62a5f136fdda43c4b7'
		type ='VERIFYSIGN'
		text =random
		text_gb2312 = text.encode 'gb2312','utf-8'
		text_content =Base64.strict_encode64(text_gb2312)
		signData = signData
		client_zs= userCert
   		sign_txt=Rails.root.join('tmp', "sign.txt")
   	cmd = "java -jar #{Rails.root.join('bin', 'mssg-sign-client-1.0.7-SNAPSHOT-clientAll.jar')} #{Rails.application.config.site[:ip]} #{Rails.application.config.site[:port]} #{appid} #{type} #{text_content} #{signData} #{client_zs}  #{sign_txt}"
		 result = `#{cmd}`
		sign =File.read(Rails.root.join('tmp', "sign.txt"))
	end


	end
end
