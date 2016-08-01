class AddColumnXcPcXzAttachmentPathToWtypCzbParts < ActiveRecord::Migration
  def change
    add_column :wtyp_czb_parts, :xc_attachment_path, :string, limit: 100
    add_column :wtyp_czb_parts, :pc_attachment_path, :string, limit: 100
    add_column :wtyp_czb_parts, :xz_attachment_path, :string, limit: 100
  end
end
