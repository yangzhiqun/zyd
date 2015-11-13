class CCategoriesController < ApplicationController
  # GET /c_categories
  # GET /c_categories.json
  def index
    @c_categories = CCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @c_categories }
    end
  end

  def by_id
    respond_to do |format|
      format.json { render json: { status: "OK", msg: '', data: CCategory.where(b_category_id: params[:b_category_id]).select('id, name')}}
    end
  end

  # GET /c_categories/1
  # GET /c_categories/1.json
  def show
    @c_category = CCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @c_category }
    end
  end

  # GET /c_categories/new
  # GET /c_categories/new.json
  def new
    @c_category = CCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @c_category }
    end
  end

  # GET /c_categories/1/edit
  def edit
    @c_category = CCategory.find(params[:id])
  end

  # POST /c_categories
  # POST /c_categories.json
  def create
    @c_category = CCategory.new(params[:c_category])

    respond_to do |format|
      if @c_category.save
        format.html { redirect_to @c_category, notice: 'C category was successfully created.' }
        format.json { render json: @c_category, status: :created, location: @c_category }
      else
        format.html { render action: "new" }
        format.json { render json: @c_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /c_categories/1
  # PUT /c_categories/1.json
  def update
    @c_category = CCategory.find(params[:id])

    respond_to do |format|
      if @c_category.update_attributes(params[:c_category])
        format.html { redirect_to @c_category, notice: 'C category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @c_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /c_categories/1
  # DELETE /c_categories/1.json
  def destroy
    @c_category = CCategory.find(params[:id])
    @c_category.destroy

    respond_to do |format|
      format.html { redirect_to c_categories_url }
      format.json { head :no_content }
    end
  end
end
