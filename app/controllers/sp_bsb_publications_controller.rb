#encoding: utf-8
class SpBsbPublicationsController < ApplicationController
  include ApplicationHelper

  # GET /sp_bsb_publications
  # GET /sp_bsb_publications.json
  def index
    unless params[:baosong_a].blank?
      @baosong_bs = BaosongB.where(baosong_a_id: BaosongA.find_by_name(params[:baosong_a]).id)
    else
      @baosong_bs = []
    end

    if params[:begin_at].blank?
      @begin_at = Time.now.to_datetime.beginning_of_day
    else
      @begin_at = DateTime.parse(params[:begin_at]).beginning_of_day
    end

    if params[:end_at].blank?
      @end_at = Time.now.to_datetime.end_of_day
    else
      @end_at = DateTime.parse(params[:end_at]).end_of_day
    end

    ### Table Name
    @table_name_parts = []
    @table_name_parts.push(current_user.user_s_province)
    @table_name_parts.push(params[:baosong_a]) unless params[:baosong_a].blank?
    @table_name_parts.push(params[:baosong_b]) unless params[:baosong_b].blank?
    @table_name_parts.push(@begin_at.strftime("%Y-%m-%d"))
    @table_name_parts.push(@end_at.strftime("%Y-%m-%d"))
    @table_name_parts.push("发布数据表")

    if request.post?
      @pub = SpPublication.new(name: @table_name_parts.join('/'), user_id: current_user.id, pub_type: params[:current_tab].to_i)
      if @pub.save
        logger.error PublicationWorker.perform_async(@pub.id, params, current_user.id)
      else
        # ...
      end
    elsif request.get?

      @sp_data = Spdatum.joins("LEFT JOIN pub_spdata AS sp ON sp.spdata_id=spdata.id LEFT JOIN sp_bsbs AS s ON s.id=spdata.sp_bsb_id").where('sp.id IS NULL AND s.updated_at BETWEEN ? AND ?', @begin_at, @end_at).where("s.sp_i_state = 9")

      # 不合格项
      if params[:current_tab].to_i == 0
        @sp_data = @sp_data.where("s.sp_s_71 LIKE '%不合格%' OR s.sp_s_71 LIKE '%问题%'").where("spdata.spdata_2 LIKE '%不合格%' OR spdata.spdata_2 LIKE '%问题%'")
      end

      if !params[:baosong_a].blank? and !params[:baosong_a].eql?("请选择")
        @sp_data = @sp_data.where("s.sp_s_70 = ?", params[:baosong_a])
      end

      if !params[:baosong_b].blank? and !params[:baosong_b].eql?("请选择")
        @sp_data = @sp_data.where("s.sp_s_67 = ?", params[:baosong_b])
      end

      @sp_data = @sp_data.select("s.id as sp_bsb_id, spdata.id, s.sp_s_64, s.sp_s_65, s.sp_s_1, s.sp_s_7, s.sp_s_14, s.sp_s_16, s.sp_s_26, s.sp_s_74, s.sp_d_28, spdata.spdata_0, spdata.spdata_1, spdata.spdata_15")
      @sp_data = @sp_data.paginate(:page => params[:page], :per_page => 10)

      @table_name_parts.push("不合格") if params[:current_tab].to_i == 0
      @table_name_parts.push("合格") if params[:current_tab].to_i == 1
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {status: 'OK'} }
    end
  end

  # GET /sp_bsb_publications/1
  # GET /sp_bsb_publications/1.json
  def show
    @sp_bsb_publication = SpBsbPublication.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sp_bsb_publication }
    end
  end

  # GET /sp_bsb_publications/new
  # GET /sp_bsb_publications/new.json
  def new
    @sp_bsb_publication = SpBsbPublication.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sp_bsb_publication }
    end
  end

  # GET /sp_bsb_publications/1/edit
  def edit
    @sp_bsb_publication = SpBsbPublication.find(params[:id])
  end

  # POST /sp_bsb_publications
  # POST /sp_bsb_publications.json
  def create
    @sp_bsb_publication = SpBsbPublication.new(params[:sp_bsb_publication])

    respond_to do |format|
      if @sp_bsb_publication.save
        format.html { redirect_to @sp_bsb_publication, notice: 'Sp bsb publication was successfully created.' }
        format.json { render json: @sp_bsb_publication, status: :created, location: @sp_bsb_publication }
      else
        format.html { render action: "new" }
        format.json { render json: @sp_bsb_publication.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sp_bsb_publications/1
  # PUT /sp_bsb_publications/1.json
  def update
    @sp_bsb_publication = SpBsbPublication.find(params[:id])

    respond_to do |format|
      if @sp_bsb_publication.update_attributes(params[:sp_bsb_publication])
        format.html { redirect_to @sp_bsb_publication, notice: 'Sp bsb publication was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sp_bsb_publication.errors, status: :unprocessable_entity }
      end
    end
  end

  def check_duplicate
    if request.post?
      if params[:file].blank?
        flash[:error] = '请选择查重文件'
        render
        return
      end

      if !File.extname(params[:file].original_filename).eql?('.xls')
        flash[:error] = '仅支持.xls格式的文件'
        render
        return
      end

      book = Spreadsheet.open params[:file].path
      sheet = book.worksheet 0
      sheet.each_with_index do |row, index|
        next if index == 0

        unless SpBsb.exists?(sp_s_16: row[0].to_s)
          row[1] = '不存在'
        else
          if params[:is_pub].to_i == 1
            p = PublishedSpBsb.new(cjbh: row[0].to_s)#, cfda_published_at: Date.parse(row[2].to_s))
            begin
              p.cfda_published_at = Date.parse(row[2].to_s)
            rescue Exception => e
              row[1] = "发布失败，日期格式错误"
              next
            end
            unless p.save
              row[1] = "发布失败，#{p.errors.first.last}"
              next
            else
              row[1] = '发布成功'
            end
          end
          @item = PublishedSpBsb.where(cjbh: row[0].to_s).last
          if @item.nil?
            row[1] = '未发布'
          else
            row[1] = '已发布'
            row[2] = @item.cfda_published_at
          end
        end
      end
      output = Rails.root.join('tmp', "#{Time.now.to_i}_#{rand(9999999)}.xls")
      book.write output
      send_file output, filename: "查重结果#{Time.now.to_i}.xls"
    elsif request.get?
      render
    end
  end

  # DELETE /sp_bsb_publications/1
  # DELETE /sp_bsb_publications/1.json
  def destroy
    @sp_bsb_publication = SpBsbPublication.find(params[:id])
    @sp_bsb_publication.destroy

    respond_to do |format|
      format.html { redirect_to sp_bsb_publications_url }
      format.json { head :no_content }
    end
  end
end
