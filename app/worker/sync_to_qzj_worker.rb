class SyncToQzjWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  require 'food/token_manager'
  include Food

  def perform(sp_bsb_id=nil)
    Unirest.timeout(500)

    @token_manager = TokenManager.new

    if sp_bsb_id.blank?
      @cjbhs = []
      @form_data = []

      SpBsb.where('(synced_at IS NULL OR synced_at < updated_at) AND sp_i_state IN (?)', [6, 8, 9]).limit(1000).each do |bsb|
        @form_data.push(bsb.to_api_json)
        @cjbhs.push(bsb.sp_s_16)
      end

			logger.error @cjbhs

      response = Utils.post(Url::TransferSpBsb, {access_token: @token_manager.get_token, data: @form_data.to_json})
      logger.info response.as_json

      if response['errorcode'].present? and response['errorcode'].to_i == 0
        #TODO: 这里应该处理为只更新提交成功的样品
        SpBsb.where(sp_s_16: @cjbhs).each do |bsb|
					bsb.update_attributes(synced_at: bsb.updated_at)
				end
      end

			response['update'].each do |u|
				u.delete('id')
				bsb = SpBsb.find_by_sp_s_16(u['sp_s_16'])
        u[:synced_at] = u['updated_at']
				bsb.update_attributes(u)
				logger.error "#{bsb.sp_s_16}# U: #{bsb.updated_at.to_i}, S: #{bsb.synced_at.to_i}"
			end if response['update'].present?
    else
      @sp_bsb = SpBsb.find(sp_bsb_id)
      response = Utils.post(Url::TransferSpBsb, {access_token: @token_manager.get_token, data: [@sp_bsb.to_api_json].to_json})

      logger.info response.as_json

      if response['errorcode'].present? and response['errorcode'].to_i == 0
				@sp_bsb.update_column(:synced_at, @sp_bsb.updated_at)
      end

			response['update'].each do |u|
				u.delete('id')
				bsb = SpBsb.find_by_sp_s_16(u['sp_s_16'])
        u[:synced_at] = u['updated_at']
				bsb.update_attributes(u)
				logger.error "#{bsb.sp_s_16}# U: #{bsb.updated_at.to_i}, S: #{bsb.synced_at.to_i}"
			end if response['update'].present?
    end
  end
end
