#encoding: utf-8
class WelcomeNoticesController < ApplicationController

 include ApplicationHelper

  # GET /welcome_notices
  # GET /welcome_notices.json
  def index
    @welcome_notices = WelcomeNotice.order("top desc, updated_at desc")
    @sp_bsbs,@ending_time,@begin_time = SpBsb.search({},session[:change_js],current_user,is_sheng?,is_city?,is_county_level?,is_shengshi?,all_super_departments,"spsearch")
    @sp_bsbs = @sp_bsbs.where(bgfl:"24小时限时报告").length
    @sum,@complete,@complete_id,@report_for_24,@report_for_24_id,@unqualified,@unqualified_id,@unqualified_for_today,@unqualified_for_today_id,@complete_for_today,@complete_for_today_id = SpBsb.statistics
    @info,@info2,@info3 = SpBsb.unqualified_for_bcydw(params[:name],params[:cydh])
    @data = SpBsb.warning_map_data.to_json
   if params[:name]
     render json: {info: @info,info2:@info2,info3:@info3,data: @data}
   end
   if params[:cydh]
     render json: {info3:@info3}
   end
  end

  # GET /welcome_notices/1
  # GET /welcome_notices/1.json
  def show
    @welcome_notice = WelcomeNotice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @welcome_notice }
    end
  end

  # GET /welcome_notices/new
  # GET /welcome_notices/new.json
  def new
    @welcome_notice = WelcomeNotice.new
    if !current_user.is_admin?
      return not_found
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @welcome_notice }
    end
  end

  # GET /welcome_notices/1/edit
  def edit
    @welcome_notice = WelcomeNotice.find(params[:id])
    if !current_user.is_admin?
      return not_found
    end
  end

  # POST /welcome_notices
  # POST /welcome_notices.json
  def create
    #@welcome_notice = WelcomeNotice.new(params[:welcome_notice])
    @welcome_notice = WelcomeNotice.new(welcome_notice_params)

    respond_to do |format|
      if @welcome_notice.save
        format.html { redirect_to @welcome_notice, notice: '创建成功！' }
        format.json { render json: @welcome_notice, status: :created, location: @welcome_notice }
      else
        format.html { render action: "new" }
        format.json { render json: @welcome_notice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /welcome_notices/1
  # PUT /welcome_notices/1.json
  def update
    @welcome_notice = WelcomeNotice.find(params[:id])

    respond_to do |format|
      if @welcome_notice.update_attributes(params[:welcome_notice])
        format.html { redirect_to @welcome_notice, notice: 'Welcome notice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @welcome_notice.errors, status: :unprocessable_entity }
      end
    end
  end

  def attachment
    @standard = WelcomeNotice.find(params[:id])
    send_file("#{@standard.attachment_path_file}", :filename => "#{@standard.title}#{File.extname(@standard.attachment_path)}", :disposition => 'inline')
  end

  # DELETE /welcome_notices/1
  # DELETE /welcome_notices/1.json
  def destroy
    @welcome_notice = WelcomeNotice.find(params[:id])
    if !current_user.is_admin?
      return not_found
    end
    @welcome_notice.destroy

    respond_to do |format|
      format.html { redirect_to welcome_notices_url }
      format.json { head :no_content }
    end
  end
  private
    def welcome_notice_params
      params.require(:welcome_notice).permit(:attachment_path_file, :red, :title, :top, :url)
    end
end
