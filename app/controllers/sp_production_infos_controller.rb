#encoding: utf-8
class SpProductionInfosController < ApplicationController
  def index
    @sp_production_infos = SpProductionInfo.paginate(:page => params[:page], :per_page => 50)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sp_production_infos }
    end
  end
  
  def new
    @sp_production_info = SpProductionInfo.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sp_production_info }
    end
  end
  
  # GET /sp_production_infos/1/edit
  def edit
    @sp_production_info = SpProductionInfo.find(params[:id])
  end
  
  # POST /sp_production_infos
  # POST /sp_production_infos.json
  def create
    @sp_production_info = SpProductionInfo.new(params[:sp_production_info])
    
    respond_to do |format|
      if @sp_production_info.save
        format.html { redirect_to "/sp_production_infos" }
        format.json { render json: @sp_production_info, status: :created, location: @sp_production_info }
      else
        format.html { render action: "new" }
        format.json { render json: @sp_production_info.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /sp_production_infos/1
  # PUT /sp_production_infos/1.json
  def update
    @sp_production_info = SpProductionInfo.find(params[:id])
    
    respond_to do |format|
      if @sp_production_info.update_attributes(params[:sp_production_info])
        format.html { redirect_to "/sp_production_infos" }
        format.json { head :no_content }
        else
        format.html { render action: "edit" }
        format.json { render json: @sp_production_info.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /sp_production_infos/1
  # DELETE /sp_production_infos/1.json
  def destroy
    @sp_production_info = SpProductionInfo.find(params[:id])
    @sp_production_info.destroy
    
    respond_to do |format|
      format.html { redirect_to sp_production_infos_url }
      format.json { head :no_content }
    end
  end

	def by_scxkz
		unless params[:scxkz].blank?
			@product = SpProductionInfo.find_by_scbh(params[:scxkz])
			if @product.nil?
				render :json => {status: 'ERR', msg: "未找到相应信息"}
			else
				render :json => {status: 'OK', msg: @product}
			end
		else
			render :json => {status: 'ERR', msg: "请提供参数scxkz"}
		end
	end

  def list
    respond_to do |format|
      if params[:qymc].blank?
        format.json { render :json => { :status => 'ERR', :msg => nil} }
      else
        @products = SpProductionInfo.select('id, cpmc, scbh').where(qymc: params[:qymc])
        format.json { render :json => { :status => 'OK', :msg => nil, :products => @products.map{|record| {:id => record.id, :title => "#{record.scbh}/#{record.cpmc}"}}} }
      end
    end
  end

  def company_list
    respond_to do |format|
      if params[:condition].blank?
        format.json { render :json => { :status => 'ERR', :msg => nil} }
      else
        @products = SpProductionInfo.select('id, cpmc, scbh, qymc').where(params[:condition])
        format.json { render :json => { :status => 'OK', :msg => nil, :products => @products.map{|record| {id: record.id, qymc: record.qymc, title:  "#{record.scbh}/#{record.cpmc}"}}} }
      end
    end
  end

end
