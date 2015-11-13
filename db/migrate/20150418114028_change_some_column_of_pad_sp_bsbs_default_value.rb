class ChangeSomeColumnOfPadSpBsbsDefaultValue < ActiveRecord::Migration
  def change
		change_column :pad_sp_bsbs, :sp_s_2, :string, :default => ''
		change_column :pad_sp_bsbs, :sp_s_3, :string, :default => ''
		change_column :pad_sp_bsbs, :sp_s_14, :string, :default => ''
		change_column :pad_sp_bsbs, :sp_s_16, :string, :default => ''
		change_column :pad_sp_bsbs, :sp_s_17, :string, :default => ''
		change_column :pad_sp_bsbs, :sp_s_20, :string, :default => ''
		change_column :pad_sp_bsbs, :sp_s_35, :string, :default => ''
		change_column :pad_sp_bsbs, :sp_s_43, :string, :default => ''
		change_column :pad_sp_bsbs, :sp_s_85, :string, :default => ''
  end
end
