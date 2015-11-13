class FlexcontentsController < ApplicationController
  # GET /flexcontents
  # GET /flexcontents.json
  def index
      @flexcontents = Flexcontent.find_all_by_flex_field(params[:flex_fields],:order=>"flex_sortid ASC")
    @flex_temp=params[:flex_fields]
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @flexcontents }
    end
  end

  # GET /flexcontents/1
  # GET /flexcontents/1.json
  def show
    @flexcontent = Flexcontent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @flexcontent }
    end
  end

  # GET /flexcontents/new
  # GET /flexcontents/new.json
  def new
    @flexcontent = Flexcontent.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @flexcontent }
    end
  end

  # GET /flexcontents/1/edit
  def edit
    @flexcontent = Flexcontent.find(params[:id])
  end

  # POST /flexcontents
  # POST /flexcontents.json
  def create
    @flexcontent = Flexcontent.new(params[:flexcontent])

    respond_to do |format|
      if @flexcontent.save
        format.html { redirect_to @flexcontent, notice: 'Flexcontent was successfully created.' }
        format.json { render json: @flexcontent, status: :created, location: @flexcontent }
      else
        format.html { render action: "new" }
        format.json { render json: @flexcontent.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /flexcontents/1
  # PUT /flexcontents/1.json
  def update
    @flexcontent = Flexcontent.find(params[:id])

    respond_to do |format|
        params[:flexcontent][:flex_id]=params[:flexcontent][:flex_name]
      if @flexcontent.update_attributes(params[:flexcontent])
          @flex_temp=params[:flexcontent][:flex_field]
          @flexcontents = Flexcontent.find_all_by_flex_field(@flex_temp,:order=>"flex_sortid ASC")
          format.html { render action: "index"}
      else
        format.html { render action: "edit" }
        format.json { render json: @flexcontent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flexcontents/1
  # DELETE /flexcontents/1.json
  def destroy
    @flexcontent = Flexcontent.find(params[:id])
    @flex_temp=@flexcontent.flex_field
    @flexcontent.destroy
    @flexcontents = Flexcontent.find_all_by_flex_field(@flex_temp)
    respond_to do |format|
        format.html { render action: "index"}
        format.json { render json: @flexcontents }
    end
  end
    # get /flexcontens/additem
    def additem
        
        @flexcontent = Flexcontent.create(:flex_field=>params[:flex_fields],:flex_name=>params[:flex_name],:flex_id=>params[:flex_name],:flex_sortid=>params[:flex_sortid])
        @flexcontents = Flexcontent.find_all_by_flex_field(params[:flex_fields],:order=>"flex_sortid ASC")
        @flex_temp=params[:flex_fields]
        respond_to do |format|
            format.html { render action: "index"}
            format.json { render json: @flexcontents }
        end
        
    end
    
end
