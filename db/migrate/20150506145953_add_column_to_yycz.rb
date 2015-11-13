class AddColumnToYycz < ActiveRecord::Migration
  def change
    add_column :wtyp_czb_parts, :pczgfc_17, :integer
    add_column :wtyp_czb_parts, :pczgfc_11, :integer
    add_column :wtyp_czb_parts, :pczgfc_12, :integer
    add_column :wtyp_czb_parts, :pczgfc_13, :integer
    add_column :wtyp_czb_parts, :pczgfc_14, :integer
    add_column :wtyp_czb_parts, :pczgfc_15, :integer
    add_column :wtyp_czb_parts, :pczgfc_16, :integer
  end
end
