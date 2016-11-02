#encoding: utf-8
class TasksController < ApplicationController
  include ApplicationHelper

  # 
  def deploy
    if request.post?
      if is_number?(params[:value])
        if params[:pk].blank?
          @record = TaskProvince.where(:sys_province_id => params[:name][:p_id], :a_category_id => params[:name][:c_id]).first_or_create
          @record.quota = params[:value].to_i

          if @record.save
            render :json => {:status => "OK", :msg => {id: @record.id}}
          else
            render :json => {:status => "ERR", :msg => @record.first.last}
          end
        else
          @record = TaskProvince.find(params[:pk])
          @record.quota = params[:value].to_i

          if @record.save
            render :json => {:status => "OK", :msg => {id: @record.id}}
          else
            render :json => {:status => "ERR", :msg => @record.first.last}
          end
        end
      else
        render :json => {:status => "ERR", :msg => "请填写数字"}
      end
    elsif request.get?
      # GET REQUEST

      # 如果baosong_a不为空，则整理其baosong_bs
      unless params[:baosong_a].blank?
        baosong_a = BaosongA.find_by_name(params[:baosong_a])

        @baosong_bs = baosong_a.baosong_bs

       # if !current_user.is_admin?
       #   @baosong_bs = @baosong_bs.where("prov = ? OR prov IS NULL OR prov = ''", current_user.user_s_province)
       # end

        # 如果baosong_b不为空，则取出 @baosong_b
        unless params[:baosong_b].blank?
          @baosong_b = @baosong_bs.where(name: params[:baosong_b]).last
        end
      else
        @baosong_bs = [];
      end

      # 国家局任务部署
      if current_user.is_admin?
        # 取出省级Province
        @provinces = SysProvince.level1

        if @baosong_b.nil?
          @a_categories = []
        else
          @a_categories = @baosong_b.a_categories
        end

        # 总局本级任务
        if params[:tab].to_i == 0
          # 所有检测机构，按名称排序
          @jg_bsbs = JgBsb.where(status: 0)

          # 如果没有选择报送分类B，则不显示
          if @baosong_b.nil?
            @tasks = []
          else
            @tasks = TaskJgBsb.where(sys_province_id: -1, identifier: @baosong_b.identifier)
          end

          count = TaskJgBsb.select('count(distinct(jg_bsb_id)) as count').where(:sys_province_id => -1)
          if @baosong_b.present?
            count = count.where(identifier: @baosong_b.identifier)
          end
          @count = count.first.count
        end
      else
        # 省局任务部署
        @province = SysProvince.level1.find_by_name(current_user.prov_city)
        tasks = @province.task_provinces

        unless params[:baosong_a].blank?
          @baosong_a = BaosongA.find_by_name(params[:baosong_a])
          @baosong_bs = BaosongB.where(:baosong_a_id => @baosong_a.id)

          @baosong_b = @baosong_bs.where(name: params[:baosong_b]).last
        #  if !current_user.is_admin?
        #    @baosong_bs = @baosong_bs.where("prov = ? OR prov IS NULL OR prov = ''", current_user.user_s_province)
        #  end
        else
          @baosong_bs = []
        end

        d_category_ids = []
        tasks.each do |t|
          d_category_ids.concat DCategory.where(a_category_id: t.a_category_id).map { |d| d.id }
        end
        d_category_ids.uniq!

        @d_categories = DCategory.where(id: d_category_ids).order('a_category_id, b_category_id, c_category_id')
        @d_categories = @d_categories.where(identifier: @baosong_b.identifier) unless @baosong_b.blank?

        ids = TaskProvince.where(sys_province_id: @province.id).map { |b| b.a_category_id }
        @a_categories = ACategory.where(id: ids)

        @delegates = TaskJgBsb.select('distinct(jg_bsb_id)').where(:sys_province_id => @province.id)
        @count = @delegates.count

        # TODO: 如何精准筛选剩余部分
        @cyjgs = JgBsb.where(:jg_sampling => 1, status: 0)
        @jyjgs = JgBsb.where(:jg_detection => 1, status: 0)
      end
    end
  end

  # 委托地方承担的抽样任务
  def create_prov_plan
    if params[:prov].blank? or params[:dl].blank? or params[:quota].blank?
      render json: {status: 'ERR', msg: '请提供必要参数'}
    else
      @plan = TaskProvince.new(identifier: params[:identifier], sys_province_id: params[:prov], :a_category_id => params[:dl], :quota => params[:quota])

      destroy_category_level = 'a_category_id'

      if params[:yl].to_i != 0
        @plan.b_category_id = params[:yl]
        destroy_category_level = 'b_category_id'
      end

      if params[:cyl].to_i != 0
        @plan.c_category_id = params[:cyl]
        destroy_category_level = 'c_category_id'
      end

      if params[:xl].to_i != 0
        @plan.d_category_id = params[:xl]
        destroy_category_level = 'd_category_id'
      end

      # 强制清除已经部署的与当前有冲突的任务
      TaskProvince.where("identifier = ? and sys_province_id = ? and (#{destroy_category_level} is NULL or #{destroy_category_level} = ?)", params[:identifier], params[:prov], @plan[destroy_category_level]).destroy_all

      if @plan.save
        render json: {status: 'OK', msg: "成功！"}
      else
        render json: {status: 'ERR', msg: @plan.errors.first.last}
      end
    end
  end

  # 国家直接下达抽样任务的计划, 直接下达给承检机构
  def create_direct_plan
    if params[:jg_id].blank? or params[:dl].blank? or params[:quota].blank?
      render json: {status: 'ERR', msg: '请提供必要参数'}
    else
      @plan = TaskJgBsb.new(identifier: params[:identifier], sys_province_id: -1, is_national: true, test_jg_bsb_id: params[:test_jg_id], jg_bsb_id: params[:jg_id], :a_category_id => params[:dl], :quota => params[:quota])

      destroy_category_level = 'a_category_id'

      if !params[:yl].blank? and params[:yl].to_i != 0
        @plan.b_category_id = params[:yl]
        destroy_category_level = 'b_category_id'
      end

      if !params[:cyl].blank? and params[:cyl].to_i != 0
        @plan.c_category_id = params[:cyl]
        destroy_category_level = 'c_category_id'
      end

      if !params[:xl].blank? and params[:xl].to_i != 0
        @plan.d_category_id = params[:xl]
        destroy_category_level = 'd_category_id'
      end

      # 强制清除已经部署的与当前有冲突的任务
      TaskJgBsb.where("identifier = ? and sys_province_id = -1 and jg_bsb_id = ? and (#{destroy_category_level} is NULL or #{destroy_category_level} = ?)", params[:identifier], params[:jg_id], @plan[destroy_category_level]).destroy_all

      if @plan.save
        render json: {status: 'OK', msg: '成功！'}
      else
        render json: {status: 'ERR', msg: @plan.errors.first.last}
      end
    end
  end

  # 省局部署任务
  def deploy_prov
    if is_number?(params[:value])
      if params[:pk].blank?
        @record = TaskJgBsb.where(:sys_province_id => params[:name][:p_id], :a_category_id => params[:name][:c_id], :jg_bsb_id => params[:name][:jg_id]).first_or_create
        @record.quota = params[:value].to_i

        if @record.save
          render :json => {:status => "OK", :msg => {id: @record.id}}
        else
          render :json => {:status => "ERR", :msg => @record.first.last}
        end
      else
        @record = TaskJgBsb.find(params[:pk])
        @record.quota = params[:value].to_i

        if @record.save
          render :json => {:status => "OK", :msg => {id: @record.id}}
        else
          render :json => {:status => "ERR", :msg => @record.first.last}
        end
      end
    else
      render :json => {:status => "ERR", :msg => "请填写数字"}
    end
  end

  # 创建新的抽样安排，中央转移省级，省级下达给检测机构
  def create_delegate_plan
    if params[:jg_id].blank? or params[:dl].blank? or params[:quota].blank?
      render json: {status: 'ERR', msg: '请提供必要参数'}
    else
     # if  current_user.prov_country.nil? or current_user.prov_country.blank? or  %w{ -请选择- }.include?(current_user.prov_country)
      #  info = current_user.prov_city;
      #  @province = SysProvince.level1.find_by_name(info)
      #else
      #  info = current_user.prov_country;
      #  @province = SysProvince.level2.find_by_name(info)
      #end
      @province = SysProvince.level1.find_by_name(current_user.prov_city)
      @plan = TaskJgBsb.new(identifier: params[:identifier], sys_province_id: @province.id, jg_bsb_id: params[:jg_id], :a_category_id => params[:dl], :quota => params[:quota])

      destroy_category_level = 'a_category_id'

      if params[:yl].to_i != 0
        @plan.b_category_id = params[:yl]
        destroy_category_level = 'b_category_id'
      end

      if params[:cyl].to_i != 0
        @plan.c_category_id = params[:cyl]
        destroy_category_level = 'c_category_id'
      end

      if params[:xl].to_i != 0
        @plan.d_category_id = params[:xl]
        destroy_category_level = 'd_category_id'
      end

      # 强制清除已经部署的与当前有冲突的任务
      TaskJgBsb.where("identifier = ? and sys_province_id = ? and jg_bsb_id = ? and (#{destroy_category_level} is NULL or #{destroy_category_level} = ?)", params[:identifier], @province.id, params[:jg_id], @plan[destroy_category_level]).destroy_all

      if @plan.save
        render json: {status: 'OK', msg: "成功！"}
      else
        render json: {status: 'ERR', msg: @plan.errors.first.last}
      end
    end
  end

  # 任务下达&安排
  def assign
    @jg_bsb = current_user.jg_bsb

    @baosong_as = BaosongA.by_identifiers(TaskJgBsb.where('jg_bsb_id = ?', @jg_bsb.id).map { |task| task.identifier })

    unless params[:baosong_a].blank?
      @baosong_a = BaosongA.find_by_name(params[:baosong_a])
      @baosong_bs = @baosong_a.baosong_bs

      @baosong_b = @baosong_bs.where(name: params[:baosong_b]).last
      #if !current_user.is_admin?
      #  @baosong_bs = @baosong_bs.where("prov = ? OR prov IS NULL OR prov = ''", current_user.user_s_province)
      #end
    end

    @tasks = TaskJgBsb.where(:jg_bsb_id => @jg_bsb.id)

    # 任务来源
    @rwly = []
    @tasks.joins('LEFT JOIN sys_provinces on sys_provinces.id=task_jg_bsbs.sys_province_id').select('distinct(task_jg_bsbs.sys_province_id), sys_provinces.name').each do |task|
      if task.sys_province_id == -1
        @rwly.unshift(["#{SysConfig.get(SysConfig::Key::PROV)}食品药品监督管理局", -1])
      else
        if  current_user.prov_country.nil? or current_user.prov_country.blank? or  %w{ -请选择- }.include?(current_user.prov_country)
          info = current_user.prov_city;
          if(info.nil? or info.blank? or %w{ -请选择- }.include?(info))
          @province = SysProvince.level1.find_by_name(current_user.user_s_province)
          @rwly.push(["#{current_user.user_s_province}食品药品监督管理局", @province.id])
          else
          @province = SysProvince.level1.find_by_name(info)
          @rwly.push(["#{info}食品药品监督管理局", @province.id])
          end
        else
          info = current_user.prov_country;
          @province = SysProvince.level2.find_by_name(info)
          @rwly.push(["#{info}食品药品监督管理局", @province.id])
        end
        #@rwly.push(["#{task.name}食品药品监督管理局", task.sys_province_id])
      end
    end

    if @baosong_b.nil?
      @d_categories = []
      @tasks = []
      @delegate = nil
      @a_categories = []
      @baosong_bs = []
    else
      # ACategory
      @a_categories = ACategory.select('distinct(a_categories.id), a_categories.*').joins('RIGHT JOIN task_jg_bsbs AS ab ON ab.a_category_id=a_categories.id').where('a_categories.identifier = ? AND ab.jg_bsb_id = ?', @baosong_b.identifier, @jg_bsb.id)

      # Task
      info_s = current_user.prov_city;
      @province_s = SysProvince.level1.find_by_name(info_s)
      if @province_s.nil? or @province_s.blank?
        @tasks = TaskJgBsb.where(:jg_bsb_id => @jg_bsb.id, :sys_province_id => params[:rwly]) #, identifier: @baosong_b.identifier)
      else
        if @province_s.id == params[:rwly] || params[:rwly] == -1
          @tasks = TaskJgBsb.where(:jg_bsb_id => @jg_bsb.id, :sys_province_id => params[:rwly]) #, identifier: @baosong_b.identifier)
        else
          @tasks = TaskJgBsb.where(:jg_bsb_id => @jg_bsb.id, :sys_province_id => @province_s.id) #, identifier: @baosong_b.identifier)
        end
      end
      @delegate = @tasks.select('jg_bsb_id').first

      d_category_ids = []
      @tasks.each do |t|
        d_category_ids.concat DCategory.where(a_category_id: t.a_category_id, identifier: @baosong_b.identifier).map { |d| d.id }
      end
      d_category_ids.uniq!
      @d_categories = DCategory.where(id: d_category_ids, identifier: @baosong_b.identifier).order("a_category_id, b_category_id, c_category_id")
    end
  end

  def check
    @jg_bsb = current_user.jg_bsb
    case params[:tab].to_i
      when 0
        if current_user.is_admin?
          @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => ::PadSpBsb::Step::FINISHED)
        elsif session[:change_js]==10
          @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => ::PadSpBsb::Step::FINISHED, :sp_s_43 => @jg_bsb.all_names)
        else
          @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => ::PadSpBsb::Step::TMP_SAVE, :sp_s_43 => @jg_bsb.all_names)
        end
      when 1
        @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => [::PadSpBsb::Step::DEPLOYED, ::PadSpBsb::Step::ACCEPTED, ::PadSpBsb::Step::ARRIVED], :sp_s_43 => @jg_bsb.all_names)
      when 2
        @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => [::PadSpBsb::Step::FINISHED, ::PadSpBsb::Step::FAILED, ::PadSpBsb::Step::SAMPLE_ACCEPTED, ::PadSpBsb::Step::SAMPLE_REFUSED], :sp_s_43 => @jg_bsb.all_names)
      when 3
        @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => ::PadSpBsb::Step::SAMPLE_REFUSED, :sp_s_43 => @jg_bsb.all_names)
    end

    unless params[:begin_time].blank?
      @begin_time = DateTime.parse(params[:begin_time]).beginning_of_day
    else
      @begin_time = (Time.now - 30.days).beginning_of_day
    end

    unless params[:ending_time].blank?
      @end_time = DateTime.parse(params[:ending_time]).end_of_day
    else
      @end_time = Time.now.end_of_day
    end
    unless params[:rwly].blank?
        if params[:rwly].to_i != -1
          @sysProvince  =   SysProvince.find(params[:rwly].to_i)
          @pad_sp_bsbs = @pad_sp_bsbs.where('sp_s_4 LIKE ?',"%#{@sysProvince.name}%" )
        end
      # TODO: 完善取数据逻辑
    end

    unless params[:sp_s_35].blank?
      @pad_sp_bsbs = @pad_sp_bsbs.where('sp_s_35 LIKE ?', "%#{params[:sp_s_35]}%")
    end

    unless params[:sp_s_43].blank?
      @pad_sp_bsbs = @pad_sp_bsbs.where('sp_s_43 LIKE ?', "%#{params[:sp_s_43]}%")
    end

    unless params[:sp_s_64].blank?
      @pad_sp_bsbs = @pad_sp_bsbs.where('sp_s_64 LIKE ?', "%#{params[:sp_s_64]}%")
    end

    unless params[:sp_s_1].blank?
      @pad_sp_bsbs = @pad_sp_bsbs.where('sp_s_1 LIKE ?', "%#{params[:sp_s_1]}%")
    end

    unless params[:sp_s_14].blank?
      @pad_sp_bsbs = @pad_sp_bsbs.where('sp_s_14 LIKE ?', "%#{params[:sp_s_14]}%")
    end

    if !params[:sp_s_17].blank? and !params[:sp_s_17].eql?('请选择')
      @pad_sp_bsbs = @pad_sp_bsbs.where('sp_s_17 LIKE ?', "%#{params[:sp_s_17]}%")
    end

    unless params[:sp_s_20].blank?
      @pad_sp_bsbs = @pad_sp_bsbs.where('sp_s_20 LIKE ?', "%#{params[:sp_s_20]}%")
    end

    if !params[:sp_s_3].blank? and !params[:sp_s_3].eql?('请选择')
      @pad_sp_bsbs = @pad_sp_bsbs.where('sp_s_3 LIKE ?', "%#{params[:sp_s_3]}%")
    end

    unless params[:sp_s_2].blank?
      @pad_sp_bsbs = @pad_sp_bsbs.where('sp_s_2 LIKE ?', "%#{params[:sp_s_2]}%")
    end

    unless params[:sp_s_85].blank?
      @pad_sp_bsbs = @pad_sp_bsbs.where('sp_s_85 LIKE ?', "%#{params[:sp_s_85]}%")
    end

    unless params[:sp_s_16].blank?
      @pad_sp_bsbs = @pad_sp_bsbs.where('sp_s_16 LIKE ?', "%#{params[:sp_s_16]}%")
    end

    @pad_sp_bsbs = @pad_sp_bsbs.paginate(:page => (params[:page].present? ? params[:page].to_i : 1), :per_page => 10).order("updated_at DESC")
  end
end
