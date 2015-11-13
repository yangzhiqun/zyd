class AddCpkz2021222324 < ActiveRecord::Migration
  def change
  add_column :wtyp_czb_parts, :cpkzqk_20, :string
  add_column :wtyp_czb_parts, :cpkzqk_21, :string
  add_column :wtyp_czb_parts, :cpkzqk_22, :string
  add_column :wtyp_czb_parts, :cpkzqk_23, :string
  end
end
