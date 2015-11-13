class DCategoriesController < ApplicationController
  # GET /d_categories
  # GET /d_categories.json
  def index
    @d_categories = DCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @d_categories }
    end
  end

  def check_items
    @check_items = CheckItem.where(:d_category_id => params[:d_category_id], enable: true)
    respond_to do |format|
      format.json { render json: {status: "OK", msg: "", items: @check_items} }
    end
  end

  def by_id
    respond_to do |format|
      format.json { render json: {status: "OK", msg: '', data: DCategory.where(c_category_id: params[:c_category_id]).select('id, name')} }
    end
  end

  # GET /d_categories/1
  # GET /d_categories/1.json
  def show
    @d_category = DCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @d_category }
    end
  end

  # GET /d_categories/new
  # GET /d_categories/new.json
  def new
    @d_category = DCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @d_category }
    end
  end

  # GET /d_categories/1/edit
  def edit
    @d_category = DCategory.find(params[:id])
  end

  # POST /d_categories
  # POST /d_categories.json
  def create
    @d_category = DCategory.new(params[:d_category])

    respond_to do |format|
      if @d_category.save
        format.html { redirect_to @d_category, notice: 'D category was successfully created.' }
        format.json { render json: @d_category, status: :created, location: @d_category }
      else
        format.html { render action: "new" }
        format.json { render json: @d_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /d_categories/1
  # PUT /d_categories/1.json
  def update
    @d_category = DCategory.find(params[:id])

    respond_to do |format|
      if @d_category.update_attributes(params[:d_category])
        format.html { redirect_to @d_category, notice: 'D category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @d_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /d_categories/1
  # DELETE /d_categories/1.json
  def destroy
    @d_category = DCategory.find(params[:id])
    @d_category.destroy

    respond_to do |format|
      format.html { redirect_to d_categories_url }
      format.json { head :no_content }
    end
  end

  def update_check_items
    @d_category = DCategory.find(params[:id])

    item_ids = []
    ActiveRecord::Base.transaction do
      params[:items].each do |item|
        begin
          check_item = CheckItem.find(item[:id])

          item_ids.push(item[:id])

          unless check_item.update_attributes(item)
            raise ActiveRecord::Rollback, checK_item.errors.first.last
          end
        rescue ActiveRecord::RecordNotFound
          check_item = CheckItem.new
          check_item.assign_attributes(item)
          check_item.a_category_id = @d_category.a_category_id
          check_item.b_category_id = @d_category.b_category_id
          check_item.c_category_id = @d_category.c_category_id
          check_item.d_category_id = @d_category.id
          check_item.identifier = @d_category.identifier

          unless check_item.save
            raise ActiveRecord::Rollback, check_item.errors.first.last
          else
            item_ids.push(check_item.id)
          end
        end
      end

      # 将已删除的标记为已删除
      @d_category.check_items.where('id not in (?)', item_ids).update_all(enable: false)
    end
    render json: {status: 'OK'}
  end
end
