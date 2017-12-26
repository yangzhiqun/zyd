class SysProvincesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:prov, :prov_data]

  # GET /sys_provinces
  # GET /sys_provinces.json
  def index
    @sys_provinces = SysProvince.level1_old.order('code ASC')
    unless current_user.is_super?
      @sys_provinces = @sys_provinces.where('name = ?',current_user.user_s_province)
    end
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

  def prov
    begin
      if params[:prov].present?
        prov = SysProvince.find(params[:prov])
        @provinces = SysProvince.where('level LIKE ? OR level LIKE ?', "#{prov.level}._", "#{prov.level}.__")
      end

      if params[:city].present?
        prov = SysProvince.find_by_id(params[:city])
        @provinces = SysProvince.where('level LIKE ? OR level LIKE ?', "#{prov.level}._", "#{prov.level}.__")
      end

      render json: {status: 'OK', msg: (@provinces.select('name, id') if @provinces)}
    rescue
      render json: {status: 'OK', msg: []}
    end
  end

  def update_prov
    if params[:level].blank?
      render json: {status: 'ERR', msg: '请提供level'}
    else
      prov = SysProvince.find_by_level(params[:level])
      prov.name = params[:name]
      prov.fullname = params[:fullname]
      if prov.save
        render json: {status: 'OK', msg: '更新成功'}
      else
        render json: {status: 'ERR', msg: prov.errors.first.last}
      end
    end
  end

  def create_prov
    prov = SysProvince.new(name: params[:name], fullname: params[:fullname])
    prov.generate_level(params[:parent_level])

    if prov.save
      render json: {status: 'OK', msg: '创建成功'}
    else
      render json: {status: 'ERR', msg: prov.errors.first.last}
    end
  end

  def sub_provs
    if params[:level].blank?
      render json: {stauts: 'ERR', msg: 'level不可为空'}
    else
      provs = SysProvince.where('level like ? or level like ?', "#{params[:level]}._", "#{params[:level]}.__")
      render json: {status: 'OK', msg: '', provs: provs.select('fullname, name, id, level')}
    end
  end

  # 获取省份信息
  def prov_data
    @prov_data = Rails.cache.fetch('prov_data', expires_in: 12.hours) do
      level1 = SysProvince.level1_old.order('code asc').map { |lvl1| [lvl1.name, lvl1.level] }
      level2 = []
      level1.each do |lvl1|
        level2.push SysProvince.order('code asc').where('level LIKE ? OR level LIKE ?', "#{lvl1[1]}._", "#{lvl1[1]}.__").map { |lvl2| [lvl2.name, lvl2.level] }
      end
      level3 = []
      level2.each do |lvl2s|
        lvl = []
        lvl2s.each do |lvl2|
          lvl.push SysProvince.order('code asc').where('level LIKE ? OR level LIKE ?', "#{lvl2[1]}._", "#{lvl2[1]}.__").map { |lvl3| [lvl3.name, lvl3.level] }
        end
        level3.push(lvl)
      end
      {lvl1: level1, lvl2: level2, lvl3: level3}
    end
    render json: {status: 'OK', msg: 'OK', prov_data: @prov_data}
  end

  def new_prov_data
    if is_sheng?   
      level = SysProvince.find_by_name(current_user.user_s_province).level
      @prov_arr = SysProvince.where("level like '#{level}._' or level like '#{level}.__'").pluck(:name)
    elsif is_city? 
      level = SysProvince.find_by_name(current_user.prov_city).level
      @prov_arr = SysProvince.where("level like '#{level}._' or level like '#{level}.__'").pluck(:name)
    else
      @prov_arr = ["#{current_user.prov_country}"]
    end
    render json: {status: 'OK', msg: 'OK', prov_data: @prov_arr}
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
