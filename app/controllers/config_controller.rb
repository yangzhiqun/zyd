class ConfigController < ApplicationController

  skip_before_action :authenticate_user!, only: [:site_logo]

  layout 'blank'
  # 用户检索表单虚拟类
  class SiteConfig
    include ActiveModel::Model
    include Virtus.model

    validates_presence_of :site_name, message: '请填写站点名称'
    validates_presence_of :prov, message: '请选择站点省份'

    attribute :site_name, String
    attribute :prov, String
    attribute :logo_path, String
    attribute :ca_login, Integer, default: 0
    attribute :ca_auth_server, String
    attribute :ca_pdf_server, String
    attribute :is_ejz, Integer, default: 1

    def attachments_dir(folder)
      "#{Rails.application.config.attachment_path}/#{folder}"
    end

    def handle_uploaded_file(folder_name, file)
      path = "#{folder_name}/#{Time.now.strftime("%Y/%m/%d")}"
      target_folder = self.attachments_dir("#{path}")

      md5 = Digest::MD5.file(file.path).hexdigest.upcase
      extname = File.extname(file.original_filename)

      FileUtils.mkdir_p "#{target_folder}" unless Dir.exists? "#{target_folder}"
      FileUtils.mv(file.path, "#{target_folder}/#{md5}#{extname}")

      "#{path}/#{md5}#{extname}"
    end

    def logo_file=(f)
      path = handle_uploaded_file('logos', f)
      if !f.blank? and path.present?
        self.logo_path = path
      end
    end

    def logo_file
      Rails.application.config.attachment_path + '/' + self.logo_path unless self.logo_path.blank?
    end

    def save
      return false unless self.valid?
      SysConfig.put(SysConfig::Key::PROV, self.prov) \
      and SysConfig.put(SysConfig::Key::SITE_NAME, self.site_name) \
      and SysConfig.put(SysConfig::Key::LOGO, self.logo_path) \
      and SysConfig.put(SysConfig::Key::CA_LOGIN, self.ca_login) \
      and SysConfig.put(SysConfig::Key::CA_AUTH_SERVER, self.ca_auth_server) \
      and SysConfig.put(SysConfig::Key::CA_PDF_SERVER, self.ca_pdf_server) \
      and SysConfig.put(SysConfig::Key::IS_EJZ, self.is_ejz)
    end
  end

  def init_site
    @title = '报送平台初始化'
    if request.post?
      @config = SiteConfig.new(params.require(:config_controller_site_config).permit(:site_name, :prov, :logo_file, :ca_login, :ca_auth_server, :ca_pdf_server, :client_id, :client_secret))
      @config.save
    elsif request.get?
      @config = SiteConfig.new
    end
  end

  # 网站LOGO图
  def site_logo
    filepath = Rails.application.config.attachment_path + '/' + SysConfig.get(SysConfig::Key::LOGO)
    if File.exists?(filepath)
      send_file filepath, filename: '站点LOGO', disposition: 'inline'
    end
  end
end
