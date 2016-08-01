class AddAndRenameColumnToWtypCzbsAndParts < ActiveRecord::Migration
  def change
    add_column :wtyp_czbs, :bcydw_shi, :string, limit: 60 unless column_exists?(:wtyp_czbs, :bcydw_shi)
    add_column :wtyp_czbs, :bcydw_xian, :string, limit: 60 unless column_exists?(:wtyp_czbs, :bcydw_xian)
    add_column :wtyp_czbs, :bsscqy_shi, :string, limit: 60 unless column_exists?(:wtyp_czbs, :bsscqy_shi)
    add_column :wtyp_czb_parts, :bcydw_shi, :string, limit: 60 unless column_exists?(:wtyp_czb_parts, :bcydw_shi)
    add_column :wtyp_czb_parts, :bcydw_xian, :string, limit: 60 unless column_exists?(:wtyp_czb_parts, :bcydw_xian)
    add_column :wtyp_czb_parts, :bsscqy_shi, :string, limit: 60 unless column_exists?(:wtyp_czb_parts, :bsscqy_shi)
    remove_column :wtyp_czbs, :wtyp_4, :string# unless !column_exists?(:wtyp_czbs, :wtyp_4)
    remove_column :wtyp_czbs, :wtyp_5, :string# unless !column_exists?(:wtyp_czbs, :wtyp_5)
    remove_column :wtyp_czb_parts, :wtyp_4, :string# unless !column_exists?(:wtyp_czb_parts, :wtyp_4)
    remove_column :wtyp_czb_parts, :wtyp_5, :string# unless !column_exists?(:wtyp_czb_parts, :wtyp_5)
  end
end
