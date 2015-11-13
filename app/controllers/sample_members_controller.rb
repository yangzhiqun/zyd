#encoding: utf-8
class SampleMembersController < ApplicationController
	include ApplicationHelper
  # GET /sample_members
  # GET /sample_members.json
  def index
    @sample_members = SampleMember.paginate(:page => params[:page], :per_page => 30)

		unless params[:keyword].blank?
			@sample_members = @sample_members.where("username like ? or uid like ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%")
		end

		unless params[:jg_name].blank?
			@sample_members = @sample_members.where("jg_name = ?", params[:jg_name])
		end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sample_members }
    end
  end

  # GET /sample_members/1
  # GET /sample_members/1.json
  def show
    @sample_member = SampleMember.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sample_member }
    end
  end

  # GET /sample_members/new
  # GET /sample_members/new.json
  def new
		return not_found unless current_user.is_admin?
    @sample_member = SampleMember.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sample_member }
    end
  end

  # GET /sample_members/1/edit
  def edit
		return not_found unless current_user.is_admin?
    @sample_member = SampleMember.find(params[:id])
  end

  # POST /sample_members
  # POST /sample_members.json
  def create
		return not_found unless current_user.is_admin?
    @sample_member = SampleMember.new(params[:sample_member])

    respond_to do |format|
      if @sample_member.save
        format.html { redirect_to @sample_member, notice: 'Sample member was successfully created.' }
        format.json { render json: @sample_member, status: :created, location: @sample_member }
      else
        format.html { render action: "new" }
        format.json { render json: @sample_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sample_members/1
  # PUT /sample_members/1.json
  def update
		return not_found unless current_user.is_admin?
    @sample_member = SampleMember.find(params[:id])

    respond_to do |format|
      if @sample_member.update_attributes(params[:sample_member])
        format.html { redirect_to @sample_member, notice: 'Sample member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sample_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sample_members/1
  # DELETE /sample_members/1.json
  def destroy
		return not_found unless current_user.is_admin?
    @sample_member = SampleMember.find(params[:id])
    @sample_member.destroy

    respond_to do |format|
      format.html { redirect_to sample_members_url }
      format.json { head :no_content }
    end
  end

	def portrait
    @sample_member = SampleMember.find(params[:id])
		@attachment = Attachment.find(@sample_member.attachment_id)
		send_file("#{@attachment.absolute_path}", :filename => "#{@sample_member.username}", :disposition => 'inline')
	end
end
