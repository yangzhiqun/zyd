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
        :enable_ca_login => false, 
	:is_ejz          => true,
	:is_qzj          => false,
	:province        => "河北",
	:client_id       => "c8a47ee3aa4540dd3168f5151f3c1b754febe9dadf848895ef937eb04468302b",
	:client_secret   => "3999b84e37789216440f39882437a89499aded574f18c721a666eb1d08a6c1b0",
	:api_base        => "http://qzj.cfda.pub"
	    }

    config.fail_report_path = File.expand_path('../fail_reports', Rails.root).to_s
    config.attachment_path = File.expand_path('../attachments', Rails.root).to_s

    config.action_mailer.delivery_method = :sendmail
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true
  end
end
