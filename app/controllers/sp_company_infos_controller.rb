#encoding: utf-8
class SpCompanyInfosController < ApplicationController
  # GET /sp_company_infos
  # GET /sp_company_infos.json
  def index
    @sp_company_infos = SpCompanyInfo.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sp_company_infos }
    end
  end

  # GET /sp_company_infos/1
  # GET /sp_company_infos/1.json
  def show
    @sp_company_info = SpCompanyInfo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sp_company_info }
    end
  end

  # GET /sp_company_infos/new
  # GET /sp_company_infos/new.json
  def new
    @sp_company_info = SpCompanyInfo.new
    @options = []
    @options[68]=Flexcontent.find_all_by_flex_field("sp_bsb_sp_s_68",:order=>"flex_sortid ASC")
    @options[68]=@options[68].map{|option|[option[:flex_name],option[:flex_id]]}

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sp_company_info }
    end
  end

  # GET /sp_company_infos/1/edit
  def edit
    @sp_company_info = SpCompanyInfo.find(params[:id])
    @options = []
    @options[68] = Flexcontent.where(flex_field: "sp_bsb_sp_s_68").order("flex_sortid ASC")
    @options[68]=@options[68].map{|option|[option[:flex_name],option[:flex_id]]}
  end

  # POST /sp_company_infos
  # POST /sp_company_infos.json
  def create
    @sp_company_info = SpCompanyInfo.new(sp_company_info_params)

    respond_to do |format|
      if @sp_company_info.save
        format.html { redirect_to "/sp_company_infos" }
        format.json { render json: @sp_company_info, status: :created, location: @sp_company_info }
      else
        format.html { render action: "new" }
        format.json { render json: @sp_company_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sp_company_infos/1
  # PUT /sp_company_infos/1.json
  def update
    @sp_company_info = SpCompanyInfo.find(params[:id])

    respond_to do |format|
      if @sp_company_info.update_attributes(sp_company_info_params)
        format.html { redirect_to "/sp_company_infos" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sp_company_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sp_company_infos/1
  # DELETE /sp_company_infos/1.json
  def destroy
    @sp_company_info = SpCompanyInfo.find(params[:id])
    @sp_company_info.destroy

    respond_to do |format|
      format.html { redirect_to sp_company_infos_url }
      format.json { head :no_content }
    end
  end

	# 通过营业执照获取被抽样单位信息
	def by_yyzz
		unless params[:yyzz].blank?
			@company = SpCompanyInfo.find_by_sp_s_215(params[:yyzz])
			if @company.nil?
				render :json => {status: 'ERR', msg: "未找到相应信息"}
			else
				render :json => {status: 'OK', msg: @company}
			end
		else
			render :json => {status: 'ERR', msg: "请提供参数yyzz"}
		end
	end

  def list
    respond_to do |format|
      if params[:condition].blank?
        format.json { render :json => { :status => 'ERR', :msg => nil} }
      else
        now = Time.now
        @wheres = ["created_at between '#{(now - 30.days).strftime("%Y-%m-%d %H:%M:%S")}' AND '#{now.strftime("%Y-%m-%d %H:%M:%S")}'"]
        @wheres.push("sp_i_state NOT IN (0, 1, 10, 17, 18)")

        # unless params[:condition][:sp_s_3].blank?
        #   @wheres.push("sp_s_3 = '#{params[:condition][:sp_s_3]}'")
        # end

        # unless params[:condition][:sp_s_4].blank?
        #   @wheres.push("sp_s_4 = '#{params[:condition][:sp_s_4]}'")
        # end

        # unless params[:condition][:sp_s_5].blank?
        #   @wheres.push("sp_s_5 = '#{params[:condition][:sp_s_5]}'")
        # end

        # unless params[:condition][:sp_s_68].blank?
        #   @wheres.push("sp_s_68 = '#{params[:condition][:sp_s_68]}'")
        # end

        @where_sql = "where " + @wheres.join(" AND ") unless @wheres.blank?

        # @companies = SpCompanyInfo.select('c.id, c.sp_s_1, count(s.sp_s_1) as cnt').joins("AS c LEFT JOIN (select id, sp_s_1, sp_i_state, created_at from sp_bsbs #{@where_sql} union select id, sp_s_1, sp_i_state, created_at from pad_sp_bsbs #{@where_sql}) AS s ON s.sp_s_1=c.sp_s_1").group("c.sp_s_1")
        @companies = SpCompanyInfo.select('c.id, c.sp_s_1, c.sp_s_68, count(s.sp_s_1) as cnt').joins("AS c LEFT JOIN (select id, sp_s_1, sp_i_state, created_at from sp_bsbs #{@where_sql} union select id, sp_s_1, sp_i_state, created_at from pad_sp_bsbs #{@where_sql}) AS s ON s.sp_s_1=c.sp_s_1").group("c.sp_s_1")

        unless params[:condition][:sp_s_3].blank?
          @companies = @companies.where("c.sp_s_3=?", params[:condition][:sp_s_3])
        end

        unless params[:condition][:sp_s_4].blank?
          @companies = @companies.where("c.sp_s_4=?", params[:condition][:sp_s_4])
        end

        unless params[:condition][:sp_s_5].blank?
          @companies = @companies.where("c.sp_s_5=?", params[:condition][:sp_s_5])
        end

        unless params[:condition][:sp_s_68].blank?
          @companies = @companies.where("c.sp_s_68=?", params[:condition][:sp_s_68])
        end

        format.json { render :json => { :status => 'OK', :msg => nil, :sql => @companies.to_sql, :companies => @companies.map{|record| {:id => record.id, :title => "#{record.sp_s_1}", :count => record.cnt, :sp_s_68 => record.sp_s_68}}} }
      end
    end
  end

  def sp_company_info_params
    params.require(:sp_company_info).permit(:sp_s_1, :sp_s_2, :sp_s_10, :sp_s_11, :sp_s_12, :sp_s_201, :sp_s_215, :sp_s_23, :sp_s_3, :sp_s_4, :sp_s_5, :sp_s_68, :sp_s_7, :sp_s_8, :sp_s_9, :sp_s_bsfl)
  end
end
