#encoding=UTF-8
class HzpBcDwsController < ApplicationController
  # GET /hzp_bc_dws
  # GET /hzp_bc_dws.json
  def index
      logger.debug "hello #{@page}"
      @hzp_bc_dws = HzpBcDw.paginate :page=>params[:page],:order=>'created_at desc',:per_page=> 10

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hzp_bc_dws }
    end
  end

  # GET /hzp_bc_dws/1
  # GET /hzp_bc_dws/1.json
  def show
    @hzp_bc_dw = HzpBcDw.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hzp_bc_dw }
    end
  end

  # GET /hzp_bc_dws/new
  # GET /hzp_bc_dws/new.json
  def new
    @hzp_bc_dw = HzpBcDw.new
    @myuser=session[:user_name]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hzp_bc_dw }
    end
  end

  # GET /hzp_bc_dws/1/edit
  def edit
    @hzp_bc_dw = HzpBcDw.find(params[:id])
  end

  # POST /hzp_bc_dws
  # POST /hzp_bc_dws.json
  def create
      #hzp_bc_dw=params[:hzp_bc_dw]
      #if hzp_bc_dw[:dwlx]=='其他'
      #hzp_bc_dw[:dwlx]=params[:text11]
    
      #end
    @hzp_bc_dw = HzpBcDw.new(params[:hzp_bc_dw])

    respond_to do |format|
        
        
        
      if @hzp_bc_dw.save
        format.html { redirect_to new_hzp_bc_dw_path, notice: 'Hzp bc dw was successfully created.' }
        format.json { render json: @hzp_bc_dw, status: :created, location: @hzp_bc_dw }
      else
        format.html { render action: "new" }
        format.json { render json: @hzp_bc_dw.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hzp_bc_dws/1
  # PUT /hzp_bc_dws/1.json
  def update
    @hzp_bc_dw = HzpBcDw.find(params[:id])

    respond_to do |format|
      if @hzp_bc_dw.update_attributes(params[:hzp_bc_dw])
        format.html { redirect_to @hzp_bc_dw, notice: 'Hzp bc dw was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @hzp_bc_dw.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hzp_bc_dws/1
  # DELETE /hzp_bc_dws/1.json
  def destroy
    @hzp_bc_dw = HzpBcDw.find(params[:id])
    @hzp_bc_dw.destroy

    respond_to do |format|
      format.html { redirect_to hzp_bc_dws_url }
      format.json { head :no_content }
    end
  end
end
