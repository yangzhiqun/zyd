class BaosongAsController < ApplicationController
  # GET /baosong_as
  # GET /baosong_as.json
 	before_action :find_province, only: [:new,:create,:edit,:show,:update] 

  def index
    @jg = current_user.jg_bsb 
    if current_user.is_admin? or is_sheng? 
    	@baosong_as = BaosongA.order("created_at desc")
    elsif jg_is_city?
      @baosong_as = BaosongA.where(shi: @jg.city, rwlylx: "市/区局").order("created_at desc")
    elsif jg_is_country?
      @baosong_as = BaosongA.where(xian: @jg.country, rwlylx: "县").order("created_at desc")
    end
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
		@baosong_a.sheng = SysConfig.get(SysConfig::Key::PROV) 
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
    params.require(:baosong_a).permit(:name, :note, :rwlylx, :prov,:sheng,:shi,:xian)
  end

  def find_province
    @province = SysProvince.where("level like '_' or level like '__'").where(name: SysConfig.get(SysConfig::Key::PROV)).last
  end
end
