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
    @table_name_parts.push(@begin_at.strftime('%Y-%m-%d'))
    @table_name_parts.push(@end_at.strftime('%Y-%m-%d'))
    @table_name_parts.push('发布数据表')

    if request.post?
      @pub = SpPublication.new(name: @table_name_parts.join('/'), user_id: current_user.id, pub_type: params[:current_tab].to_i)
      if @pub.save
        logger.error PublicationWorker.perform_async(@pub.id, params, current_user.id)
      else
        # ...
      end
    elsif request.get?

      @sp_data = Spdatum.joins('LEFT JOIN pub_spdata AS sp ON sp.spdata_id=spdata.id LEFT JOIN sp_bsbs AS s ON s.id=spdata.sp_bsb_id').where('sp.id IS NULL AND s.updated_at BETWEEN ? AND ?', @begin_at, @end_at).where("s.sp_i_state = 9")

      # 不合格项
      if params[:current_tab].to_i == 0
        @sp_data = @sp_data.where("s.sp_s_71 LIKE '%不合格%' OR s.sp_s_71 LIKE '%问题%'").where("spdata.spdata_2 LIKE '%不合格%' OR spdata.spdata_2 LIKE '%问题%'")
      end

      if !params[:baosong_a].blank? and !params[:baosong_a].eql?('请选择')
        @sp_data = @sp_data.where('s.sp_s_70 = ?', params[:baosong_a])
      end

      if !params[:baosong_b].blank? and !params[:baosong_b].eql?('请选择')
        @sp_data = @sp_data.where('s.sp_s_67 = ?', params[:baosong_b])
      end

      @sp_data = @sp_data.select('s.id as sp_bsb_id, spdata.id, s.sp_s_64, s.sp_s_65, s.sp_s_1, s.sp_s_7, s.sp_s_14, s.sp_s_16, s.sp_s_26, s.sp_s_74, s.sp_d_28, spdata.spdata_0, spdata.spdata_1, spdata.spdata_15')
      @sp_data = @sp_data.paginate(:page => params[:page], :per_page => 10)

      @table_name_parts.push('不合格') if params[:current_tab].to_i == 0
      @table_name_parts.push('合格') if params[:current_tab].to_i == 1
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

  # 未发布
  def unpublished

    if params[:KSSJ].blank?
      params[:KSSJ] = (Time.now - 6.month).strftime('%Y-%m-%d')
    end

    if params[:JSSJ].blank?
      params[:JSSJ] = Time.now.strftime('%Y-%m-%d')
    end

    @sp_bsbs = SpBsb.where('updated_at between ? and ?', params[:KSSJ], params[:JSSJ]).where(sp_i_state: 9).order('updated_at desc')
    if params[:tab].to_i == 0
      @sp_bsbs = @sp_bsbs.where('sp_s_16 not in (select cjbh from published_sp_bsbs)')
    end

    unless current_user.is_super?
      @sp_bsbs = @sp_bsbs.where('sp_s_3 = ?', current_user.user_s_province)
    end

    if params[:JYJL].present?
      if params[:JYJL].eql?('合格')
        @sp_bsbs = @sp_bsbs.where('sp_s_71 LIKE ?', '%合格%')
      elsif params[:JYJL].eql?('不合格')
        @sp_bsbs = @sp_bsbs.where('sp_s_71 LIKE ?', '%不合格%')
      end
    end

    if params[:CYDWMC].present?
      @sp_bsbs = @sp_bsbs.where('sp_s_35 LIKE ?', "%#{params[:CYDWMC]}%")
    end

    if params[:JYJGMC].present?
      @sp_bsbs = @sp_bsbs.where('sp_s_43 LIKE ?', "%#{params[:JYJGMC]}%")
    end

    if params[:BCYDWMC].present?
      @sp_bsbs = @sp_bsbs.where('sp_s_1 LIKE ?', "%#{params[:BCYDWMC]}%")
    end

    if params[:YPMC].present?
      @sp_bsbs = @sp_bsbs.where('sp_s_14 LIKE ?', "%#{params[:YPMC]}%")
    end

    if params[:SPDL].present?
      @sp_bsbs = @sp_bsbs.where('sp_s_17 = ?', params[:SPDL])
    end

    if params[:BH].present?
      @sp_bsbs = @sp_bsbs.where('sp_s_16 LIKE ?', "%#{params[:BH]}%")
    end

    if params[:tab].to_i == 0
      @sp_bsbs = @sp_bsbs.paginate(page: params[:page], per_page: 30)
    elsif params[:tab].to_i == 1
      @wtyp_czb_parts = WtypCzbPart.where('(wtyp_czb_type = 1 and bsscqy_sheng = ? ) or (wtyp_czb_type in (2, 3) and bcydw_sheng = ?)', current_user.user_s_province, current_user.user_s_province).where(cjbh: @sp_bsbs.pluck(:sp_s_16)).paginate(page: params[:page], per_page: 30)
      published_ids = PublishedWtypCzb.where('wtyp_czb_part_id is not null').pluck(:wtyp_czb_part_id)
      @wtyp_czb_parts = @wtyp_czb_parts.where('id not in (?)', published_ids) unless published_ids.empty?
    else
      return not_found
    end
  end

  # 已发布
  def published

    if params[:KSSJ].blank?
      params[:KSSJ] = (Time.now - 1.month).strftime('%Y-%m-%d')
    end

    if params[:JSSJ].blank?
      params[:JSSJ] = Time.now.strftime('%Y-%m-%d')
    end

    @sp_bsbs = PublishedSpBsb.joins('LEFT JOIN sp_bsbs on sp_bsbs.sp_s_16=published_sp_bsbs.cjbh').select('sp_bsbs.id, sp_bsbs.sp_s_1,sp_bsbs.sp_s_3,sp_bsbs.sp_s_14,sp_bsbs.sp_s_16,sp_bsbs.sp_s_17,sp_bsbs.sp_s_35,sp_bsbs.sp_s_43,sp_bsbs.sp_s_71,sp_bsbs.sp_i_state,sp_bsbs.updated_at,published_sp_bsbs.cfda_published_at,published_sp_bsbs.cjbh,published_sp_bsbs.url,published_sp_bsbs.user_id,published_sp_bsbs.WH, published_sp_bsbs.url').where('sp_bsbs.sp_i_state = 9 and published_sp_bsbs.cfda_published_at between ? and ?', params[:KSSJ], params[:JSSJ]).order('published_sp_bsbs.cfda_published_at desc')

    if params[:JYJL].present?
      if params[:JYJL].eql?('合格')
        @sp_bsbs = @sp_bsbs.where('sp_s_71 LIKE ?', '%合格%')
      elsif params[:JYJL].eql?('不合格')
        @sp_bsbs = @sp_bsbs.where('sp_s_71 LIKE ?', '%不合格%')
      end
    end

    if params[:CYDWMC].present?
      @sp_bsbs = @sp_bsbs.where('sp_s_35 LIKE ?', "%#{params[:CYDWMC]}%")
    end

    if params[:JYJGMC].present?
      @sp_bsbs = @sp_bsbs.where('sp_s_43 LIKE ?', "%#{params[:JYJGMC]}%")
    end

    if params[:BCYDWMC].present?
      @sp_bsbs = @sp_bsbs.where('sp_s_1 LIKE ?', "%#{params[:BCYDWMC]}%")
    end

    if params[:YPMC].present?
      @sp_bsbs = @sp_bsbs.where('sp_s_14 LIKE ?', "%#{params[:YPMC]}%")
    end

    unless current_user.is_super?
      @sp_bsbs = @sp_bsbs.where('sp_s_3 = ?', current_user.user_s_province)
    end

    if params[:SPDL].present?
      @sp_bsbs = @sp_bsbs.where('sp_s_17 = ?', params[:SPDL])
    end

    if params[:BH].present?
      @sp_bsbs = @sp_bsbs.where('sp_s_16 LIKE ?', "%#{params[:BH]}%")
    end

    if params[:WH].present?
      @sp_bsbs = @sp_bsbs.where('WH LIKE ?', "%#{params[:WH]}%")
    end

    if params[:tab].to_i == 0
      @sp_bsbs = @sp_bsbs.paginate(page: params[:page], per_page: 30)
    elsif params[:tab].to_i == 1
      @published_wtyp_czbs = PublishedWtypCzb.where(cjbh: @sp_bsbs.pluck(:sp_s_16)).paginate(page: params[:page], per_page: 30)
    else
      return not_found
    end
  end

  def publish_bsbs
    if params[:document_number].present? and params[:published_at].present? and params[:ids].present? and params[:type].present?
      ActiveRecord::Base.transaction do
        if params[:type].to_i == 0
          SpBsb.where(id: params[:ids].split(',')).each do |bsb|
            PublishedSpBsb.create(sp_bsb_id: bsb.id, url: params[:url], user_id: current_user.id, cjbh: bsb.sp_s_16, cfda_published_at: Date.parse(params[:published_at]), WH: params[:document_number])
          end
        elsif params[:type].to_i == 1
          WtypCzbPart.where(id: params[:ids].split(',')).each do |part|
            PublishedWtypCzb.create(wtyp_czb_part_id: part.id, url: params[:url], user_id: current_user.id, cjbh: part.cjbh, cfda_published_at: Date.parse(params[:published_at]), WH: params[:document_number], wtyp_czb_type: part.wtyp_czb_type)
          end
        end
      end
      render json: {status: 'OK', msg: ''}
    else
      render json: {status: 'ERR', msg: '参数缺失'}
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
            p = PublishedSpBsb.new(cjbh: row[0].to_s) #, cfda_published_at: Date.parse(row[2].to_s))
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

  def show_publication
    @sp_bsb = SpBsb.find(params[:id])
  end

  def publish_bsbs_from_xls
    book = Spreadsheet.open params[:published_xls].path
    sp_bsb_sheet = book.worksheet(0)

    sp_bsb_sheet.each_with_index do |row, index|
      next if index == 0

      sp_bsb = SpBsb.find_by_sp_s_16(row[0])
      if sp_bsb.nil?
        row[4] = '样品不存在!'
      else
        b = PublishedSpBsb.new(cjbh: sp_bsb.sp_s_16, pub_method: 'excel导入', cfda_published_at: row[1], WH: row[2], url: row[3])
        b.sp_bsb_id = sp_bsb.id
        b.user_id = current_user.id
        if b.save
          row[4] = '发布成功!'
        else
          row[4] = b.errors.first.last
        end
      end
    end

    wtyp_czb_sheet = book.worksheet(1)
    wtyp_czb_sheet.each_with_index do |row, index|
      next if index == 0

      cyhj_index = %w{blablabla 生产 流通 餐饮}.index(row[1])
      if cyhj_index.nil?
        row[5] = '抽样环节不存在或不正确'
        next
      else
        p = WtypCzbPart.where(cjbh: row[0], wtyp_czb_type: cyhj_index).first
        b = PublishedWtypCzb.new(pub_method: 'excel导入', wtyp_czb_type: p.wtyp_czb_type, cjbh: p.cjbh, cfda_published_at: row[2], WH: row[3], url: row[4])
        b.user_id = current_user.id
        b.wtyp_czb_part_id = p.id
        if b.save
          row[5] = '发布成功!'
        else
          row[5] = "失败!#{b.errors.first.last}"
        end
      end
    end


    # OUTPUT
    output = Rails.root.join('tmp', "#{Time.now.to_i}_#{rand(9999999)}.xls")
    book.write output
    send_file output, filename: "发布结果#{Time.now.to_i}.xls"
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
