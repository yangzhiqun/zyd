class CategoryHelperController < ApplicationController
  include ApplicationHelper

  def batch_delete
    params.permit!
    model = params[:category].constantize

    model.where(id: params[:ids].split(',')).destroy_all

    case model.class
      when ACategory.class
        BCategory.where(a_category_id: params[:ids].split(',')).destroy_all
        CCategory.where(a_category_id: params[:ids].split(',')).destroy_all
        DCategory.where(a_category_id: params[:ids].split(',')).destroy_all
        CheckItem.where(a_category_id: params[:ids].split(',')).destroy_all
      when BCategory.class
        CCategory.where(b_category_id: params[:ids].split(',')).destroy_all
        DCategory.where(b_category_id: params[:ids].split(',')).destroy_all
        CheckItem.where(b_category_id: params[:ids].split(',')).destroy_all
      when CCategory.class
        DCategory.where(c_category_id: params[:ids].split(',')).destroy_all
        CheckItem.where(c_category_id: params[:ids].split(',')).destroy_all
      when DCategory.class
        CheckItem.where(d_category_id: params[:ids].split(',')).destroy_all
      else
    end

    BaosongMofifyLog.create(user_id: current_user.id, msg: "批量删除：#{params[:category]}/[#{params[:ids]}]")

    render json: { status: 'OK' }
  end

  def create
    params.permit!
    model = params[:category].constantize

    if model == ACategory
      @category = ACategory.new(identifier: params[:identifier], name: params[:name])
    elsif model == BCategory
      a_category = ACategory.find(params[:parent_category_id])
      @category = BCategory.new(identifier: a_category.identifier, a_category_id: a_category.id, name: params[:name])
    elsif model == CCategory
      b_category = BCategory.find(params[:parent_category_id])
      @category = CCategory.new(identifier: b_category.identifier, a_category_id: b_category.a_category_id, b_category_id: b_category.id, name: params[:name])
    elsif model == DCategory
      c_category = CCategory.find(params[:parent_category_id])
      @category = DCategory.new(identifier: c_category.identifier, a_category_id: c_category.a_category_id, b_category_id: c_category.b_category_id, c_category_id: c_category.id, name: params[:name])
    end

    if @category.save
      BaosongMofifyLog.create(user_id: current_user.id, identifier: @category.identifier, msg: "新建分类：#{params[:category]}/[#{@category.id}, #{@category.name}]")
      render json: { status: 'OK', msg: 'create category succ', category: @category }
    else
      render json: { status: 'ERR', msg: @category.errors.first.last }
    end
  end

	def batch_create
    params.permit!
    model = params[:category].constantize
		identifier = params[:identifier]	
		selected_name = params[:selected_name]	
		@error_arr = []
		if model == ACategory 
			params[:names].split(',').each do |name|
				@category = ACategory.new(name: name, identifier: identifier)
				unless @category.save
				  @error_arr << @category.errors.first.last
				end
			end
		elsif model == BCategory
			a_category = ACategory.where(name:selected_name["a_category_name"],identifier:identifier).first
			params[:names].split(',').each do |name|
				@category = BCategory.new(name: name, a_category_id: a_category.id, identifier: identifier)
				unless @category.save
				  @error_arr << @category.errors.first.last
				end
			end
		end		
		if @error_arr.empty?
			render json: { status: 'OK', msg: 'create category succ'}
		else
			render json: { status: 'ERR', msg: @error_arr}
		end
	end

	def query_categorys
    params.permit!
    model = params[:category]
		identifier = params[:identifier]	
		selected_name = params[:selected_name]
		@names = []
		case model
			when "ACategory"
				@categories = ACategory.where(identifier: identifier)
			when "BCategory"	
				a_category = ACategory.where(name:selected_name["a_category_name"],identifier:identifier).first		
				@categories = BCategory.where(a_category_id: a_category.id,identifier: identifier)	
		end
		@categories.each{ |c| @names << c.name}
    render json: {status: 'OK', msg: @names}
	end

  def update
    params.permit!
    model = params[:category].constantize

    @category = model.find(params[:id])

    BaosongMofifyLog.create(user_id: current_user.id, identifier: @category.identifier, msg: "更新分类：#{params[:category]}/[#{@category.id}, #{params[:data]}]")

    if @category.update_attributes(params[:data])
      render json: {status: 'OK' }
    else
      render json: {status: 'ERR', msg: @category.errors.first.last }
    end
  end

end
