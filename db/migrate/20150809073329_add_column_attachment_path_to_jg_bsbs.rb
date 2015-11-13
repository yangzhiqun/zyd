class AddColumnAttachmentPathToJgBsbs < ActiveRecord::Migration
  def change
    add_column :jg_bsbs, :attachment_path, :string
  end
end
