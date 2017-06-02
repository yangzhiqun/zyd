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
	:ca_auth_address => '60.247.77.101',
	:province        => "河北",
	:client_id       => "c8a47ee3aa4540dd3168f5151f3c1b754febe9dadf848895ef937eb04468302b",
	:client_secret   => "3999b84e37789216440f39882437a89499aded574f18c721a666eb1d08a6c1b0",
	:api_base        => "http://qzj.cfda.pub:8800/",
        :ip              => "61.178.55.42",
        :port            => "13001",
	:appid           => "932bae8aab4c4b279ff086bd0e321764",
        :ca_server_cert  => "MIIBwTCCAWagAwIBAgIJIBA0AAAAFX6sMAoGCCqBHM9VAYN1MD4xCzAJBgNVBAYMAkNOMQ0wCwYDVQQKDARCSkNBMQ8wDQYDVQQLDAZQRVJTT04xDzANBgNVBAMMBk1TU1BDQTAeFw0xNzAzMDYwNTA5MjZaFw0yMjAzMDYwNjA5MjZaMDwxCzAJBgNVBAYMAkNOMS0wKwYDVQQDDCRLRVlfODU2MTkxYjk0ODU3NDQ3ZmI4OGZkMDljYzQ4MzQyM2IwWTATBgcqhkjOPQIBBggqgRzPVQGCLQNCAAS5JKsfdSgnNJvH88CSYx6t/Wd0ZnT96yOE188F0xh7IH+eoK3DgE1wKRn6//+NmlxvpRpLwl4Nmoag3m3Yho/wo08wTTAfBgNVHSMEGDAWgBRzoYUmnPPjwFlc369eozVd+6nwXzAdBgNVHQ4EFgQUpjyF1IZKL7XAuM3ykXpHarMGM/cwCwYDVR0PBAQDAgeAMAoGCCqBHM9VAYN1A0kAMEYCIQDKIgCyaipH+yXV1ltfXuni3M5zy3PLuhFNUlEVJXlIGQIhAIQmQqL7NfzDUi4KpnMjghe+bHjqbcySCbvEUJEE1xTp"
		    }


    config.fail_report_path = File.expand_path('../fail_reports', Rails.root).to_s
    config.attachment_path = File.expand_path('../attachments', Rails.root).to_s

    config.action_mailer.delivery_method = :sendmail
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true
    config.rack_cas.server_url = 'http://gcsso.fsnip.com'
  end
end
