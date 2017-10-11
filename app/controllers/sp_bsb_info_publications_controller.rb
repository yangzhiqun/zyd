#encoding=UTF-8
class SpBsbInfoPublicationsController < ApplicationController
 before_action :set_sp_bsb_info_publication, only: [:show, :edit, :update, :destroy]

  # GET /sp_bsb_info_publications
  # GET /sp_bsb_info_publications.json
  def index
    redirect_to "/spsearch_publish?#{session[:query]}"
  end

  def spsearch_publish
    @sp_bsb_info_publications = SpBsbInfoPublication.all
    #if current_user.pub_xxfb_gly != 1
      @sp_bsb_info_publications = @sp_bsb_info_publications.where("user_s_province = ?",current_user.user_s_province)
   # end
    @sp_bsb_info_publications = @sp_bsb_info_publications.paginate(page: params[:page], per_page: 30)

    @ending_time = Time.now
    @begin_time = Time.now - 3.months

    unless params[:begin_time].blank?
      @begin_time = DateTime.parse(params[:begin_time])
    end

    unless params[:ending_time].blank?
      @ending_time = DateTime.parse(params[:ending_time])
    end

    @sp_bsb_info_publications = @sp_bsb_info_publications.where("ggrq BETWEEN ? AND ?", @begin_time.beginning_of_day, @ending_time.end_of_day)

    unless params[:user_s_province].blank?
      @sp_bsb_info_publications = @sp_bsb_info_publications.where("user_s_province LIKE ?", "%#{params[:user_s_province]}%")
    end

    unless params[:ggh].blank?
      @sp_bsb_info_publications = @sp_bsb_info_publications.where("ggh LIKE ?", "%#{params[:ggh]}%")
    end

    unless params[:bcscqymc].blank?
      @sp_bsb_info_publications = @sp_bsb_info_publications.where("bcscqymc LIKE ?", "%#{params[:bcscqymc]}%")
    end

    unless params[:bcydwmc].blank?
      @sp_bsb_info_publications = @sp_bsb_info_publications.where("bcydwmc LIKE ?", "%#{params[:bcydwmc]}%")
    end

    unless params[:ypmc].blank?
      @sp_bsb_info_publications = @sp_bsb_info_publications.where("ypmc LIKE ?", "%#{params[:ypmc]}%")
    end

    unless params[:rwly].blank?
      @sp_bsb_info_publications = @sp_bsb_info_publications.where("rwly LIKE ?", "%#{params[:rwly]}%")
    end

    unless params[:sfhg].blank?
      @sp_bsb_info_publications = @sp_bsb_info_publications.where("sfhg = ?", "#{params[:sfhg]}")
    end

    unless params[:fl].blank?
      @sp_bsb_info_publications = @sp_bsb_info_publications.where("fl LIKE ?", "%#{params[:fl]}%")
    end

    unless params[:cjbh].blank?
      @sp_bsb_info_publications = @sp_bsb_info_publications.where("cjbh LIKE ?", "%#{params[:cjbh]}%")
    end

    unless params[:jyjg].blank?
      @sp_bsb_info_publications = @sp_bsb_info_publications.where("jyjg LIKE ?", "%#{params[:jyjg]}%")
    end

    respond_to do |format|
      format.html { render action: "index" }
      format.json { render json: @sp_bsb_info_publications }
    end
  end

  def upload_hege_excel

    if !File.extname(params[:hege_xls].original_filename).eql?('.xls')
      flash[:error] = '仅支持.xls格式的文件'
      redirect_to "/spsearch_publish?#{session[:query]}"
      return
    else
      book_1 = Spreadsheet.open params[:hege_xls].path
      sheet_1 = book_1.worksheet(0)

      sheet_1.each_with_index do |row, index|
        next if index == 0 || index == 1

        if row[0].nil?
          row[15] = "发布失败：抽样编号不能为空"
        else

          # 处理日期格式
          if ['Date','Float'].include?(row[11].class.to_s)
            ggrq_fix = row.date(11).to_s
          else
            ggrq_fix = row[11].to_s
          end

          # 处理生产日期格式
          if ['Date','Float'].include?(row[8].class.to_s)
            scrq_fix = row.date(8).to_s
          else
            scrq_fix = row[8].to_s
          end

          # 处理ID（整数）格式
          if row[1].class.to_s.eql?('String')
            sjid_fix = row[1].to_s
          else
            if row[1] - row[1].to_i == 0
              sjid_fix = row[1].to_i.to_s
            else
              sjid_fix = row[1].to_s
            end
          end

          sp_bsb_info_publication = SpBsbInfoPublication.new(
              cjbh: row[0], sjid: sjid_fix, bcscqymc: row[2], bcscqydz: row[3], bcydwmc: row[4], bcydwsf: row[5], spmc: row[6],
              ggxh: row[7], scrq: scrq_fix, fl: row[9], ggh: row[10], ggrq: ggrq_fix, rwly: row[12], bz: row[13], sfhg: 1,bcydwshi: row[14],
              userid: current_user.id, user_s_province: current_user.user_s_province)
          if sp_bsb_info_publication.save
            row[15] = '发布成功!'
          else
            row[15] = "发布失败：#{sp_bsb_info_publication.errors.as_json.values().to_s.gsub(/\[|\]|\"/,'')}"
            next
          end
        end
      end

      # OUTPUT
      output_1 = Rails.root.join('tmp', "#{Time.now.to_i}_#{rand(9999999)}_合格.xls")
      book_1.write output_1
      send_file output_1, filename: "发布结果_合格#{Time.now.to_i}.xls"
    end
  end

  def upload_buhege_excel
    if !File.extname(params[:buhege_xls].original_filename).eql?('.xls')
      flash[:error] = '仅支持.xls格式的文件'
      redirect_to "/spsearch_publish?#{session[:query]}"
      return
    else
      book_0 = Spreadsheet.open params[:buhege_xls].path
      sheet_0 = book_0.worksheet(0)

      sheet_0.each_with_index do |row, index|
        next if index == 0 || index == 1

        if row[0].nil?
          row[17] = "发布失败：抽样编号不能为空"
        elsif row[15].nil?
          row[17] = "发布失败：检验机构不能为空"
        else

          # 处理发布日期格式
          if ['Date','Float'].include?(row[13].class.to_s)
            ggrq_fix = row.date(13).to_s
          else
            ggrq_fix = row[13].to_s
          end

          # 处理生产日期格式
          if ['Date','Float'].include?(row[9].class.to_s)
            scrq_fix = row.date(9).to_s
          else
            scrq_fix = row[9].to_s
          end

          # 处理ID（整数）格式
          if row[1].class.to_s.eql?('String')
            sjid_fix = row[1].to_s
          else
            if row[1] - row[1].to_i == 0
              sjid_fix = row[1].to_i.to_s
            else
              sjid_fix = row[1].to_s
            end
          end

          sp_bsb_info_publication = SpBsbInfoPublication.new(
              cjbh: row[0], sjid: sjid_fix, bcscqymc: row[2], bcscqydz: row[3], bcydwmc: row[4], bcydwdz: row[5], spmc: row[6],
              ggxh: row[7], sb: row[8], scrq: scrq_fix, bhgxm: row[10], fl: row[11], ggh: row[12], ggrq: ggrq_fix, rwly: row[14],
              jyjg: row[15], bz: row[16], sfhg: 0, userid: current_user.id, user_s_province: current_user.user_s_province)
          if sp_bsb_info_publication.save
            row[17] = '发布成功!'
          else
            row[17] = "发布失败：#{sp_bsb_info_publication.errors.as_json.values().to_s.gsub(/\[|\]|\"/,'')}"
            next
          end
        end
      end

      # OUTPUT
      output_0 = Rails.root.join('tmp', "#{Time.now.to_i}_#{rand(9999999)}_不合格.xls")
      book_0.write output_0
      send_file output_0, filename: "发布结果_不合格#{Time.now.to_i}.xls"
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
            p = SpBsbInfoPublication.new(cjbh: row[0].to_s) #, cfda_published_at: Date.parse(row[2].to_s))
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
          @item = SpBsbInfoPublication.where(cjbh: row[0].to_s).last
          if @item.nil?
            row[1] = '未发布'
          else
            row[1] = '已发布'
            row[2] = @item.ggrq.to_s
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

  # GET /sp_bsb_info_publications/1
  # GET /sp_bsb_info_publications/1.json
  def show
  end

  # GET /sp_bsb_info_publications/new
  def new
    @sp_bsb_info_publication = SpBsbInfoPublication.new
  end

  # GET /sp_bsb_info_publications/1/edit
  def edit
  end

  # POST /sp_bsb_info_publications
  # POST /sp_bsb_info_publications.json
  def create
    @sp_bsb_info_publication = SpBsbInfoPublication.new(sp_bsb_info_publication_params)

    respond_to do |format|
      if @sp_bsb_info_publication.save
        format.html { redirect_to @sp_bsb_info_publication, notice: 'Sp bsb info publication was successfully created.' }
        format.json { render :show, status: :created, location: @sp_bsb_info_publication }
      else
        format.html { render :new }
        format.json { render json: @sp_bsb_info_publication.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sp_bsb_info_publications/1
  # PATCH/PUT /sp_bsb_info_publications/1.json
  def update
    respond_to do |format|
      if @sp_bsb_info_publication.update(sp_bsb_info_publication_params)
        format.html { redirect_to @sp_bsb_info_publication, notice: 'Sp bsb info publication was successfully updated.' }
        format.json { render :show, status: :ok, location: @sp_bsb_info_publication }
      else
        format.html { render :edit }
        format.json { render json: @sp_bsb_info_publication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sp_bsb_info_publications/1
  # DELETE /sp_bsb_info_publications/1.json
  def destroy
    @sp_bsb_info_publication.destroy
    respond_to do |format|
      format.html { redirect_to sp_bsb_info_publications_url, notice: 'Sp bsb info publication was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_sp_bsb_info_publication
    @sp_bsb_info_publication = SpBsbInfoPublication.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sp_bsb_info_publication_params
    params.require(:sp_bsb_info_publication).permit(:cjbh, :sjid, :bcscqymc, :bcscqydz, :bcydwmc, :bcydwdz, :bcydwsf, :spmc, :ggxh, :sb, :scrq, :bhgxm, :fl, :ggh, :ggrq, :rwly, :bz, :jyjg, :sfhg, :userid, :user_s_province,:bcydwshi)
  end
end
