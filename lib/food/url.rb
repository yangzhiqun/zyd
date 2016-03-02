module Food
	module Url
		BaseUrl           = Rails.application.config.site[:api_base]
		GetToken          = "/oauth/token"
		TransferSpBsb     = "/api/v2/sp_bsbs/transfer.json"
		TransferWtypCzb   = "/api/v2/wtyp_czbs/transfer.json"
		TransferYycz      = "/api/v2/yycz/transfer.json"
		Heartbeat         = "/api/v2/ejz/i-am-alive.json"
		FetchConfig       = "/api/v2/ejz/fetch-configs.json"
	end
end
