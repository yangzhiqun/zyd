#encoding=UTF-8
class WtypCzbsController < ApplicationController
  require 'RMagick'
  include ApplicationHelper
	
	# 错误码
  module ErrorCode
    None = 0
    DataSaveError = 40001
    ParamsParseError = 40002
    FatalError = 40003
    ParamsMissingError = 40004
  end

  skip_before_filter :session_expiry, :verify_authenticity_token
  before_filter :authorize, :except => [:picture, :transfer]
  skip_before_action :authenticate_user!

  before_filter :doorkeeper_authorize!, :only => [:transfer]

	def transfer

		respond_to do |format|
      ActiveRecord::Base.transaction do
				begin
          if params[:data].blank?
            format.json { render :json => {:errorcode => ErrorCode::ParamsParseError, :errormsg => '请提供data参数'} }
            return
          end

          if params[:data].class.to_s.eql?("String")
            @data = JSON.parse(params[:data], :symbolize_names => true)
          else
            @data = params[:data]
          end
					
					@data.each do |wtyp|
						wtyp = WtypCzb.new(wtyp[:jbxx])

						# 保存核查处置基本信息
						if wtyp.save

							# 保存不合格的检验数据
							wtyp[:items].each do |item|
								itemone = SpHczSpdata.new(item)
                itemone.wtyp_czb_id = wtyp.id
                if itemone.save
                else
                  format.json { render :json => {:errorcode => ErrorCode::DataSaveError, :msg => itemone.errors.first.last } }
                  raise ActiveRecord::Rollback
                end
							end

							# 保存生产
							sc = WtypCzbPart.new(wtyp[:sc])
							sc.wtyp_czb_type = 1
              sc.wtyp_czb_id = wtyp.id
							if sc.save
							else
								format.json { render :json => {:errorcode => ErrorCode::DataSaveError, :msg => sc.errors.first.last } }
								raise ActiveRecord::Rollback
							end

							# 保存流通
							lt = WtypCzbPart.new(wtyp[:lt])
							lt.wtyp_czb_type = 2
              lt.wtyp_czb_id = wtyp.id
							if lt.save
							else
								format.json { render :json => {:errorcode => ErrorCode::DataSaveError, :msg => lt.errors.first.last } }
								raise ActiveRecord::Rollback
							end
						else
							# TODO ...
						end
					end
				rescue Exception => e
					format.json { render :json => {:errorcode => ErrorCode::FatalError, :msg => '未知错误', :exception => e.class.to_s} }
				end
			end
		end
	end

  private
  def authorize
    if params[:userCert].present?
			@ca_helper = Bjca::CaHelper.new
      response_code = @ca_helper.validate_cert(params[:userCert])

      if response_code == 1
        sfid = @ca_helper.get_cert_info_by_oid(params[:userCert])
        @user = User.find_by_id_card(sfid)

        if @user.nil?
          format.json { render :json => {status: 'ERR', msg: '该用户未在系统中登记，请在电脑上登录系统绑定您的KEY', key: sfid, code: 444} }
          return
        end

      else
        format.json { render :json => {status: 'ERR', msg: ValidateCertCode::ResponseCode["code:#{response_code}"]} }
        return
      end
    else
      if !(params[:username].blank? or params[:password].blank?)
        @user = User.where(uid: params[:username]).last
        if @user.blank? or !@user.valid_password?(params[:password])
          respond_to do |format|
            format.json {
              render :json => {:status => 'ERR', :msg => '非法访问'}
              return
            }
          end
        end
      else
      #  respond_to do |format|
       #   format.json {
        #    render :json => {:status => 'ERR', :msg => '参数无效'}
         #   return
        #  }
       # end
      end
    end
  end
end
