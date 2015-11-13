class ChangePczgfc2TypeToInt < ActiveRecord::Migration
  def change
		change_column :wtyp_czb_parts, :pczgfc_2, :integer, :default => 0
  end
end
