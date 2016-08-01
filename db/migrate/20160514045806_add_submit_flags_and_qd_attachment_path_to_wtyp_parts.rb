class AddSubmitFlagsAndQdAttachmentPathToWtypParts < ActiveRecord::Migration
  def change
    add_column :wtyp_czb_parts, :qd_attachment_path, :string, limit: 100 unless column_exists?(:wtyp_czb_parts,:qd_attachment_path)
    add_column :wtyp_czbs, :part_submit_flag5, :boolean, :default => false
    add_column :wtyp_czbs, :part_submit_flag6, :boolean, :default => false
    add_column :wtyp_czbs, :part_submit_flag7, :boolean, :default => false
  end
end
