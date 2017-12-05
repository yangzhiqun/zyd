class ReportFormsController < ApplicationController
  def index
    @report_form = current_user.report_form
    respond_to do |format|
      format.html
      format.json { render json: @report_forms }
    end
  end

  def update
    @report_form = current_user.report_form
    if @report_form.nil?
      @report_form = ReportForm.new(user_id:current_user.id) 
    end
    @report_form.spbsb_field = params["spbsb"]
    @report_form.spdata_field = params["spdata"]
    respond_to do |format|
      if @report_form.save
        flash[:notice] = "保存成功"
        format.html { redirect_to action: "index"}
      else
        flash[:notice] = "保存失败"
        format.html { redirect_to :back}
      end
    end
  end
end
