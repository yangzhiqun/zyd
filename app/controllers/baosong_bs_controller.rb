#encoding: utf-8
class BaosongBsController < ApplicationController
  include ApplicationHelper
  # GET /baosong_bs
  # GET /baosong_bs.json
  def index
    @baosong_bs = BaosongB.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @baosong_bs }
    end
  end
  def baosong_bs_by_name
    @baosong_a = BaosongA.find_by_name(params[:a_name])
    respond_to do |format|
     # if current_user.is_admin?
        format.json { render json: {status: "OK", msg: "", data: @baosong_a.baosong_bs.select("id, name, identifier")} }
     # else
      #  format.json { render json: {status: "OK", msg: "", data: @baosong_a.baosong_bs.where("prov = ? OR prov IS NULL OR prov = ''", current_user.user_s_province).select("id, name, identifier")} }
       # format.json { render json: {status: "OK", msg: "", data: @baosong_a.baosong_bs.select("id, name, identifier")} }
     # end
    end
  end
  ###新增根据任务来源判断报送分类a
  def baosong_bs_by_rwly
    #根据名称获取机构名称所有信息。
    #@jg_bsb_names = JgBsbName.where("name = ?",params[:a_name]).last
    #@jg_bsbs = JgBsb.find_by_id(@jg_bsb_names.jg_bsb_id)
    #if (!@jg_bsbs.city.blank? or @jg_bsbs.city != "-请选择-") and  (@jg_bsbs.country.blank? or @jg_bsbs.country == "-请选择-")
    #  @baosong_a = BaosongA.where("shi = ?",@jg_bsbs.city)
    #elsif (!@jg_bsbs.city.blank? or @jg_bsbs.city != "-请选择-") and  (!@jg_bsbs.country.blank? or @jg_bsbs.country != "-请选择-")
    #  @baosong_a = BaosongA.where("xian = ?",@jg_bsbs.country)
    #end
    @jg_bsb_names = JgBsbName.where("name = ?",params[:a_name]).last
    @baosong_a_jg = BaosongAJgId.where("jg_bsb_id = ?" ,@jg_bsb_names.jg_bsb_id)
    baosongids = []
    if !@baosong_a_jg.blank?
      @baosong_a_jg.each do |baosong|
        baosongids.push(baosong.baosong_a_id)
      end
    end
    @baosong_a = BaosongA.where("id in (?)",baosongids)
    # if  is_county_level? or is_city?
      respond_to do |format|
        format.json { render json: {status: "OK", msg: "", data: @baosong_a.select("id, name")} }
      end
   # else
   #   @baosong_a = BaosongA.all
   #   logger.error @baosong_a.to_json
    #  respond_to do |format|
   #     format.json { render json: {status: "OK", msg: "", data: @baosong_a.select("id,name")} }
   #   end
   # end
  end
  def baosong_bs_by_cityname
    @baosong_a = BaosongA.find_by_name(params[:a_name])
    @jgBsb = JgBsb.find_by_id(current_user.jg_bsb_id)
    info=[]
    info2=[]
    if !@jgBsb.nil? and !@jgBsb.blank?
      if !@jgBsb.city.nil? and !@jgBsb.city.blank? and !@jgBsb.city.include?("请选择")
        info<<@jgBsb.city
        info2<<@jgBsb.city
      end
    end
    #@superjgBsb = JgBsbSuper.find_by_jg_bsb_id(current_user.jg_bsb_id).groupBy("super_jg_bsb_id")
    @superjgBsb = JgBsbSuper.find_by_sql(["select super_jg_bsb_id from jg_bsb_supers where jg_bsb_id =? group by super_jg_bsb_id",current_user.jg_bsb_id])
    data=[]
    @superjgBsb.each_with_index do |da,n|
      data<<da.super_jg_bsb_id
    end
    info1 = [] #存储上级是否到市级
    info3 = [] #存储上级是否是省
    data.each do |daa|
      @jgBsb_info = JgBsb.find_by_id(daa)
      if !@jgBsb_info.nil? and !@jgBsb_info.blank?
        if !@jgBsb_info.city.nil? and !@jgBsb_info.city.blank? and !@jgBsb_info.city.include?("请选择")
          info<<@jgBsb_info.city
          info1<<@jgBsb_info.city
        end
        if !@jgBsb_info.jg_province.nil? and !@jgBsb_info.jg_province.blank? and !@jgBsb_info.jg_province.include?("请选择")
          info3<<@jgBsb_info.jg_province
        end
      end
    end
    respond_to do |format|
      if current_user.is_admin?
        format.json { render json: {status: "OK", msg: "", data: @baosong_a.baosong_bs.select("id, name, identifier")} }
      else
        # format.json { render json: {status: "OK", msg: "", data: @baosong_a.baosong_bs.where("prov = ? OR prov IS NULL OR prov = ''", current_user.user_s_province).select("id, name, identifier")} }
        if info.length == 0 or (info.length > 0 and info1.length == 0 and info2.length == 0) or (info.length > 0 and info2.length == 0) or (info.length > 0 and info1.length ==0 and info2.length > 0 and info3.length > 0)
          format.json { render json: {status: "OK", msg: "", data: @baosong_a.baosong_bs.select("id, name, identifier")} }
        else
          format.json { render json: {status: "OK", msg: "", data: @baosong_a.baosong_bs.where("prov in (?) or prov = '省级任务'",info).select("id, name, identifier")} }
        end
      end
    end
  end


  # GET /baosong_bs/1
  # GET /baosong_bs/1.json
  def show
    @baosong_b = BaosongB.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @baosong_b }
    end
  end

  # GET /baosong_bs/new
  # GET /baosong_bs/new.json
  def new
    @baosong_b = BaosongB.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @baosong_b }
    end
  end

  # GET /baosong_bs/1/edit
  def edit
    @baosong_b = BaosongB.find(params[:id])
  end

  # POST /baosong_bs
  # POST /baosong_bs.json
  def create
    @baosong_b = BaosongB.new(baosong_b_params)

    respond_to do |format|
      if baosong_b_params["file"].nil?
        format.html { redirect_to :back, notice: "Excel源文件不可为空" }
      else
        if @baosong_b.save
          format.html { redirect_to :back, notice: '创建成功' }
          format.json { render json: @baosong_b, status: :created, location: @baosong_b }
        else
          format.html { redirect_to :back, notice: @baosong_b.errors.first.last }
          format.json { render json: @baosong_b.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /baosong_bs/1
  # PUT /baosong_bs/1.json
  def update
    @baosong_b = BaosongB.find(params[:id])
   logger.error @baosong_b.to_json
    respond_to do |format|
      if @baosong_b.update_attributes(baosong_b_params)
        format.html { redirect_to @baosong_b, notice: 'Baosong b was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @baosong_b.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /baosong_bs/1
  # DELETE /baosong_bs/1.json
  def destroy
    @baosong_b = BaosongB.find(params[:id])
    @baosong_b.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  def categories
    @baosong_b = BaosongB.find(params[:id])

    case params[:type]
      when 'a_category_id'
        @categories = BCategory.where(enable: true, identifier: @baosong_b.identifier, a_category_id: params[:a_category_id])
      when 'b_category_id'
        @categories = CCategory.where(enable: true, identifier: @baosong_b.identifier, b_category_id: params[:b_category_id])
      when 'c_category_id'
        @categories = DCategory.where(enable: true, identifier: @baosong_b.identifier, c_category_id: params[:c_category_id])
      else
        @categories = ACategory.where(enable: true, identifier: @baosong_b.identifier)
    end

    respond_to do |format|
      format.json { render json: {status: 'OK', msg: @categories} }
    end
  end

  def baosong_b_params
    params.require(:baosong_b).permit(:baosong_a_id, :name, :note, :identifier, :file, :prov,:genxin)
  end
end
