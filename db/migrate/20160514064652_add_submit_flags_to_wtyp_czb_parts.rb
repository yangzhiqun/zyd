class AddSubmitFlagsToWtypCzbParts < ActiveRecord::Migration
  def change
    add_column :wtyp_czb_parts, :part_submit_flag5, :boolean, :default => false
    add_column :wtyp_czb_parts, :part_submit_flag6, :boolean, :default => false
    add_column :wtyp_czb_parts, :part_submit_flag7, :boolean, :default => false
  end
end
