class AddBlrTbrShrToWtypCzbParts < ActiveRecord::Migration
  def change
    add_column :wtyp_czb_parts, :blr_user_id, :integer unless column_exists?(:wtyp_czb_parts, :blr_user_id)
    add_column :wtyp_czb_parts, :tbr_user_id, :integer unless column_exists?(:wtyp_czb_parts, :tbr_user_id)
    add_column :wtyp_czb_parts, :shr_user_id, :integer unless column_exists?(:wtyp_czb_parts, :shr_user_id)
  end
end
