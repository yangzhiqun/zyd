class AddAttachmentPathToYydjb < ActiveRecord::Migration
  def change
		add_column :sp_yydjbs, :attachment_path, :string
  end
end
