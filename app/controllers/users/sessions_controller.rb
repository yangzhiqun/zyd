class Users::SessionsController < Devise::SessionsController
  layout 'session'

  before_filter :configure_sign_in_params, only: [:create]
  skip_before_action :check_user_info

  # GET /resource/sign_in
  def new
    @title = '登录'
=begin
	 cmd = `java -jar #{Rails.root.join('bin', 'mssg-sign-client-1.0.3-SNAPSHOT-clientAll.jar')} 123.56.20.192 9527 'bc333fe259054915bb40c6c206039389' 'GENRANDOM' 8  #{Rails.root.join('tmp', "random.txt")}`
	@random = File.read(Rails.root.join('tmp',"random.txt"))
	appid= 'bc333fe259054915bb40c6c206039389'
	type ='SIGNDATA'
	random_content =Base64.strict_encode64(@random.to_json)
	keyID= 'KEY_9c5aa23754d64399bf4674929654d55c'
 #服务器证书
  @serverCert = 'MIIBZzCCAQugAwIBAgIIaW57AZPf6sEwDAYIKoEcz1UBg3UFADAvMREwDwYDVQQDDAhiamNhdGVzdDENMAsGA1UECgwEYmpjYTELMAkGA1UEBhMCY24wHhcNMTYwOTE4MDY1MDEzWhcNMTcwOTE4MDc1MDEzWjAvMS0wKwYDVQQDDCRLRVlfOWM1YWEyMzc1NGQ2NDM5OWJmNDY3NDkyOTY1NGQ1NWMwWTATBgcqhkjOPQIBBggqgRzPVQGCLQNCAARWirtwnhBnifJiVFAAz9FPZl+9FvZB5jND6wvGI6vDCW1iqkezKwkU9+d5ZWhZqD0r1tVSdHQcoSQWC5hURKnxow8wDTALBgNVHQ8EBAMCB4AwDAYIKoEcz1UBg3UFAANIADBFAiEAhCC6J1qcldS/8FGvDVyeUXu/4pSx4y/LtWUeDVu6qtYCIHrPJBi6LkhfJLKd4mNmlADmgWh5NnTxMnnVVzQBCoJ9'
	filename =Rails.root.join('tmp', "filename.txt")
	 cmd = `java -jar #{Rails.root.join('bin', 'mssg-sign-client-1.0.3-SNAPSHOT-clientAll.jar')} 123.56.20.192 9527 #{appid} #{type} #{random_content} #{keyID}  #{@serverCert} #{filename}`
  @signedData =File.read(Rails.root.join('tmp','filename.txt'))
  logger.error "random"
    logger.error @random
=end
    if is_opne_ca
      @ca_login_info = Bjca::CaHelper.new.get_client_verify_random_info
    end
    super
  end

  # POST /resource/sign_in
  def create
    user = User.find_by_uid(params[:user][:uid])
    if user.present? and user.encrypted_password.blank? and User._authenticate(params[:user][:uid], params[:user][:password]).present?
      session[:update_user_id] = user.id
      redirect_to '/update-account'
    else
      # 通过新方法进行登录，并强制重置密码
      self.resource = warden.authenticate!(auth_options)
      set_flash_message(:notice, :signed_in) if is_flashing_format?
      sign_in(resource_name, resource)
      if(session[:change_js].blank?)
        if user.user_d_authority_5==1
          session[:change_js] = 11
        elsif user.jbxx_sh==1
          session[:change_js] = 16
        end
      end
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end

   #DELETE /resource/sign_out
   def destroy
    cookies.delete(:u, domain: '.cfda.pub')
		cookies.delete(:n, domain: '.cfda.pub')
		super
   end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.for(:sign_in) << :uid
  end
end
