class ModifyDefault < ActiveRecord::Migration
  def change
  change_column :sp_bsbs, :sp_s_35, :string, :default => ""
  change_column :sp_bsbs, :sp_s_43, :string, :default => ""
  change_column :sp_bsbs, :sp_s_14, :string, :default => ""
  change_column :sp_bsbs, :sp_s_2, :string, :default => ""
  change_column :sp_bsbs, :sp_s_20, :string, :default => ""
  change_column :sp_bsbs, :sp_s_17, :string, :default => ""
  change_column :sp_bsbs, :sp_s_3, :string, :default => ""
  change_column :sp_bsbs, :sp_s_1, :string, :default => ""
  change_column :sp_bsbs, :sp_s_64, :string, :default => ""
  change_column :sp_bsbs, :sp_s_2_1, :string, :default => ""
  add_column :sp_bsbs, :sp_xkz, :string
  add_column :sp_bsbs, :sp_xkz_id, :string
  end
end
