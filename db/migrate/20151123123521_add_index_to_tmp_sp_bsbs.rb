class AddIndexToTmpSpBsbs < ActiveRecord::Migration
  def change
		add_index :tmp_sp_bsbs, :sp_i_state
		add_index :tmp_sp_bsbs, :sp_s_16
		add_index :tmp_sp_bsbs, :sp_s_3
		add_index :tmp_sp_bsbs, :sp_s_202
		add_index :tmp_sp_bsbs, :sp_s_14
		add_index :tmp_sp_bsbs, :sp_s_43
		add_index :tmp_sp_bsbs, :sp_s_2_1
		add_index :tmp_sp_bsbs, :sp_s_35
		add_index :tmp_sp_bsbs, :sp_s_64
		add_index :tmp_sp_bsbs, :sp_s_1
		add_index :tmp_sp_bsbs, :sp_s_17
		add_index :tmp_sp_bsbs, :sp_s_20
		add_index :tmp_sp_bsbs, :sp_s_85
  end
end
