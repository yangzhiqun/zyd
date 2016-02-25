#encoding=UTF-8
require 'csv'
class SpkjBsbsController < ApplicationController
  before_filter :init

  def init
    if current_user.is_admin?
      @admin_user=1
    else
      @admin_user=0
    end
    @avala=[17, 18, 19, 20, 21, 23, 24, 30, 31, 33, 36, 44, 59, 61, 62, 63, 66, 67, 68, 70, 71, 201, 203, 205, 214]
    @options=[]
    @avala.each do |i|
      @options[i]=Flexcontent.find_all_by_flex_field("sp_bsb_sp_s_#{i}", :order => "flex_sortid ASC")
      @options[i]=@options[i].map { |option| [option[:flex_name], option[:flex_id]] }


    end
    @options_68=[]
    @options[68].each_index do |i|
      temp=Flexcontent.all(:conditions => ["flex_field=? and flex_groupid=?", "sp_bsb_sp_s_2", i], :order => "flex_sortid ASC")
      @options_68[i]=temp.map { |option| option[:flex_name] }
      #logger.debug(p @options_68[i])
    end

    temp=JgBsb.find(:all, :select => 'jg_name,jg_contacts,jg_tel,jg_email', :conditions => ["jg_province=? and jg_sp_permission=1 and jg_detection=1", current_user.user_s_province], :order => "jg_province")
    @options[100]=temp.map { |option| [option[:jg_name], option[:jg_name]] }
    @options[101]=temp.map { |option| [option[:jg_contacts], option[:jg_tel], option[:jg_email]] }
    temp=JgBsb.find(:all, :select => 'jg_name,jg_contacts,jg_tel,jg_email', :conditions => ["jg_province<>? and jg_sp_permission=1 and jg_detection=1", current_user.user_s_province], :order => "jg_province")

    temp1=temp.map { |option| [option[:jg_name], option[:jg_name]] }
    temp2=temp.map { |option| [option[:jg_contacts], option[:jg_tel], option[:jg_email]] }
    @options[100]=@options[100]+temp1
    @options[101]=@options[101]+temp2
  end


  def index
    @spkj_bsbs= SpkjBsb.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @spkj_bsbs }
    end
  end

  # GET /spkj_bsbs/1
  # GET /spkj_bsbs/1.json
  def show
    @spkj_bsb = SpkjBsb.find(params[:id])
    @sp_jcxcount=@spkj_bsb.sp_n_jcxcount
    @sp_data=Spdatum.find_all_by_spkj_bsb_id(params[:id])
    if @sp_jcxcount==nil
      @sp_jcxcount=1
    end

  end

  # GET /spkj_bsbs/new
  # GET /spkj_bsbs/new.json
  def new

    flash[:import_result] =nil
    @spkj_bsb = SpkjBsb.new
    @spkj_bsb.tname = current_user.name
    @spkj_bsb.sp_s_3 = current_user.user_s_province
    @spkj_bsb.sp_s_35 = session[:user_jcjg]
    @spkj_bsb.sp_s_37 = current_user.tname
    @spkj_bsb.sp_s_39 = current_user.tel
    @spkj_bsb.sp_s_52 = current_user.user_s_province
    @spkj_bsb.sp_s_71 = '未检验'
    temp=JgBsb.find_by_jg_name(session[:user_jcjg])
    if temp
      @spkj_bsb.sp_s_40=temp.jg_contacts
      @spkj_bsb.sp_s_41=temp.jg_tel
      @spkj_bsb.sp_s_42=temp.jg_email
      @spkj_bsb.sp_s_52=temp.jg_province

    end
    @spkj_bsb.sp_i_state=0;
    @spkj_bsb.sp_d_86=(Time.now).year.to_s+'-'+(Time.now).mon.to_s+'-'+(Time.now).day.to_s
    @sp_jcxcount=1


    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @spkj_bsb }
    end
  end

  # GET /spkj_bsbs/1/edit
  def edit
    @spkj_bsb = SpkjBsb.find(params[:id])
    @sp_jcxcount=@spkj_bsb.sp_n_jcxcount
    @spkj_bsb.sp_s_55=''
    if @sp_jcxcount==nil
      @sp_jcxcount=1
    end
    if @spkj_bsb.sp_s_85==''||@spkj_bsb.sp_s_85==nil
      @spkj_bsb.sp_s_85=current_user.tname
      @spkj_bsb.sp_s_87=current_user.tel
      @spkj_bsb.sp_s_88=current_user.eaddress
    end


  end

  def wtyptzs
    @spkj_bsb = SpkjBsb.find(params[:id])
  end

  # POST /spkj_bsbs
  # POST /spkj_bsbs.json
  def create
    @spkj_bsb = SpkjBsb.new(params[:spkj_bsb])
    # @spkj_bsb.tname=current_user.name
    @spkj_bsb.user_id = current_user.id
    @spkj_bsb.uid = current_user.uid
    @spkj_bsb.sp_s_52=current_user.user_s_province
    @spkj_bsb.sp_i_state=1
    @spkj_bsb.save
    respond_to do |format|
      format.html { redirect_to("/spkj_bsbs") }
      format.json { render json: @spkj_bsb }
    end
  end

  # PUT /spkj_bsbs/1
  # PUT /spkj_bsbs/1.json
  def update
    @spkj_bsb=SpkjBsb.find(params[:id])
    @spkj_bsb.update_attributes(params[:spkj_bsb])

    respond_to do |format|
      format.html { redirect_to("/spkj_bsbs") }
      format.json { render json: @spkj_bsb }
    end
  end

  # DELETE /spkj_bsbs/1
  # DELETE /spkj_bsbs/1.json
  def destroy
    @spkj_bsb = SpkjBsb.find(params[:id])
    @spkj_bsb.destroy

    respond_to do |format|
      format.html { redirect_to "/spkj_bsbs" }
      format.json { head :no_content }
    end
  end
end
    
    
   