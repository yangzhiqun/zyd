class SysConfig < ActiveRecord::Base
  module Key
    LOGO = 'logo'
    PROV = 'province'
    SITE_NAME = 'sitename'
    IS_EJZ = 'IS-EJZ'
    CLIENT_ID = 'client_id'
    CLIENT_SECRET = 'client_secret'
    CA_LOGIN = 'CA-LOGIN'
    CA_AUTH_SERVER = 'CA-AUTH-SERVER'
    CA_PDF_SERVER = 'CA-PDF-SERVER'
  end

  def self.get(key, default='')
    config = SysConfig.find_by_key(key)
    return default if config.nil?
    config.value
  end

  def self.put(key, value)
    config = SysConfig.where(key: key).first_or_initialize
    config.value = value
    config.save
  end
end
