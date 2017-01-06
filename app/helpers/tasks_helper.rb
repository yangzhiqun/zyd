#encoding: utf-8
module TasksHelper
  def grid(province_id, category_id)
    @record = TaskProvince.where(:sys_province_id => province_id, :a_category_id => category_id).first
    if @record.blank?
      "<a href='javascript:void(0);' class='editable' data-name='{\"p_id\":#{province_id}, \"c_id\":#{category_id}}' data-type='text' data-pk='' data-url='/tasks/deploy.json' data-title='输入计划采样数量'></a>".html_safe
    else
      "<a href='javascript:void(0);' class='editable' data-type='text' data-pk='#{@record.id}' data-url='/tasks/deploy.json' data-title='输入计划采样数量'>#{@record.quota}</a>".html_safe
    end
  end

  # 省局的Grid
  def grid2(province_id, category_id, jg_id)
    @record = TaskJgBsb.where(:sys_province_id => province_id, :a_category_id => category_id, :jg_bsb_id => jg_id).first
    if @record.blank?
      "<a href='javascript:void(0);' class='editable' data-name='{\"p_id\":#{province_id}, \"c_id\":#{category_id}, \"jg_id\":#{jg_id}}' data-type='text' data-pk='' data-url='/tasks/deploy_prov.json' data-title='输入计划委托数量'></a>".html_safe
    else
      "<a href='javascript:void(0);' class='editable' data-type='text' data-pk='#{@record.id}' data-url='/tasks/deploy_prov.json' data-title='输入计划委托数量'>#{@record.quota if @record.quota != 0}</a>".html_safe
    end
  end

  # 国家局下达的省局抽验任务
  def grid3(prov, xl)
    logger.error "prov==============="
    logger.error prov.to_json
    @result = [] if @result.blank?

    @query = TaskProvince.where("sys_province_id = ? AND a_category_id = ?", prov.id, xl.a_category_id)
    # A
    if (@count = @query.sum("quota")) > 0 and @query.where("b_category_id IS NULL AND c_category_id IS NULL AND d_category_id IS NULL").sum("quota") == @count
      tag = "#{xl.a_category_id}_#_#_#_#{prov.id}"
      unless @result.include?(tag)
        @result.push(tag)
        html = <<-EOF
          <td rowspan='#{ACategory.find(xl.a_category_id).rowspan}'><i class='text-success'>抽样计划：#{@count}</i></td>
        EOF
        html.html_safe
      end
    # B
    elsif (@count = @query.where("b_category_id = ?", xl.b_category_id).sum("quota")) > 0 and @count == @query.where("b_category_id = ? AND c_category_id IS NULL AND d_category_id IS NULL", xl.b_category_id).sum("quota") 
      tag = "#{xl.a_category_id}_#{xl.b_category_id}_#_#_#{prov.id}"
      unless @result.include?(tag)
        @result.push(tag)
        html = <<-EOF
          <td rowspan='#{BCategory.find(xl.b_category_id).rowspan}'><i class='text-success'>抽样计划：#{@count}</i></td>
        EOF
        html.html_safe
      end
    # C
    elsif (@count = @query.where("b_category_id = ? AND c_category_id = ? AND d_category_id IS NULL", xl.b_category_id, xl.c_category_id).sum('quota')) > 0 and @count == @query.where("b_category_id = ? AND c_category_id = ?", xl.b_category_id, xl.c_category_id).sum('quota')
      tag = "#{xl.a_category_id}_#{xl.b_category_id}_#{xl.c_category_id}_#_#{prov.id}"
      unless @result.include?(tag)
        @result.push(tag)
        html = <<-EOF
          <td rowspan='#{CCategory.find(xl.c_category_id).rowspan}'><i class='text-success'>抽样计划：#{@count}</i></td>
        EOF
        html.html_safe
      end
    # D
    elsif (@count = TaskProvince.where("sys_province_id = ? AND a_category_id = ? AND b_category_id = ? AND c_category_id = ? AND d_category_id = ?", prov.id, xl.a_category_id, xl.b_category_id, xl.c_category_id, xl.id).sum('quota')) > 0
      tag = "#{xl.a_category_id}_#{xl.b_category_id}_#{xl.c_category_id}_#{xl.id}_#{prov.id}"
      unless @result.include?(tag)
        @result.push(tag)
        html = <<-EOF
          <td><i class='text-success'>抽样计划：#{@count}</i></td>
        EOF
        html.html_safe
      end
    else
      html = <<-EOF
        <td>/</td>
      EOF
      html.html_safe
    end
  end

  # 国家局下达的局本级抽验任务
  def grid4(task, xl)
    @result = [] if @result.blank?
    logger.error task.to_json
    @query = TaskJgBsb.where("sys_province_id = ? AND jg_bsb_id = ? AND a_category_id = ? AND identifier = ?",task.sys_province_id,task.jg_bsb_id, xl.a_category_id, xl.identifier)
    # A
    if (@count = @query.sum("quota")) > 0 and @query.where("b_category_id IS NULL AND c_category_id IS NULL AND d_category_id IS NULL").sum("quota") == @count
      tag = "#{xl.a_category_id}_#_#_#_#{task.jg_bsb_id}"
      unless @result.include?(tag)
        @result.push(tag)
        html = <<-EOF
          <td rowspan='#{ACategory.find(xl.a_category_id).rowspan}'><i class='text-success'>抽样计划：#{@count}</i></td>
        EOF
        html.html_safe
      end
    # B
    elsif (@count = @query.where("b_category_id = ?", xl.b_category_id).sum("quota")) > 0 and @count == @query.where("b_category_id = ? AND c_category_id IS NULL AND d_category_id IS NULL", xl.b_category_id).sum("quota") 
      tag = "#{xl.a_category_id}_#{xl.b_category_id}_#_#_#{task.jg_bsb_id}"
      unless @result.include?(tag)
        @result.push(tag)
        html = <<-EOF
          <td rowspan='#{BCategory.find(xl.b_category_id).rowspan}'><i class='text-success'>抽样计划：#{@count}</i></td>
        EOF
        html.html_safe
      end
    # C
    elsif (@count = @query.where("b_category_id = ? AND c_category_id = ? AND d_category_id IS NULL", xl.b_category_id, xl.c_category_id).sum('quota')) > 0 and @count == @query.where("b_category_id = ? AND c_category_id = ?", xl.b_category_id, xl.c_category_id).sum('quota')
      tag = "#{xl.a_category_id}_#{xl.b_category_id}_#{xl.c_category_id}_#_#{task.jg_bsb_id}"
      unless @result.include?(tag)
        @result.push(tag)
        html = <<-EOF
          <td rowspan='#{CCategory.find(xl.c_category_id).rowspan}'><i class='text-success'>抽样计划：#{@count}</i></td>
        EOF
        html.html_safe
      end
    # D
    elsif (@count = TaskJgBsb.where("sys_province_id = ? AND jg_bsb_id = ? AND a_category_id = ? AND b_category_id = ? AND c_category_id = ? AND d_category_id = ? AND identifier = ?",task.sys_province_id ,task.jg_bsb_id, xl.a_category_id, xl.b_category_id, xl.c_category_id, xl.id, xl.identifier).sum('quota')) > 0
      tag = "#{xl.a_category_id}_#{xl.b_category_id}_#{xl.c_category_id}_#{xl.id}_#{task.jg_bsb_id}"
      unless @result.include?(tag)
        @result.push(tag)
        html = <<-EOF
          <td><i class='text-success'>抽样计划：#{@count}</i></td>
        EOF
        html.html_safe
      end
    else
      html = <<-EOF
        <td>/</td>
      EOF
      html.html_safe
    end
  end  

  # 省局下达的抽验任务
  def grid5(task, xl)
    @result = [] if @result.blank?

    @query = TaskJgBsb.where("sys_province_id = ? AND jg_bsb_id = ? AND a_category_id = ?", @province.id, task.jg_bsb_id, xl.a_category_id)
    # A
    if (@count = @query.sum("quota")) > 0 and @query.where("b_category_id IS NULL AND c_category_id IS NULL AND d_category_id IS NULL").sum("quota") == @count
      tag = "#{xl.a_category_id}_#_#_#_#{task.jg_bsb_id}"
      unless @result.include?(tag)
        @result.push(tag)
        html = <<-EOF
          <td rowspan='#{ACategory.find(xl.a_category_id).rowspan}'><i class='text-success'>抽样计划：#{@count}</i></td>
        EOF
        html.html_safe
      end
    # B
    elsif (@count = @query.where("b_category_id = ?", xl.b_category_id).sum("quota")) > 0 and @count == @query.where("b_category_id = ? AND c_category_id IS NULL AND d_category_id IS NULL", xl.b_category_id).sum("quota") 
      tag = "#{xl.a_category_id}_#{xl.b_category_id}_#_#_#{task.jg_bsb_id}"
      unless @result.include?(tag)
        @result.push(tag)
        html = <<-EOF
          <td rowspan='#{BCategory.find(xl.b_category_id).rowspan}'><i class='text-success'>抽样计划：#{@count}</i></td>
        EOF
        html.html_safe
      end
    # C
    elsif (@count = @query.where("b_category_id = ? AND c_category_id = ? AND d_category_id IS NULL", xl.b_category_id, xl.c_category_id).sum('quota')) > 0 and @count == @query.where("b_category_id = ? AND c_category_id = ?", xl.b_category_id, xl.c_category_id).sum('quota')
      tag = "#{xl.a_category_id}_#{xl.b_category_id}_#{xl.c_category_id}_#_#{task.jg_bsb_id}"
      unless @result.include?(tag)
        @result.push(tag)
        html = <<-EOF
          <td rowspan='#{CCategory.find(xl.c_category_id).rowspan}'><i class='text-success'>抽样计划：#{@count}</i></td>
        EOF
        html.html_safe
      end
    # D
    elsif (@count = TaskJgBsb.where("sys_province_id = ? AND jg_bsb_id = ? AND a_category_id = ? AND b_category_id = ? AND c_category_id = ? AND d_category_id = ? AND is_national = 0", @province.id, task.jg_bsb_id, xl.a_category_id, xl.b_category_id, xl.c_category_id, xl.id).sum('quota')) > 0
      tag = "#{xl.a_category_id}_#{xl.b_category_id}_#{xl.c_category_id}_#{xl.id}_#{task.jg_bsb_id}"
      unless @result.include?(tag)
        @result.push(tag)
        html = <<-EOF
          <td><i class='text-success'>抽样计划：#{@count}</i></td>
        EOF
        html.html_safe
      end
    else
      html = <<-EOF
        <td>/</td>
      EOF
      html.html_safe
    end
  end

    # 检测机构的抽验任务
  def grid6(task, xl)
    @result = [] if @result.blank?

    @query = TaskJgBsb.where("jg_bsb_id = ? AND a_category_id = ?", task.jg_bsb_id, xl.a_category_id)
    @jg_bsb = JgBsb.find(task.jg_bsb_id)

    @a_category = ACategory.find(xl.a_category_id)
    @b_category = BCategory.find(xl.b_category_id)
    @c_category = CCategory.find(xl.c_category_id)

    # A
    if (@count = @query.sum("quota")) > 0 and @query.where("b_category_id IS NULL AND c_category_id IS NULL AND d_category_id IS NULL").sum("quota") == @count
      tag = "#{xl.a_category_id}_#_#_#_#{task.jg_bsb_id}"
      unless @result.include?(tag)
        @result.push(tag)

        deployed_count = PadSpBsb.where("sp_s_35 = ? and sp_s_17 = ? AND sp_i_state IN (?)", @jg_bsb.jg_name, @a_category.name, [::PadSpBsb::Step::DEPLOYED, ::PadSpBsb::Step::ACCEPTED, ::PadSpBsb::Step::ARRIVED]).count
        finished_count = PadSpBsb.where("sp_s_35 = ? and sp_s_17 = ? AND sp_i_state IN (?)", @jg_bsb.jg_name, @a_category.name, [::PadSpBsb::Step::FINISHED, ::PadSpBsb::Step::FAILED, ::PadSpBsb::Step::SAMPLE_ACCEPTED, ::PadSpBsb::Step::SAMPLE_REFUSED]).count

        html = <<-EOF
          <td rowspan='#{ACategory.find(xl.a_category_id).rowspan}'>
            抽样计划：<i class='text-success'>#{@count}</i><br>
            已下达数：#{deployed_count}<br>
            采样完成：#{finished_count}<br>
            未下达数：#{@count - (deployed_count + finished_count)}<br>
            完成率：#{number_to_percentage((finished_count.to_f/@count) * 100, precision: 2)}<br>
          </td>
        EOF
        html.html_safe
      end
    # B
    elsif (@count = @query.where("b_category_id = ?", xl.b_category_id).sum("quota")) > 0 and @count == @query.where("b_category_id = ? AND c_category_id IS NULL AND d_category_id IS NULL", xl.b_category_id).sum("quota") 
      tag = "#{xl.a_category_id}_#{xl.b_category_id}_#_#_#{task.jg_bsb_id}"
      unless @result.include?(tag)
        @result.push(tag)

        deployed_count = PadSpBsb.where("sp_s_35 = ? and sp_s_17 = ? AND sp_s_18 = ? AND sp_i_state IN (?)", @jg_bsb.jg_name, @a_category.name, @b_category.name, [::PadSpBsb::Step::DEPLOYED, ::PadSpBsb::Step::ACCEPTED, ::PadSpBsb::Step::ARRIVED]).count
        finished_count = PadSpBsb.where("sp_s_35 = ? and sp_s_17 = ? AND sp_s_18 = ? AND sp_i_state IN (?)", @jg_bsb.jg_name, @a_category.name, @b_category.name, [::PadSpBsb::Step::FINISHED, ::PadSpBsb::Step::FAILED, ::PadSpBsb::Step::SAMPLE_ACCEPTED, ::PadSpBsb::Step::SAMPLE_REFUSED]).count

        html = <<-EOF
          <td rowspan='#{BCategory.find(xl.b_category_id).rowspan}'>
            抽样计划：<i class='text-success'>#{@count}</i><br>
            已下达数：#{deployed_count}<br>
            采样完成：#{finished_count}<br>
            未下达数：#{@count - (deployed_count + finished_count)}<br>
            完成率：#{number_to_percentage((finished_count.to_f/@count) * 100, precision: 2)}<br>
          </td>
        EOF
        html.html_safe
      end
    # C
    elsif (@count = @query.where("b_category_id = ? AND c_category_id = ? AND d_category_id IS NULL", xl.b_category_id, xl.c_category_id).sum('quota')) > 0 and @count == @query.where("b_category_id = ? AND c_category_id = ?", xl.b_category_id, xl.c_category_id).sum('quota')
      tag = "#{xl.a_category_id}_#{xl.b_category_id}_#{xl.c_category_id}_#_#{task.jg_bsb_id}"
      unless @result.include?(tag)
        @result.push(tag)

        deployed_count = PadSpBsb.where("sp_s_35 = ? and sp_s_17 = ? AND sp_s_18 = ? AND sp_s_19 = ? AND sp_i_state IN (?)", @jg_bsb.jg_name, @a_category.name, @b_category.name, @c_category.name, [::PadSpBsb::Step::DEPLOYED, ::PadSpBsb::Step::ACCEPTED, ::PadSpBsb::Step::ARRIVED]).count
        finished_count = PadSpBsb.where("sp_s_35 = ? and sp_s_17 = ? AND sp_s_18 = ? AND sp_s_19 = ? AND sp_i_state IN (?)", @jg_bsb.jg_name, @a_category.name, @b_category.name, @c_category.name, [::PadSpBsb::Step::FINISHED, ::PadSpBsb::Step::FAILED, ::PadSpBsb::Step::SAMPLE_ACCEPTED, ::PadSpBsb::Step::SAMPLE_REFUSED]).count

        html = <<-EOF
          <td rowspan='#{CCategory.find(xl.c_category_id).rowspan}'>
            抽样计划：<i class='text-success'>#{@count}</i><br>
            已下达数：#{deployed_count}<br>
            采样完成：#{finished_count}<br>
            未下达数：#{@count - (deployed_count + finished_count)}<br>
            完成率：#{number_to_percentage((finished_count.to_f/@count) * 100, precision: 2)}<br>
          </td>
        EOF
        html.html_safe
      end
    # D
    elsif (@count = TaskJgBsb.where("jg_bsb_id = ? AND a_category_id = ? AND b_category_id = ? AND c_category_id = ? AND d_category_id = ?", task.jg_bsb_id, xl.a_category_id, xl.b_category_id, xl.c_category_id, xl.id).sum('quota')) > 0
      tag = "#{xl.a_category_id}_#{xl.b_category_id}_#{xl.c_category_id}_#{xl.id}_#{task.jg_bsb_id}"
      unless @result.include?(tag)
        @result.push(tag)

        deployed_count = PadSpBsb.where("sp_s_35 = ? and sp_s_17 = ? AND sp_s_18 = ? AND sp_s_19 = ? AND sp_s_20 = ? AND sp_i_state IN (?)", @jg_bsb.jg_name, @a_category.name, @b_category.name, @c_category.name, xl.name, [::PadSpBsb::Step::DEPLOYED, ::PadSpBsb::Step::ACCEPTED, ::PadSpBsb::Step::ARRIVED]).count
        finished_count = PadSpBsb.where("sp_s_35 = ? and sp_s_17 = ? AND sp_s_18 = ? AND sp_s_19 = ? AND sp_s_20 = ? AND sp_i_state IN (?)", @jg_bsb.jg_name, @a_category.name, @b_category.name, @c_category.name, xl.name, [::PadSpBsb::Step::FINISHED, ::PadSpBsb::Step::FAILED, ::PadSpBsb::Step::SAMPLE_ACCEPTED, ::PadSpBsb::Step::SAMPLE_REFUSED]).count

        html = <<-EOF
          <td>
            抽样计划：<i class='text-success'>#{@count}</i><br>
            已下达数：#{deployed_count}<br>
            采样完成：#{finished_count}<br>
            未下达数：#{@count - (deployed_count + finished_count)}<br>
            完成率：#{number_to_percentage((finished_count.to_f/@count) * 100, precision: 2)}<br>
          </td>
        EOF
        html.html_safe
      end
    else
      html = <<-EOF
        <td>/</td>
      EOF
      html.html_safe
    end
  end
end
