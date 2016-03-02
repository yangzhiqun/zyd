module Food
	require 'food/url'

	# Token Manager
	class TokenManager

		attr_accessor :expired_at, :access_token, :created_at

		def initialize

			@client_id = Rails.application.config.site[:client_id]
			raise Exception.new("未配置client_id") if @client_id.blank?
			@client_secret = Rails.application.config.site[:client_secret]
			raise Exception.new("未配置client_secret") if @client_secret.blank?

			read_from_file
		end

		def get_token
			if Time.now.to_i > self.expired_at.to_i
				request_token
			end

			self.access_token
		end

		def request_token
			response = Unirest.post(Utils.build_url(::Food::Url::GetToken), headers: {accept: 'application/json'}, parameters: { client_id: @client_id, client_secret: @client_secret, grant_type: "client_credentials"}).body
			if response['error'].nil?
				self.access_token = response['access_token']
				self.created_at = response['created_at']
				self.expired_at = self.created_at + response['expires_in']
				write_to_file
			else
				raise Exception.new(response['error'])
			end
		end

		def json
			{expired_at: self.expired_at, access_token: self.access_token, created_at: self.created_at}
		end

		private
			# 一定要将获取到的token信息保存在本地，因服务器有获取次数的限制，所以过期前请勿一直重复获取token
			def write_to_file
				File.open "./access_token", 'w+' do |f|
					f.puts self.json.to_json
				end
			end

			# 将保存的token信息读取出来
			def read_from_file
				if File.exists?('./access_token')
					content = JSON.parse(File.read('./access_token'))
					self.expired_at = content['expired_at']
					self.created_at = content['created_at']
					self.access_token = content['access_token']
				else
					request_token
				end
			end
	end
end
