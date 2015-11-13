class XsbgTtDataController < ApplicationController
  # GET /xsbg_tt_data
  # GET /xsbg_tt_data.json
  def index
    @xsbg_tt_data = XsbgTtDatum.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @xsbg_tt_data }
    end
  end

  # GET /xsbg_tt_data/1
  # GET /xsbg_tt_data/1.json
  def show
    @xsbg_tt_datum = XsbgTtDatum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @xsbg_tt_datum }
    end
  end

  # GET /xsbg_tt_data/new
  # GET /xsbg_tt_data/new.json
  def new
    @xsbg_tt_datum = XsbgTtDatum.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @xsbg_tt_datum }
    end
  end

  # GET /xsbg_tt_data/1/edit
  def edit
    @xsbg_tt_datum = XsbgTtDatum.find(params[:id])
  end

  # POST /xsbg_tt_data
  # POST /xsbg_tt_data.json
  def create
    @xsbg_tt_datum = XsbgTtDatum.new(params[:xsbg_tt_datum])

    respond_to do |format|
      if @xsbg_tt_datum.save
        format.html { redirect_to @xsbg_tt_datum, notice: 'Xsbg tt datum was successfully created.' }
        format.json { render json: @xsbg_tt_datum, status: :created, location: @xsbg_tt_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @xsbg_tt_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /xsbg_tt_data/1
  # PUT /xsbg_tt_data/1.json
  def update
    @xsbg_tt_datum = XsbgTtDatum.find(params[:id])

    respond_to do |format|
      if @xsbg_tt_datum.update_attributes(params[:xsbg_tt_datum])
        format.html { redirect_to @xsbg_tt_datum, notice: 'Xsbg tt datum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @xsbg_tt_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /xsbg_tt_data/1
  # DELETE /xsbg_tt_data/1.json
  def destroy
    @xsbg_tt_datum = XsbgTtDatum.find(params[:id])
    @xsbg_tt_datum.destroy

    respond_to do |format|
      format.html { redirect_to xsbg_tt_data_url }
      format.json { head :no_content }
    end
  end
end
