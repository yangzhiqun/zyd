#encoding: utf-8
class AttachmentController < ApplicationController
	include ApplicationHelper
	skip_before_filter :verify_authenticity_token, :only => [:destroy, :upload, :tinymce_upload]
	before_filter :set_attachment, :except => [:upload, :destroy, :tinymce_upload]

  def upload
		attachment = Attachment.new
		attachment.tmp_file = params[:file]

		if attachment.save
			render json: { status: "OK", msg: { id: attachment.id, name: attachment.filename } }
		else
      render json: { status: "ERR", msg: @attachment.errors.first.last }
		end
  end

	def tinymce_upload
		attachment = Attachment.new
		attachment.tmp_file = params[:file]

		if attachment.save
			render json: { 
				image: {
					url: "/attachments/#{attachment.id}/preview",
					width: "100%"
				},
			}, content_type: "text/html"
		else
      render json: { status: "ERR", msg: @attachment.errors.first.last }
		end
	end

	def destroy
		@attachment = Attachment.find(params[:id])
    @attachment.destroy
    render text: { success: true }.to_json, :content_type => "text/plain"
	end

	# GET /attachments/:id/download
	def download
		send_file("#{@attachment.absolute_path}", :filename => "#{@attachment.filename}#{Rack::Mime::MIME_TYPES.invert[@attachment.content_type]}", :disposition => 'attachment')
	end

	# GET /attachments/:id/preview
	def preview
		send_file("#{@attachment.absolute_path}", :filename => "#{@attachment.filename}#{Rack::Mime::MIME_TYPES.invert[@attachment.content_type]}", :disposition => 'inline')
	end

	private
	def set_attachment
		@attachment = Attachment.find params[:id]
	end

	def check_visibility
		case current_user.role
		when ::User::Role::Company then
			return not_found if current_user.id != @attachment.user_id
		end
	end
end
