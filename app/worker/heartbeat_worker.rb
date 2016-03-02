class HeartbeatWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  require 'food/token_manager'
  require 'food/utils'

  include Food

  def perform
    @token_manager = TokenManager.new

    puts Utils.post(::Food::Url::Heartbeat, { access_token: @token_manager.get_token }).as_json
  end
end
