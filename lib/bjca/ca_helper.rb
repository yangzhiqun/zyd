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

		def get_random(appName, length)
			response = client.call(:get_random, message: {appName: "SVSDefault", len: length})
			puts response.to_json
			# response_code = response.as_json['validate_cert_response']['out'].to_i
		end

	end
end
