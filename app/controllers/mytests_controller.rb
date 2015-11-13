class MytestsController < ApplicationController
  # GET /mytests
  # GET /mytests.json
  def index
    @mytests = Mytest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mytests }
    end
  end

  # GET /mytests/1
  # GET /mytests/1.json
  def show
    @mytest = Mytest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mytest }
    end
  end

  # GET /mytests/new
  # GET /mytests/new.json
  def new
    @mytest = Mytest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mytest }
    end
  end

  # GET /mytests/1/edit
  def edit
    @mytest = Mytest.find(params[:id])
  end

  # POST /mytests
  # POST /mytests.json
  def create
    @mytest = Mytest.create(params[:mytest])
      @mytests = Mytest.find(:all)
      
      render :partial => "hello_list"
      #render :text => "mytests_list"
  end

  # PUT /mytests/1
  # PUT /mytests/1.json
  def update
    @mytest = Mytest.find(params[:id])

    respond_to do |format|
      if @mytest.update_attributes(params[:mytest])
        format.html { redirect_to @mytest, notice: 'Mytest was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mytest.errors, status: :unprocessable_entity }
      end
    end
  end
  def delete
        Mytest.destroy(params[:id])
        @mytests = Mytest.find(:all)
        render :text => "you are right!"
  end
  # DELETE /mytests/1
  # DELETE /mytests/1.json
  def destroy
    @mytest = Mytest.find(params[:id])
    @mytest.destroy

    respond_to do |format|
      format.html { redirect_to mytests_url }
      format.json { head :no_content }
    end
  end
end
