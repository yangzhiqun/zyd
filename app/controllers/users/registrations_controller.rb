class Users::RegistrationsController < Devise::RegistrationsController
  layout 'blank'
  before_filter :configure_sign_up_params, only: [:create]
  before_filter :configure_account_update_params, only: [:update]

# GET /resource/sign_up
# def new
#   super
# end

  # POST /resource
  def create
    build_resource(sign_up_params)
    if resource.is_signup_sms_code_available?
      super
    else
      respond_to do |format|
        format.json { render json: {status: 'OK'}}
        format.html {
          respond_with resource
        }
      end
    end
  end

# GET /resource/edit
# def edit
#   super
# end

# PUT /resource
# def update
#   super
# end

# DELETE /resource
# def destroy
#   super
# end

# GET /resource/cancel
# Forces the session data which is usually expired after sign
# in to be expired now. This is useful if the user wants to
# cancel oauth signing in/up in the middle of the process,
# removing all OAuth session data.
# def cancel
#   super
# end

# protected

# If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) << [:prov_city, :jg_bsb_id, :user_s_province, :id_card, :sms_code, :mobile, :name, :function_type, :password, :password_confirmation]
  end

# If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.for(:account_update) << [:user_s_province, :id_card, :sms_code, :mobile, :name, :function_type, :password, :password_confirmation]
  end

# The path used after sign up.
# def after_sign_up_path_for(resource)
#   super(resource)
# end

# The path used after sign up for inactive accounts.
# def after_inactive_sign_up_path_for(resource)
#   super(resource)
# end
end
