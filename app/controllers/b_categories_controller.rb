class BCategoriesController < ApplicationController
  # GET /b_categories
  # GET /b_categories.json
  def index
    @b_categories = BCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @b_categories }
    end
  end

  def by_id
    respond_to do |format|
      format.json { render json: { status: "OK", msg: '', data: BCategory.where(a_category_id: params[:a_category_id]).select('id, name')}}
    end
  end

  # GET /b_categories/1
  # GET /b_categories/1.json
  def show
    @b_category = BCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @b_category }
    end
  end

  # GET /b_categories/new
  # GET /b_categories/new.json
  def new
    @b_category = BCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @b_category }
    end
  end

  # GET /b_categories/1/edit
  def edit
    @b_category = BCategory.find(params[:id])
  end

  # POST /b_categories
  # POST /b_categories.json
  def create
    @b_category = BCategory.new(params[:b_category])

    respond_to do |format|
      if @b_category.save
        format.html { redirect_to @b_category, notice: 'B category was successfully created.' }
        format.json { render json: @b_category, status: :created, location: @b_category }
      else
        format.html { render action: "new" }
        format.json { render json: @b_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /b_categories/1
  # PUT /b_categories/1.json
  def update
    @b_category = BCategory.find(params[:id])

    respond_to do |format|
      if @b_category.update_attributes(params[:b_category])
        format.html { redirect_to @b_category, notice: 'B category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @b_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /b_categories/1
  # DELETE /b_categories/1.json
  def destroy
    @b_category = BCategory.find(params[:id])
    @b_category.destroy

    respond_to do |format|
      format.html { redirect_to b_categories_url }
      format.json { head :no_content }
    end
  end
end
