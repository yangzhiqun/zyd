#encoding: utf-8
class TasksController < ApplicationController
  include ApplicationHelper
   skip_before_filter :check_quota_amount, :only => [:create_direct_plan]
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
      logger.error "params[:tab].to_i"
      logger.error params[:tab].to_i
      if current_user.is_admin? || params[:tab].to_i == 2 ||is_sheng? || params[:tab].to_i ==0
        # 取出省级Province
        if  params[:tab].to_i == 2
         @provinces = SysProvince.level3(current_user.prov_city)
        else
         @provinces = SysProvince.level1
        end
        if @baosong_b.nil?
          @a_categories = []
        else
          @a_categories = @baosong_b.a_categories
        end

        # 总局本级任务
        if params[:tab].to_i == 0
          # 所有检测机构，按名称排序
          #@jg_bsbs = JgBsb.where(status: 0)
          @jg_bsbs = JgBsb.where("status= 0")
          # 如果没有选择报送分类B，则不显示
         # logger.error "@baosong_b"
         # logger.error @baosong_b
          @province = get_province?
          if @baosong_b.nil?
            @tasks = []
          else
            if current_user.is_admin? || (is_shengshi?&&jg_is_province?) || jg_is_province?
              @tasks = TaskJgBsb.where(identifier: @baosong_b.identifier)
            else
              @tasks = TaskJgBsb.where(sys_province_id: @province.id, identifier: @baosong_b.identifier)
            end
            
          end

          count = TaskJgBsb.select('count(distinct(jg_bsb_id)) as count').where(:sys_province_id => -1)
          if @baosong_b.present?
            count = count.where(identifier: @baosong_b.identifier)
          end
            @count = count.first.count
        end
      else
         # 省局任务部署
           #@province = SysProvince.level1.find_by_name(current_user.prov_city)
           # if is_sheng?
						#	@province = SysProvince.level1
          @province = get_province?
        #end
        tasks = @province.task_provinces
	      #@jg_bsbs = JgBsb.where(status: 0)
          @jg_bsbs = JgBsb.where("status= 0")
        unless params[:baosong_a].blank?
          @baosong_a = BaosongA.find_by_name(params[:baosong_a])
          @baosong_bs = BaosongB.where(:baosong_a_id => @baosong_a.id)

          @baosong_b = @baosong_bs.where(name: params[:baosong_b]).last
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
       if params[:tab].to_i ==2
        @delegates = TaskJgBsb.select('distinct(jg_bsb_id),sys_province_id').where(:sys_province_id => @province.id,:status => 1)
       else
        @delegates = TaskJgBsb.select('distinct(jg_bsb_id),sys_province_id').where(:sys_province_id => @province.id,:is_national =>0)
        end
      @count = @delegates.count
        # TODO: 如何精准筛选剩余部分
        #if current_user.is_admin?
         # @cyjgs = JgBsb.where(:jg_sampling => 1, status: 0)
        #else
       # if current_user.is_city?
        #  @cyjgs = JgBsb.where(:jg_sampling => 1, status: 0,:city => current_user.prov_city)
        # elsif  current_user.is_county_level?
        #  @cyjgs = JgBsb.where(:jg_sampling => 1, status: 0,:city => current_user.prov_city,:country => current_user.prov_country)
        # else
        #  @cyjgs = JgBsb.where(:jg_sampling => 1, status: 0)
        # end
        #end 
       #  @cyjgs = JgBsb.where(:jg_sampling => 1, status: 0)
       #   @cyjgs = JgBsb.where("status= 0 and id=? and jg_sampling >= 1 ",current_user.jg_bsb.id)
        @jyjgs = JgBsb.where(status: 0)
      end
    end
  end

  # 委托地方承担的抽样任务
  def create_prov_plan
    if params[:prov].blank? or params[:dl].blank? or params[:quota].blank?
      render json: {status: 'ERR', msg: '请提供必要参数'}
    else
      @plan = TaskProvince.new(identifier: params[:identifier], sys_province_id: params[:prov], :a_category_id => params[:dl], :quota => params[:quota])
     if current_user.is_city?
      @plan.status=1
     end
     
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
      TaskProvince.where("identifier = ? and sys_province_id = ? and #{destroy_category_level} = ?", params[:identifier], params[:prov], @plan[destroy_category_level]).destroy_all

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
       if is_shi_deploy? # current_user.is_city?
        sysProvince =SysProvince.level1.find_by_name(current_user.jg_bsb.city)
        sys_province_id= sysProvince.id
      elsif is_xian_deploy?# current_user.is_county_level?
        sysProvince=SysProvince.level3(current_user.jg_bsb.city).find_by_name(current_user.jg_bsb.country)
        sys_province_id= sysProvince.id
      else
        sys_province_id = -1 
      end

      @plan = TaskJgBsb.new(identifier: params[:identifier], sys_province_id: sys_province_id, is_national: true, test_jg_bsb_id: params[:test_jg_id], jg_bsb_id: params[:jg_id], :a_category_id => params[:dl], :quota => params[:quota])

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
      TaskJgBsb.where("identifier = ? and sys_province_id = #{sys_province_id} and jg_bsb_id = ? and  #{destroy_category_level} = ?", params[:identifier], params[:jg_id], @plan[destroy_category_level]).destroy_all

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
      @province = get_province?
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
      TaskJgBsb.where("identifier = ? and sys_province_id = ? and jg_bsb_id = ? and  #{destroy_category_level} = ?", params[:identifier], @province.id, params[:jg_id], @plan[destroy_category_level]).destroy_all

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
    @rwly = all_super_departments
    logger.error @rwly.to_json

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
      info_s = current_user.user_s_province
      if is_shi_deploy?
     		info_s = current_user.jg_bsb.city
				@province_s = SysProvince.level1.find_by_name(info_s)
        @tasks = TaskJgBsb.where(:jg_bsb_id => @jg_bsb.id, :sys_province_id => [@province_s.id,-1])
      elsif is_xian_deploy?
      	info_s = current_user.jg_bsb.country
				@province_s = SysProvince.level2.find_by_name(info_s)
        @tasks = TaskJgBsb.where(:jg_bsb_id => @jg_bsb.id, :sys_province_id => [@province_s.id,-1])
      else
        @tasks = TaskJgBsb.where(:jg_bsb_id => @jg_bsb.id)
			end
      
    
      @delegate = @tasks.select('jg_bsb_id').first
      d_category_ids = []
      @tasks.each do |t|
        d_category_ids.concat DCategory.where(a_category_id: t.a_category_id, identifier: @baosong_b.identifier).map { |d| d.id }
      end
      d_category_ids.uniq!
      #@d_categories = DCategory.where(id: d_category_ids, identifier: @baosong_b.identifier).order("a_category_id, b_category_id, c_category_id")
      @d_categories = DCategory.where('id in (?) and identifier = ?', d_category_ids, @baosong_b.identifier).order("a_category_id, b_category_id, c_category_id")
    end
  end

  def check
    @jg_bsb = current_user.jg_bsb
	  if @jg_bsb.jg_type ==1
      begin
        super_jg = JgBsbSuper.where(super_jg_bsb_id: @jg_bsb.id ).group("jg_bsb_id")
        jg_names=[]
        jg_names.push(@jg_bsb.jg_name)
        super_jg.each do |j|
          if !j.jg_bsb.blank?
           jg_names.push(j.jg_bsb.jg_name)
          end
        end
     # rescue
      end
    elsif @jg_bsb.jg_type ==3
      jg_names=[@jg_bsb.jg_name]
    end
    @rwly = all_super_departments 
    case params[:tab].to_i
      when 0
        if current_user.is_admin? || is_sheng? 
          @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => ::PadSpBsb::Step::TMP_SAVE)
        elsif session[:change_js]==10
          @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => ::PadSpBsb::Step::TMP_SAVE, :sp_s_43 => jg_names)
        elsif is_city?
          @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => ::PadSpBsb::Step::TMP_SAVE, :sp_s_2_1 => @rwly)
        elsif is_county_level?
          @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => ::PadSpBsb::Step::TMP_SAVE, :sp_s_2_1 => @rwly)
        else
          @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => ::PadSpBsb::Step::TMP_SAVE, :sp_s_43 => jg_names,:sp_s_35 => @jg_bsb.jg_name)
        end
      when 1
        if current_user.is_admin? || is_sheng?
          @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => [::PadSpBsb::Step::DEPLOYED, ::PadSpBsb::Step::ACCEPTED, ::PadSpBsb::Step::ARRIVED])
        elsif is_city?
          @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => [::PadSpBsb::Step::DEPLOYED, ::PadSpBsb::Step::ACCEPTED, ::PadSpBsb::Step::ARRIVED], :sp_s_2_1 => @rwly)
        elsif is_county_level?
          @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => [::PadSpBsb::Step::DEPLOYED, ::PadSpBsb::Step::ACCEPTED, ::PadSpBsb::Step::ARRIVED], :sp_s_2_1 => @rwly)
        else 
          @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => [::PadSpBsb::Step::DEPLOYED, ::PadSpBsb::Step::ACCEPTED, ::PadSpBsb::Step::ARRIVED], :sp_s_43 => jg_names,:sp_s_35 => @jg_bsb.jg_name)
        end
      when 2
        if current_user.is_admin? || is_sheng?
          @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => [::PadSpBsb::Step::FINISHED, ::PadSpBsb::Step::FAILED, ::PadSpBsb::Step::SAMPLE_ACCEPTED, ::PadSpBsb::Step::SAMPLE_REFUSED])
        elsif is_city?
          @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => [::PadSpBsb::Step::FINISHED, ::PadSpBsb::Step::FAILED, ::PadSpBsb::Step::SAMPLE_ACCEPTED, ::PadSpBsb::Step::SAMPLE_REFUSED], :sp_s_2_1 => @rwly)
        elsif is_county_level?
          @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => [::PadSpBsb::Step::FINISHED, ::PadSpBsb::Step::FAILED, ::PadSpBsb::Step::SAMPLE_ACCEPTED, ::PadSpBsb::Step::SAMPLE_REFUSED], :sp_s_2_1 => @rwly)
        else 
        @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => [::PadSpBsb::Step::FINISHED, ::PadSpBsb::Step::FAILED, ::PadSpBsb::Step::SAMPLE_ACCEPTED, ::PadSpBsb::Step::SAMPLE_REFUSED], :sp_s_43 => jg_names,:sp_s_35 => @jg_bsb.jg_name)
        end
      when 3
        if current_user.is_admin? || is_sheng?
          @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => ::PadSpBsb::Step::SAMPLE_REFUSED)
        elsif is_city?
          @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => ::PadSpBsb::Step::SAMPLE_REFUSED, :sp_s_2_1 => @rwly)
        elsif is_county_level?
          @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => ::PadSpBsb::Step::SAMPLE_REFUSED, :sp_s_2_1 => @rwly)
        else 
          @pad_sp_bsbs = PadSpBsb.where(:sp_i_state => ::PadSpBsb::Step::SAMPLE_REFUSED, :sp_s_43 => jg_names)
        end
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

		# 任务来源	
		if  !params[:rwly].blank? and params[:rwly] !="全部"
			@pad_sp_bsbs = @pad_sp_bsbs.where("sp_s_2_1 LIKE ?", "%#{params[:rwly]}%")	
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
  def assign_validate
    count= TaskJgBsb.where("jg_bsb_id = ? AND a_category_id = ? AND b_category_id=?  AND c_category_id=?  AND d_category_id =?",
                    params[:jg_bsb_id],params[:a_category_id],params[:b_category_id],params[:c_category_id],params[:d_category_id] ).count
      if count ==0
        render :json => {status: 'ERR', msg: "请先部署！！"} and return
      end
      render :json => {status: 'OK', msg: "OK"}
  end
end
