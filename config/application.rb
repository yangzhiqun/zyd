require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DemoyjsRuby2X
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = 'zh-CN'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.autoload_paths << Rails.root.join('lib')

    config.site = {
        :enable_ca_login => true, 
	:is_ejz          => true,
	:is_qzj          => false,
	:province        => "青海",
	:client_id       => "4d9bfbc1b9e39e27ceab94cd57ec1b7202cac13694e51fd026c21861593b1ef0",
	:client_secret   => "ecf7b1622a58c9b58f37178b0d14e4313a44edce72a22772606cb9a31bd8144a",
	:api_base        => "http://qzj.cfda.pub:880/",
	:ca_auth_address => '60.247.77.101',
  :ca_server_cert  => "MIIBwTCCAWagAwIBAgIJIBA0AAAAFX6sMAoGCCqBHM9VAYN1MD4xCzAJBgNVBAYMAkNOMQ0wCwYDVQQKDARCSkNBMQ8wDQYDVQQLDAZQRVJTT04xDzANBgNVBAMMBk1TU1BDQTAeFw0xNzAzMDYwNTA5MjZaFw0yMjAzMDYwNjA5MjZaMDwxCzAJBgNVBAYMAkNOMS0wKwYDVQQDDCRLRVlfODU2MTkxYjk0ODU3NDQ3ZmI4OGZkMDljYzQ4MzQyM2IwWTATBgcqhkjOPQIBBggqgRzPVQGCLQNCAAS5JKsfdSgnNJvH88CSYx6t/Wd0ZnT96yOE188F0xh7IH+eoK3DgE1wKRn6//+NmlxvpRpLwl4Nmoag3m3Yho/wo08wTTAfBgNVHSMEGDAWgBRzoYUmnPPjwFlc369eozVd+6nwXzAdBgNVHQ4EFgQUpjyF1IZKL7XAuM3ykXpHarMGM/cwCwYDVR0PBAQDAgeAMAoGCCqBHM9VAYN1A0kAMEYCIQDKIgCyaipH+yXV1ltfXuni3M5zy3PLuhFNUlEVJXlIGQIhAIQmQqL7NfzDUi4KpnMjghe+bHjqbcySCbvEUJEE1xTp",
  :ip              => "172.19.1.130",
  :port            => "13001",
	:appid           => "ae63fb953bc34f03b067fc6efe28fc32"
		    }


    config.fail_report_path = File.expand_path('../fail_reports', Rails.root).to_s
    config.attachment_path = File.expand_path('../attachments', Rails.root).to_s

    config.action_mailer.delivery_method = :sendmail
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true
    config.rack_cas.server_url = 'http://223.71.250.35'
  end
end
