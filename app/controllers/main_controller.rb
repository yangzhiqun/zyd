#encoding: utf-8
class MainController < ApplicationController

  def index
  end

	def welcome
		if !session[:change_js].blank? and session[:change_js] == 3
			@files = Dir.glob(Rails.root.join("welcome2", "files", "*").to_s)
			@files.select! { |file| file.include? current_user.user_s_province }
		end
	end

	def file
		if params[:name].include? current_user.user_s_province and session[:change_js] == 3
			send_file Rails.root.join("welcome2", 'files', "#{params[:name]}.xlsx")
		end
	end
end
