#encoding: utf-8
class DataController < ApplicationController

 include ApplicationHelper

  # GET /data_controller
  # GET /data_controller.json
  def index
    @sp_bsbs = SpBsb.order("updated_at desc").where("wochacha_task_id is ? OR wochacha_task_id = ?",nil,"").paginate(page: params[:page], per_page: 20)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sp_bsbs }
    end
  end

  # POST /data_controller/1
  # POST /data_controller/1.json
  def seach
    if params[:sp_s_16].blank? or params[:sp_s_16].nil?
      @sp_bsbs = SpBsb.order("updated_at desc").where("wochacha_task_id is ? OR wochacha_task_id = ?",nil,"").paginate(page: params[:page], per_page: 20)
    else
      @sp_bsbs = SpBsb.where("sp_s_16 = ? ",params[:sp_s_16]).where("wochacha_task_id is ? OR wochacha_task_id = ?",nil,"").paginate(page: params[:page], per_page: 20)
    end
    respond_to do |format|
      format.html {render action: "index"}
      format.json { render json: @sp_bsbs }
    end
  end


  # DELETE /data_controller/1
  # DELETE /data_controller/1.json
  def destroy
    if !params[:id].blank? and !params[:id].nil?
    @sp_bsbs = SpBsb.find(params[:id])
    if !current_user.is_admin?
      return not_found
    end
    if !@sp_bsbs.blank? and !@sp_bsbs.nil?
      #移动端数据
        @pad_sp_bsbs = PadSpBsb.where("sp_s_16 = ?",@sp_bsbs.sp_s_16)
        if !@pad_sp_bsbs.blank? and !@pad_sp_bsbs.nil?
          @pad_sp_bsbs.delete_all
        end
        #检测数据
        @spdata  = Spdatum.where("sp_bsb_id = ?",@sp_bsbs.id)
        if !@spdata.blank? and !@spdata.nil?
          @spdata.delete_all
        end
        #核查处置数据
        @wtyp_pats = WtypCzbPart.where("cjbh = ?",@sp_bsbs.sp_s_16)
        if !@wtyp_pats.blank? and !@wtyp_pats.nil?
          @wtyp_pats.delete_all
        end
        #核查处置数据
        @wtyp = WtypCzb.where("cjbh = ?",@sp_bsbs.sp_s_16)
        if !@wtyp.blank? and !@wtyp.nil?
          @wtyp.delete_all
        end
        #异议登记
        @yydj = SpYydjb.where("cjbh = ?",@sp_bsbs.sp_s_16).last#.find_by_sql("select * from sp_yydjbs where cjbh = '"+@sp_bsbs.sp_s_16+"'")#.where("cjbh = ?",@sp_bsbs.sp_s_16)
        if !@yydj.blank? and !@yydj.nil?
          #异议登记数据
        @yydj_data = SpYydjbSpdata.where("sp_yydjb_id = ?",@yydj.id)
        @yydj.delete
          if !@yydj_data.blank? and !@yydj_data.nil?
            @yydj_data.delete_all
          end
        end
        #存日志
        SpLog.create(:sp_bsb_id => @sp_bsbs.id, :sp_i_state => @sp_bsbs.sp_i_state, :remark => "运行了最高权限删除操作，将该数据所有都删除。", :user_id => current_user.id)
        #删除基础数据
        @sp_bsbs.destroy
    else
      return not_found
    end
    end
    respond_to do |format|
      format.html { redirect_to "/data/index" }
      format.json { head :no_content }
    end
  end

end
