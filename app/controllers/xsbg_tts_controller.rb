class XsbgTtsController < ApplicationController
  # GET /xsbg_tts
  # GET /xsbg_tts.json
  def index
    @xsbg_tts = XsbgTt.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @xsbg_tts }
    end
  end

  # GET /xsbg_tts/1
  # GET /xsbg_tts/1.json
  def show
    @xsbg_tt = XsbgTt.find(params[:id])

    @sp_bsb = SpBsb.find(@xsbg_tt.sp_bsb_id)

		@xsbg = XsbgTt.find_by_sp_bsb_id(@sp_bsb.id)

    @items = XsbgTtDatum.where(xsbg_tt_id: @xsbg_tt.id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @xsbg_tt }
    end
  end

  # GET /xsbg_tts/new
  # GET /xsbg_tts/new.json
  def new
    @xsbg_tt = XsbgTt.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @xsbg_tt }
    end
  end

  # GET /xsbg_tts/1/edit
  def edit
    @xsbg_tt = XsbgTt.find(params[:id])
  end

  # POST /xsbg_tts
  # POST /xsbg_tts.json
  def create
    @xsbg_tt = XsbgTt.new(params[:xsbg_tt])

    respond_to do |format|
      if @xsbg_tt.save
        format.html { redirect_to @xsbg_tt, notice: 'Xsbg tt was successfully created.' }
        format.json { render json: @xsbg_tt, status: :created, location: @xsbg_tt }
      else
        format.html { render action: "new" }
        format.json { render json: @xsbg_tt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /xsbg_tts/1
  # PUT /xsbg_tts/1.json
  def update
    @xsbg_tt = XsbgTt.find(params[:id])

    respond_to do |format|
      if @xsbg_tt.update_attributes(params[:xsbg_tt])
        format.html { redirect_to @xsbg_tt, notice: 'Xsbg tt was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @xsbg_tt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /xsbg_tts/1
  # DELETE /xsbg_tts/1.json
  def destroy
    @xsbg_tt = XsbgTt.find(params[:id])
    @xsbg_tt.destroy

    respond_to do |format|
      format.html { redirect_to xsbg_tts_url }
      format.json { head :no_content }
    end
  end
end
