class AddExtraColumnToWtypCzbsAndParts < ActiveRecord::Migration
  def change
    add_column :wtyp_czb_parts, :cpkzqk_kc, :string, limit: 60
    add_column :wtyp_czb_parts, :cpkzqk_zj, :string, limit: 60
  end
end
