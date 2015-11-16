#encoding: utf-8
class CompanyStandardsController < ApplicationController
  include ApplicationHelper

  before_filter :require_authorization

  # GET /company_standards
  # GET /company_standards.json
  def index
    @company_standards = CompanyStandard.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @company_standards }
    end
  end

  # GET /company_standards/1
  # GET /company_standards/1.json
  def show
    @company_standard = CompanyStandard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @company_standard }
    end
  end

  # GET /company_standards/new
  # GET /company_standards/new.json
  def new
    @company_standard = CompanyStandard.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @company_standard }
    end
  end

  # GET /company_standards/1/edit
  def edit
    @company_standard = CompanyStandard.find(params[:id])
    
    if !current_user.is_admin?
      return not_found if @company_standard.user_id != current_user.id
    end
  end

  # POST /company_standards
  # POST /company_standards.json
  def create
    @company_standard = CompanyStandard.new(company_standard_params)
    @company_standard.user_id = current_user.id

    respond_to do |format|
      if @company_standard.save
        format.html { redirect_to @company_standard, notice: '创建成功！' }
        format.json { render json: @company_standard, status: :created, location: @company_standard }
      else
        format.html { render action: "new" }
        format.json { render json: @company_standard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /company_standards/1
  # PUT /company_standards/1.json
  def update
    @company_standard = CompanyStandard.find(params[:id])
    if !current_user.is_admin?
      return not_found if @company_standard.user_id != current_user.id
    end

    respond_to do |format|
      if @company_standard.update_attributes(company_standard_params)
        format.html { redirect_to @company_standard, notice: '更新成功！' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @company_standard.errors, status: :unprocessable_entity }
      end
    end
  end

  def attachment
    @standard = CompanyStandard.find(params[:id])
    send_file("#{@standard.attachment_path_file}", :filename => "#{@standard.name}#{File.extname(@standard.attachment_path)}", :disposition => 'inline')
  end

  # DELETE /company_standards/1
  # DELETE /company_standards/1.json
  def destroy
    @company_standard = CompanyStandard.find(params[:id])

    if !current_user.is_admin?
      return not_found if @company_standard.user_id != current_user.id
    end

    @company_standard.destroy

    respond_to do |format|
      format.html { redirect_to company_standards_url }
      format.json { head :no_content }
    end
  end

  private
  def require_authorization
    return not_found if current_user.nil?
  end

  def company_standard_params
    params.require(:company_standard).permit(:attachment_id, :author_company, :name, :number, :valid_at, :user_id, :attachment_path_file)
  end
end
