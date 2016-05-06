#encoding=UTF-8
class JgBsbsController < ApplicationController

  before_filter :check_user_role, except: [:by_province,:by_jg_name]
  skip_before_action :authenticate_user!, only: [:by_province,:by_jg_name]

  # GET /jg_bsbs
  # GET /jg_bsbs.json
  def index
    @jg_bsbs = JgBsb.where(status: 0).order('created_at desc')

    unless params[:name].blank?
      @jg_bsbs = @jg_bsbs.where(id: JgBsbName.where('name LIKE ?', "%#{params[:name]}%").pluck('jg_bsb_id'))
    end

    unless params[:contact].blank?
      @jg_bsbs = @jg_bsbs.where('jg_contacts LIKE ?', "%#{params[:contact]}%")
    end

    unless params[:province].blank?
      @jg_bsbs = @jg_bsbs.where('jg_province LIKE ?', "%#{params[:province]}%")
    end

    unless params[:jg_city].blank?
      @jg_bsbs = @jg_bsbs.where('city LIKE ?', "%#{params[:jg_city]}%")
    end

    @jg_bsbs = @jg_bsbs.order('jg_province').paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @jg_bsbs }
    end
  end

  def by_jg_name
    @jg_bsbs =JgBsb.where(jg_province: SysConfig.get(SysConfig::Key::PROV))
    # @jg_bsbs = @jg_bsbs.where(city: params[:city])
    if  !params[:city].blank? and params[:city] != "-请选择-"
      @jg_bsbs = @jg_bsbs.where(city: params[:city])
    end
    @jg_bsbs = @jg_bsbs.select("jg_bsb_names.name,jg_bsb_names.jg_bsb_id").joins(:jg_names).where(" jg_bsb_names.name is not null ")
    render json: {status: 'OK', msg: @jg_bsbs.map { |j| [j.name, j.jg_bsb_id] }}
  end
  # GET /jg_bsbs/1
  # GET /jg_bsbs/1.json
  def show
    @jg_bsb = JgBsb.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @jg_bsb }
    end
  end

  # GET /jg_bsbs/new
  # GET /jg_bsbs/new.json
  def new
    @jg_bsb = JgBsb.new
    @jg_bsb.jg_administrion=0
    @jg_bsb.jg_sp_permission=0
    @jg_bsb.jg_bjp_permission=0
    @jg_bsb.jg_hzp_permission=0
    @jg_bsb.jg_group=0
    @jg_bsb.jg_sampling=0
    @jg_bsb.jg_detection=0
    @jg_bsb.jg_enable=0

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @jg_bsb }
    end
  end

  # GET /jg_bsbs/1/edit
  def edit
    @jg_bsb = JgBsb.find(params[:id])
  end

  # POST /jg_bsbs
  # POST /jg_bsbs.json
  def create
    @jg_bsb = JgBsb.new(jg_bsb_params)
    result_record = JgBsb.where("jg_name=? and status = 0", params[:jg_bsb][:jg_name]).last
    respond_to do |format|
      ActiveRecord::Base.transaction do
        if result_record!=nil
          flash[:import_result] = "保存不成功，数据库中已有该机构!"
          format.html { render action: "new" }
        else
          if @jg_bsb.save
            format.html { redirect_to jg_bsbs_url, notice: '保存成功!' }
            format.json { render json: @jg_bsb, status: :created, location: @jg_bsb }
          else
            format.html { render action: "new" }
            format.json { render json: @jg_bsb.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  end

  # 重命名
  def rename
    @jg_bsb = JgBsb.find(params[:jg_bsb_id])
    @name = JgBsbName.new(name: params[:name], note: params[:note])
    @name.jg_bsb = @jg_bsb

    if @name.save
      render json: {status: 'OK'}
    else
      render json: {status: 'ERR', msg: @name.errors.first.last}
    end
  end

  def merge_request
    if request.post?
      if params[:left_id].blank? or params[:right_id].blank?
        render json: {status: 'ERR', msg: '请选择完整信息!'}
        return
      end

      if params[:left_id].eql?(params[:right_id])
        render json: {status: 'ERR', msg: '请勿选择相同机构!'}
        return
      end

      left_jg = JgBsb.find(params[:left_id])
      right_jg = JgBsb.find(params[:right_id])

      if right_jg.merge(left_jg)
        render json: {status: 'OK', msg: '修改成功!'}
      else
        render json: {status: 'ERR', msg: '修改失败!'}
      end

      return
    end
  end

  # PUT /jg_bsbs/1
  # PUT /jg_bsbs/1.json
  def update
    @jg_bsb = JgBsb.find(params[:id])

    respond_to do |format|
      if @jg_bsb.update_attributes(jg_bsb_params)

        format.html { redirect_to jg_bsbs_url, notice: 'Jg bsb was successfully updated.' }
        format.json { head :no_content }
      else
        flash[:attachment_result] = @jg_bsb.errors.first.last
        format.html { render action: "edit" }
        format.json { render json: @jg_bsb.errors, status: :unprocessable_entity }
      end
    end
  end

  def attachment
    @jg_bsb = JgBsb.find(params[:id])
    if !@jg_bsb.attachment_path.blank?
      send_file("#{@jg_bsb.attachment_path_file}", :filename => "#{@jg_bsb.jg_name}#{File.extname(@jg_bsb.attachment_path)}", :disposition => 'inline')
    end
  end

  # DELETE /jg_bsbs/1
  # DELETE /jg_bsbs/1.json
  def destroy
    @jg_bsb = JgBsb.find(params[:id])
    @jg_bsb.destroy

    respond_to do |format|
      format.html { redirect_to jg_bsbs_url }
      format.json { head :no_content }
    end
  end

  #
  def import_data_excel
    uploaded_io = params[:excel]

    accepted_formats = [".xls", ".xlsx"]
    if !uploaded_io.nil? and accepted_formats.include? File.extname(uploaded_io.original_filename) then


      File.open(Rails.root.join('excel', current_user.name + (Time.now).to_s+uploaded_io.original_filename), 'wb') do |file|
        file.write(uploaded_io.read)
        book = Spreadsheet.open(Rails.root.join('excel', current_user.name + (Time.now).to_s + uploaded_io.original_filename))
        sheet1 = book.worksheet 0
        i_num=0
        temp_str=''
        sheet1.each do |row|
          if i_num<=1
            i_num=i_num+1
          else
            if (current_user.is_admin?)
              result_record=JgBsb.find_by_sql(["select jg_name from jg_bsbs where jg_name=? limit 1", row[1]])

              if result_record[0]==nil
                ActiveRecord::Base.transaction do
                  @user = JgBsb.new
                  @user.jg_name=row[1]
                  @user.jg_province=row[20]
                  @user.jg_email=row[6]
                  @user.jg_contacts=row[5]
                  @user.jg_tel=row[7]
                  @user.jg_address=row[2]
                  @user.jg_leader=row[3]
                  @user.jg_enable=1
                  @user.jg_sp_permission=1
                  @user.jg_sampling=1
                  @user.jg_detection=1
                  @user.save
                end
              end
            end
            i_num=i_num+1
          end
        end
        if temp_str!=''
          if temp_str.length>2000
            temp_str=temp_str[0, 2000]
            flash[:import_result] = "文件上传成功,新导入#{i_num-1}条记录!其中"+temp_str+"...不符合导入要求!"
          else
            flash[:import_result] = "文件上传成功,新导入#{i_num-1}条记录!其中"+temp_str+"不符合导入要求!"
          end
        else
          flash[:import_result] = "文件上传成功,新导入#{i_num-1}条记录!"
        end
      end

    else
      flash[:import_result] = "文件上传失败！"
    end
    respond_to do |format|
      format.html { redirect_to :action => "index", :controller => "jg_bsbs" }
    end
  end

  def by_province
    #@jg_bsbs = JgBsb.where(jg_province: params[:prov])
    @jg_bsbs = JgBsb.where(jg_province: SysConfig.get(SysConfig::Key::PROV))
    if params[:jg_type].to_i != 0
      @jg_bsbs = @jg_bsbs.where(jg_type: params[:jg_type].to_i)
    end
    if  !params[:prov_city].blank? and params[:prov_city] != "-请选择-"
      @jg_bsbs = @jg_bsbs.where(city: params[:prov_city])
    end
    @jg_bsbs = @jg_bsbs.select("jg_bsb_names.name,jg_bsb_names.jg_bsb_id").joins(:jg_names).where(" jg_bsb_names.name is not null ")
    render json: {status: 'OK', msg: @jg_bsbs.map { |j| [j.name, j.jg_bsb_id] }}
  end
  private
  def check_user_role
    return not_found if current_user.nil? or !current_user.is_admin?
  end

  def jg_bsb_params
    params.require(:jg_bsb).permit(
        :zipcode, :fax, :jg_type, :city, :country, :status, :pdf_sign_rules, :attachment_path_file, :gpsname, :gpspassword, :api_ip_address, :code, :jg_address, :jg_administrion, :jg_bjp_permission, :jg_certification, :jg_contacts, :jg_detection, :jg_enable, :jg_group, :jg_group_category, :jg_higher_level, :jg_hzp_permission, :jg_leader, :jg_name, :jg_sampling, :jg_sp_permission, :jg_tel, :jg_word_area, :jg_province, :jg_email, super_jg_bsbs: []
    )
  end
end