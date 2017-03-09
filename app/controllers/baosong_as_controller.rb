class BaosongAsController < ApplicationController
  # GET /baosong_as
  # GET /baosong_as.json
 	before_action :find_province, only: [:new,:create,:edit,:show,:update] 

  def index
    @jg = current_user.jg_bsb 
    if current_user.is_admin? or is_sheng? 
    	@baosong_as = BaosongA.order("created_at desc")
    else #jg_is_city?
      #@baosong_as = BaosongA.where(shi: @jg.city, rwlylx: "市/区局").order("created_at desc")
      @baosong_a_jg = BaosongAJgId.where("jg_bsb_id = ?" ,current_user.jg_bsb.id)
      logger.error @baosong_a_jg.to_json
      baosongids = []
      if !@baosong_a_jg.blank?
        @baosong_a_jg.each do |baosong|
          baosongids.push(baosong.baosong_a_id)
        end
      end
      if jg_is_city?
        @baosong_as = BaosongA.where("id in (?) and rwlylx = ?",baosongids,"市/区局").order("created_at desc")
      end
      if jg_is_country?
        @baosong_as = BaosongA.where("id in (?) and rwlylx = ?",baosongids,"县").order("created_at desc")
      end

    #elsif jg_is_country?
      #@baosong_as = BaosongA.where(xian: @jg.country, rwlylx: "县").order("created_at desc")
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
    if current_user.is_super? or is_sheng?
      @jg_bsbs = JgBsb.where("status= 0 and jg_type=?",1)
    elsif is_city?
      @jg_bsbs = JgBsb.where("status = 0 and jg_type = 1 and city = ?",current_user.jg_bsb.city)
    else
      @jg_bsbs = JgBsb.where("status= 0 and jg_type=? and id = ? ",1,current_user.jg_bsb.id)
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @baosong_a }
    end
  end

  # GET /baosong_as/1/edit
  def edit
    @baosong_a = BaosongA.find(params[:id])
    if current_user.is_super? or is_sheng?
      @jg_bsbs = JgBsb.where("status= 0 and jg_type=?",1)
    else
      @jg_bsbs = JgBsb.where("status= 0 and jg_type=? and id = ? ",1,current_user.jg_bsb.id)
    end
  end

  # POST /baosong_as
  # POST /baosong_as.json
  def create
    @baosong_a = BaosongA.new(baosong_a_params)
    @baosong_a.sheng = SysConfig.get(SysConfig::Key::PROV) 
    respond_to do |format|
      if !BaosongA.find_by_name(baosong_a_params["name"]).nil?
        flash[:error] = "报送分类A名字重复！"
 	format.html { render action: "new" }
      else
        if @baosong_a.save
          format.html { redirect_to @baosong_a, notice: 'Baosong a was successfully created.' }
          format.json { render json: @baosong_a, status: :created, location: @baosong_a }
        else
          format.html { render action: "new" }
          format.json { render json: @baosong_a.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /baosong_as/1
  # PUT /baosong_as/1.json
  def update
    @baosong_a = BaosongA.find(params[:id])
    @baosong_a_jg = BaosongAJgId.find_by_sql(["select t.* from baosong_a_jg_ids t where t.baosong_a_id =? ",params[:id]])#JgBsbSuper.find_by_jg_bsb_id(params[:id])
    @baosong_a_jg.each do |da|
      da.destroy
    end
    respond_to do |format|
      if !BaosongA.find_by_name(baosong_a_params["name"]).nil? && @baosong_a.name != baosong_a_params["name"]
        flash[:error] = "报送分类A名字重复！"
 	format.html { render action: "new" }
      else
        if @baosong_a.update_attributes(baosong_a_params)
          format.html { redirect_to @baosong_a, notice: 'Baosong a was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @baosong_a.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /baosong_as/1
  # DELETE /baosong_as/1.json
  def destroy
    @baosong_a = BaosongA.find(params[:id])
    @baosong_b = BaosongB.where(baosong_a_id:@baosong_a.id)
    notice = "成功"
    if !@baosong_b.blank? and @baosong_b.length >=1
       notice = "存在报送分类B，请先删除报送分类B";
    else
      @baosong_a.destroy
    end
    respond_to do |format|
      format.html { redirect_to "/baosong_as" ,notice: notice}
      format.json { head :no_content }
    end
  end

  private
  def baosong_a_params
   # params.require(:baosong_a).permit(:jg_bsb_id,:name, :note, :rwlylx, :prov,:sheng,:shi,:xian)
    params.require(:baosong_a).permit(:jg_bsb_id,:name,:rwlylx, :note,jg_ids:[])
  end

  def find_province
    @province = SysProvince.where("level like '_' or level like '__'").where(name: SysConfig.get(SysConfig::Key::PROV)).last
  end
end
