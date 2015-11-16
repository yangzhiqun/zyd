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
      if current_user.is_admin?
        format.json { render json: {status: "OK", msg: "", data: @baosong_a.baosong_bs.select("id, name, identifier")} }
      else
        format.json { render json: {status: "OK", msg: "", data: @baosong_a.baosong_bs.where("prov = ? OR prov IS NULL OR prov = ''", current_user.user_s_province).select("id, name, identifier")} }
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
    params.require(:baosong_b).permit(:baosong_a_id, :name, :note, :identifier, :file, :prov)
  end
end
