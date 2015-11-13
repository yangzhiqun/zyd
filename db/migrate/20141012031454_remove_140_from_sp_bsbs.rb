class Remove140FromSpBsbs < ActiveRecord::Migration
  def up
      remove_column :sp_bsbs, :sp_s_141_0
      remove_column :sp_bsbs, :sp_s_140_1
      remove_column :sp_bsbs, :sp_s_140_2
      remove_column :sp_bsbs, :sp_s_140_3
      remove_column :sp_bsbs, :sp_s_140_4
      remove_column :sp_bsbs, :sp_s_140_5
      remove_column :sp_bsbs, :sp_s_140_6
      remove_column :sp_bsbs, :sp_s_140_7
      remove_column :sp_bsbs, :sp_s_140_8
      remove_column :sp_bsbs, :sp_s_140_9
      remove_column :sp_bsbs, :sp_s_140_0
      remove_column :sp_bsbs, :sp_s_18_1
      remove_column :sp_bsbs, :sp_s_30_1
      remove_column :sp_bsbs, :sp_s_33_1
      change_column :sp_bsbs, :submit_d_flag, :datetime
      add_column :sp_bsbs, :sp_t_procedure, :text
  end
  def down
  end
end
