class AddAttachmentsToYydjbs < ActiveRecord::Migration
  def change
		add_column :sp_yydjbs, :attachments, :string
  end
end
