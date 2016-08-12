class AddExtraColumn3ToWtypCzbsAndParts < ActiveRecord::Migration
  def change
    add_column :wtyp_czb_parts, :tbr_dh, :string, limit: 60
    add_column :wtyp_czb_parts, :tbr_cz, :string, limit: 60
    add_column :wtyp_czb_parts, :shr_dh, :string, limit: 60
    add_column :wtyp_czb_parts, :shr_cz, :string, limit: 60
    add_column :wtyp_czb_parts, :cpkzqk_kcdw, :string, limit: 60
  end
end
