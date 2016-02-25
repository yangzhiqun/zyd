class Users::SessionsController < Devise::SessionsController
  layout 'session'

  before_filter :configure_sign_in_params, only: [:create]
  skip_before_action :check_user_info

  # GET /resource/sign_in
  def new
    @title = '登录'
    super
  end

  # POST /resource/sign_in
  def create
    user = User.find_by_name(params[:user][:uid])
    if user.present? and user.encrypted_password.blank? and User._authenticate(params[:user][:uid], params[:user][:password]).present?
      session[:update_user_id] = user.id
      redirect_to '/update-account'
    else
      # 通过新方法进行登录，并强制重置密码
      self.resource = warden.authenticate!(auth_options)
      set_flash_message(:notice, :signed_in) if is_flashing_format?
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.for(:sign_in) << :uid
  end
end
