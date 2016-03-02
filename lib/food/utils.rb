module Food
	require 'food/url'

	# 工具类
	class Utils
		def self.build_url(name)
			raise Exception.new("未设置::Url::BaseUrl") if ::Food::Url::BaseUrl.blank?
			"#{::Food::Url::BaseUrl}#{name}"
		end

		def self.post(path, form)
			Unirest.post(Utils.build_url(path), headers: { accept: "application/json" }, parameters: form).body
		end
	end
end
