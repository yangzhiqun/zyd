class Api::V3::UserController < ApplicationController
  skip_before_filter :session_expiry, :verify_authenticity_token, :authenticate_user!

	def login
		user = User.find_by_uid(params[:username])
		if user.present?
			if user.valid_password?(params[:password])
				user.request_token

				render json: {status: 0, msg: '', data: {
					uid: user.uid, 
					name: user.tname,
					mobile: user.mobile,
					jg_name: user.jg_bsb.jg_name,
					jg_address: user.jg_bsb.jg_address,
					jg_contact: user.jg_bsb.jg_contacts,
					jg_mobile: user.jg_bsb.jg_tel,
					jg_fax: user.jg_bsb.fax,
					jg_zipcode: user.jg_bsb.zipcode,
					id_card: user.id_card,
					access_token: user.token,
					valid_to: user.valid_to.to_i
				}}
			else
				render json: {status: 1, msg: 'account not exists or password error'}
			end
		else
			render json: {status: 1, msg: 'account not exists or password error'}
		end
	end
end
