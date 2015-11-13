class SpdataController < ApplicationController
  # GET /spdata
  # GET /spdata.json
  def index
    @spdata = Spdatum.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @spdata }
    end
  end

  # GET /spdata/1
  # GET /spdata/1.json
  def show
    @spdatum = Spdatum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @spdatum }
    end
  end

  # GET /spdata/new
  # GET /spdata/new.json
  def new
    @spdatum = Spdatum.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @spdatum }
    end
  end

  # GET /spdata/1/edit
  def edit
    @spdatum = Spdatum.find(params[:id])
  end

  # POST /spdata
  # POST /spdata.json
  def create
    @spdatum = Spdatum.new(params[:spdatum])

    respond_to do |format|
      if @spdatum.save
        format.html { redirect_to @spdatum, notice: 'Spdatum was successfully created.' }
        format.json { render json: @spdatum, status: :created, location: @spdatum }
      else
        format.html { render action: "new" }
        format.json { render json: @spdatum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /spdata/1
  # PUT /spdata/1.json
  def update
    @spdatum = Spdatum.find(params[:id])

    respond_to do |format|
      if @spdatum.update_attributes(params[:spdatum])
        format.html { redirect_to @spdatum, notice: 'Spdatum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @spdatum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spdata/1
  # DELETE /spdata/1.json
  def destroy
    @spdatum = Spdatum.find(params[:id])
    @spdatum.destroy

    respond_to do |format|
      format.html { redirect_to spdata_url }
      format.json { head :no_content }
    end
  end
end
