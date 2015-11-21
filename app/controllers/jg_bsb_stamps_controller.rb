class JgBsbStampsController < ApplicationController
  # GET /jg_bsb_stamps
  # GET /jg_bsb_stamps.json
  def index
    @jg_bsb_stamps = JgBsbStamp.where(jg_bsb_id: params[:jg_bsb_id])
		@jg_bsb = JgBsb.find(params[:jg_bsb_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @jg_bsb_stamps }
    end
  end

  # GET /jg_bsb_stamps/1
  # GET /jg_bsb_stamps/1.json
  def show
    @jg_bsb_stamp = JgBsbStamp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @jg_bsb_stamp }
    end
  end

  # GET /jg_bsb_stamps/new
  # GET /jg_bsb_stamps/new.json
  def new
    @jg_bsb = JgBsb.find(params[:jg_bsb_id])
    @jg_bsb_stamp = JgBsbStamp.new(jg_bsb_id: @jg_bsb.id)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @jg_bsb_stamp }
    end
  end

  # GET /jg_bsb_stamps/1/edit
  def edit
    @jg_bsb_stamp = JgBsbStamp.find(params[:id])
  end

  #require 'rmagick'
  def cover
    @jg_bsb_stamp = JgBsbStamp.find(params[:jg_bsb_stamp_id])
    md5 = Digest::MD5.file(@jg_bsb_stamp.image_file).hexdigest.upcase
    thumbnail_path = Rails.root.join('tmp', "#{md5}.preview")
    unless File.exists?(thumbnail_path)
      image = Magick::Image::read(@jg_bsb_stamp.image_file).first
      image.resize_to_fit!(150)
      image.write(thumbnail_path)
    end
    send_file thumbnail_path, :disposition => 'inline'
  end

  # POST /jg_bsb_stamps
  # POST /jg_bsb_stamps.json
  def create
    @jg_bsb_stamp = JgBsbStamp.new(jg_bsb_stamp_params)

    respond_to do |format|
      if @jg_bsb_stamp.save
        format.html { redirect_to @jg_bsb_stamp, notice: 'Jg bsb stamp was successfully created.' }
        format.json { render json: @jg_bsb_stamp, status: :created, location: @jg_bsb_stamp }
      else
        format.html { render action: "new" }
        format.json { render json: @jg_bsb_stamp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /jg_bsb_stamps/1
  # PUT /jg_bsb_stamps/1.json
  def update
    @jg_bsb_stamp = JgBsbStamp.find(params[:id])

    respond_to do |format|
      if @jg_bsb_stamp.update_attributes(jg_bsb_stamp_params)
        format.html { redirect_to @jg_bsb_stamp, notice: 'Jg bsb stamp was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @jg_bsb_stamp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jg_bsb_stamps/1
  # DELETE /jg_bsb_stamps/1.json
  def destroy
    @jg_bsb_stamp = JgBsbStamp.find(params[:id])
    @jg_bsb_stamp.destroy

    respond_to do |format|
      format.html { redirect_to jg_bsb_stamps_url(jg_bsb_id: @jg_bsb_stamp.jg_bsb_id) }
      format.json { head :no_content }
    end
  end

  private
  def jg_bsb_stamp_params
    params.require(:jg_bsb_stamp).permit(:jg_bsb_id, :note, :stamp_no, :image_path, :image_file, :name, :stamp_type)
  end
end
