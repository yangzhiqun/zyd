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
					response.as_json['sign_data_re_all_info_response']['out']
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
        rescue Savon::SOAPFault => error
					Rails.logger.error "CAHelper#verify_signed_data_by_all_info: #{error.as_json}"
          false
        end
		end

		# 验证客户端cert
		def validate_cert(userCert)
			response = @client.call(:validate_cert, message: {appName: "SVSDefault", password: userCert})
			response.as_json[:validate_cert_response][:out].to_i
		end

		# 获取用户信息
		def get_cert_info_by_oid(userCert)
			response = client.call(:get_cert_info_by_oid, message: {appName: "SVSDefault", base64EncodeCert: userCert, oid: '1.2.156.112562.2.1.2.2'})
			response.as_json[:get_cert_info_by_oid_response][:out].gsub(/SF/, '')
		end

		# 返回值: [随机数, 服务器证书, 签名值]
		def gen_client_verify_random_info
			ca_random = gen_random(32)
			{ ca_random: ca_random, certificate: get_server_certificate, signed: sign_data_re_all_info(ca_random) }
		end
	end
end
