#encoding=UTF-8
#---
# Excerpted from "Agile Web Development with Rails, 3rd Ed.",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails3 for more book information.
#---
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.


class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_filter :authorize, :except => [:login, :bind_ca_key]

  before_filter :session_expiry, :except => [:login, :ca_login, :logout, :timeout, :bind_ca_key]
  before_filter :update_activity_time, :except => [:login, :logout, :ca_login, :bind_ca_key]

  before_filter :check_user_info_completeness, :except => [:login, :bind_ca_key, :complete_user_info]

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => '8fc080370e56e929a2d5afca5540a0f7'

  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  protected

  def check_user_info_completeness
    if !current_user.nil? and !current_user.is_info_complete?
      #Rails.logger.error "FFFFFF"
      redirect_to '/complete_user_info'
      return
    end
  end

  def authorize
    #logger.debug "authorize#{Time.now}\nhello#{Time.now}\nhello#{Time.now}\nhello#{Time.now}\n"
    unless User.find_by_id(session[:user_id])
      flash[:notice] = "Please log in"
      redirect_to :controller => 'admin', :action => 'login'
    end
  end
end

def session_expiry

  #logger.debug "session_expiry#{Time.now}\nhello#{Time.now}\nhello#{Time.now}\nhello#{Time.now}\n"
  @time_left = session[:expires_at].to_i - Time.now.to_i

  unless @time_left > 0
    reset_session
    flash[:error] = '连接超时.'
    # render :js => parent.location.reload();
    # redirect_to(:controller => 'main',:action => 're')
    redirect_to "/users/timeout"
  end
end

def update_activity_time
  #logger.debug "update_activity_time#{Time.now}\nhello#{Time.now}\nhello#{Time.now}\nhello#{Time.now}\n"
  session[:expires_at] = 3.hour.from_now.to_i
end
