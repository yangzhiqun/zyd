#encoding=UTF-8
class HzpYpbsController < ApplicationController
  # GET /hzp_ypbs
  # GET /hzp_ypbs.json
  def index
    @hzp_ypbs = HzpYpb.all
    @hzp_bc_dws = HzpBcDw.all
      
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hzp_ypbs }
    end
  end

  # GET /hzp_ypbs/1
  # GET /hzp_ypbs/1.json
  def show
    @hzp_ypb = HzpYpb.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hzp_ypb }
    end
  end

  # GET /hzp_ypbs/new
  # GET /hzp_ypbs/new.json
  def new
    @hzp_ypb = HzpYpb.new
    @hzp_bc_dws = HzpBcDw.all
    
    @options = @hzp_bc_dws.map {|option|[option[:dwname],option[:dwname]]}
      
      
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hzp_ypb }
    end
  end

  # GET /hzp_ypbs/1/edit
  def edit
    @hzp_ypb = HzpYpb.find(params[:id])
    @hzp_bc_dws = HzpBcDw.all
    @options = @hzp_bc_dws.map {|option|[option[:dwname],option[:dwname]]}
  end

  # POST /hzp_ypbs
  # POST /hzp_ypbs.json
  def create
    @hzp_ypb = HzpYpb.new(params[:hzp_ypb])

    respond_to do |format|
      if @hzp_ypb.save
        format.html { redirect_to @hzp_ypb, notice: 'Hzp ypb was successfully created.' }
        format.json { render json: @hzp_ypb, status: :created, location: @hzp_ypb }
      else
        format.html { render action: "new" }
        format.json { render json: @hzp_ypb.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hzp_ypbs/1
  # PUT /hzp_ypbs/1.json
  def update
    @hzp_ypb = HzpYpb.find(params[:id])

    respond_to do |format|
      if @hzp_ypb.update_attributes(params[:hzp_ypb])
        format.html { redirect_to @hzp_ypb, notice: 'Hzp ypb was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @hzp_ypb.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hzp_ypbs/1
  # DELETE /hzp_ypbs/1.json
  def destroy
    @hzp_ypb = HzpYpb.find(params[:id])
    @hzp_ypb.destroy

    respond_to do |format|
      format.html { redirect_to hzp_ypbs_url }
      format.json { head :no_content }
    end
  end
  def mygetdata
      #@hzp_ypbs = HzpBcDw.all
      @hzp_ypbs = HzpBcDw.find(:all,:conditions=>["dwname=?",params[:name]])
      respond_to do |format|
       format.json {render json: @hzp_ypbs}
      end
        
  end
end
