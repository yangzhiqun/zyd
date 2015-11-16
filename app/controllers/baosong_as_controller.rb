class BaosongAsController < ApplicationController
  # GET /baosong_as
  # GET /baosong_as.json
  def index
    @baosong_as = BaosongA.order("created_at desc")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @baosong_as }
    end
  end

  # GET /baosong_as/1
  # GET /baosong_as/1.json
  def show
    @baosong_a = BaosongA.find(params[:id])

    @baosong_b = BaosongB.new(baosong_a_id: @baosong_a.id)
    @baosong_bs = BaosongB.where(baosong_a_id: @baosong_a.id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @baosong_a }
    end
  end

  # GET /baosong_as/new
  # GET /baosong_as/new.json
  def new
    @baosong_a = BaosongA.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @baosong_a }
    end
  end

  # GET /baosong_as/1/edit
  def edit
    @baosong_a = BaosongA.find(params[:id])
  end

  # POST /baosong_as
  # POST /baosong_as.json
  def create
    @baosong_a = BaosongA.new(baosong_a_params)

    respond_to do |format|
      if @baosong_a.save
        format.html { redirect_to @baosong_a, notice: 'Baosong a was successfully created.' }
        format.json { render json: @baosong_a, status: :created, location: @baosong_a }
      else
        format.html { render action: "new" }
        format.json { render json: @baosong_a.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /baosong_as/1
  # PUT /baosong_as/1.json
  def update
    @baosong_a = BaosongA.find(params[:id])

    respond_to do |format|
      if @baosong_a.update_attributes(baosong_a_params)
        format.html { redirect_to @baosong_a, notice: 'Baosong a was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @baosong_a.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /baosong_as/1
  # DELETE /baosong_as/1.json
  def destroy
    @baosong_a = BaosongA.find(params[:id])
    @baosong_a.destroy

    respond_to do |format|
      format.html { redirect_to baosong_as_url }
      format.json { head :no_content }
    end
  end

  private
  def baosong_a_params
    params.require(:baosong_a).permit(:name, :note, :rwlylx, :prov)
  end
end
