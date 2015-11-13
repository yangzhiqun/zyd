class SysProvincesController < ApplicationController
  # GET /sys_provinces
  # GET /sys_provinces.json
  def index
    @sys_provinces = SysProvince.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sys_provinces }
    end
  end

  # GET /sys_provinces/1
  # GET /sys_provinces/1.json
  def show
    @sys_province = SysProvince.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sys_province }
    end
  end

  # GET /sys_provinces/new
  # GET /sys_provinces/new.json
  def new
    @sys_province = SysProvince.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sys_province }
    end
  end

  # GET /sys_provinces/1/edit
  def edit
    @sys_province = SysProvince.find(params[:id])
  end

  # POST /sys_provinces
  # POST /sys_provinces.json
  def create
    @sys_province = SysProvince.new(params[:sys_province])

    respond_to do |format|
      if @sys_province.save
        format.html { redirect_to @sys_province, notice: 'Sys province was successfully created.' }
        format.json { render json: @sys_province, status: :created, location: @sys_province }
      else
        format.html { render action: "new" }
        format.json { render json: @sys_province.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sys_provinces/1
  # PUT /sys_provinces/1.json
  def update
    @sys_province = SysProvince.find(params[:id])

    respond_to do |format|
      if @sys_province.update_attributes(params[:sys_province])
        format.html { redirect_to @sys_province, notice: 'Sys province was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sys_province.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sys_provinces/1
  # DELETE /sys_provinces/1.json
  def destroy
    @sys_province = SysProvince.find(params[:id])
    @sys_province.destroy

    respond_to do |format|
      format.html { redirect_to sys_provinces_url }
      format.json { head :no_content }
    end
  end
end
