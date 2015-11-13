class SpStandardsController < ApplicationController
  # GET /sp_standards
  # GET /sp_standards.json
  def index
    @sp_standards = SpStandard.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sp_standards }
    end
  end

  # GET /sp_standards/1
  # GET /sp_standards/1.json
  def show
    @sp_standard = SpStandard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sp_standard }
    end
  end

  # GET /sp_standards/new
  # GET /sp_standards/new.json
  def new
    @sp_standard = SpStandard.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sp_standard }
    end
  end

  # GET /sp_standards/1/edit
  def edit
    @sp_standard = SpStandard.find(params[:id])
  end

  # POST /sp_standards
  # POST /sp_standards.json
  def create
    @sp_standard = SpStandard.new(params[:sp_standard])

    respond_to do |format|
      if @sp_standard.save
        format.html { redirect_to @sp_standard, notice: 'Sp standard was successfully created.' }
        format.json { render json: @sp_standard, status: :created, location: @sp_standard }
      else
        format.html { render action: "new" }
        format.json { render json: @sp_standard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sp_standards/1
  # PUT /sp_standards/1.json
  def update
    @sp_standard = SpStandard.find(params[:id])

    respond_to do |format|
      if @sp_standard.update_attributes(params[:sp_standard])
        format.html { redirect_to @sp_standard, notice: 'Sp standard was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sp_standard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sp_standards/1
  # DELETE /sp_standards/1.json
  def destroy
    @sp_standard = SpStandard.find(params[:id])
    @sp_standard.destroy

    respond_to do |format|
      format.html { redirect_to sp_standards_url }
      format.json { head :no_content }
    end
  end
end
