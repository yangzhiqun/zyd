#encoding: utf-8
class BaosongBsNewestsController < ApplicationController
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

  # GET /baosong_bs_newests/1/edit
  def edit
    @baosong_b = BaosongB.find(params[:id])
  end

  # POST /baosong_bs
  # POST /baosong_bs.json
  def create
    @baosong_b = BaosongB.new(baosong_b_params)
		@baosong_b.identifier = @baosong_b.generate_identifier

    respond_to do |format|
      if @baosong_b.save
        format.html { redirect_to :back, notice: '创建成功' }
        format.json { render json: @baosong_b, status: :created, location: @baosong_b }
      else
        format.html { redirect_to :back, notice: @baosong_b.errors.first.last }
        format.json { render json: @baosong_b.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /baosong_bs/1
  # PUT /baosong_bs/1.json
  def update
    @baosong_b = BaosongB.find(params[:id])

    respond_to do |format|
      if @baosong_b.update_attributes(baosong_b_params)
        format.html { redirect_to "/baosong_bs_newests/#{@baosong_b.id}", notice: 'Baosong b was successfully updated.' }
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
    case params[:type]
      when 'a_category_id'
        @categories = StandardBCategorie.where(standard_a_category_id: params[:a_category_id])
      when 'b_category_id'
        @categories = StandardCCategorie.where(standard_b_category_id: params[:b_category_id])
      when 'c_category_id'
        @categories = StandardDCategorie.where(standard_c_category_id: params[:c_category_id])
      else
        @categories = StandardACategorie.all
    end

    respond_to do |format|
      format.json { render json: {status: 'OK', msg: @categories} }
    end
  end

  def check_items
    @check_items = StandardCheckItem.where(:standard_d_category_id => params[:d_category_id], enable: true)
    render json: {status: "OK", msg: "", items: @check_items}
  end

  def baosong_b_params
    params.require(:baosong_b).permit(:baosong_a_id, :name, :note, :identifier, :file, :prov)
  end
end
