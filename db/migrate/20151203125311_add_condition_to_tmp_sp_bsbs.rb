class AddConditionToTmpSpBsbs < ActiveRecord::Migration
  def change
		add_column :tmp_sp_bsbs, :sp_s_215, :string unless column_exists?(:tmp_sp_bsbs, :sp_s_215)
		add_column :tmp_sp_bsbs, :sp_s_68, :string unless column_exists?(:tmp_sp_bsbs, :sp_s_68)
		add_column :tmp_sp_bsbs, :sp_s_13, :string unless column_exists?(:tmp_sp_bsbs, :sp_s_13)
		add_column :tmp_sp_bsbs, :sp_s_27, :string unless column_exists?(:tmp_sp_bsbs, :sp_s_27)

		add_index :tmp_sp_bsbs, [:sp_s_215, :sp_s_68, :created_at, :sp_i_state], name: '215_68_created_at_state'
		add_index :tmp_sp_bsbs, [:sp_s_13, :sp_i_state, :created_at], name: '13_state_created_at'
		add_index :tmp_sp_bsbs, [:sp_s_13, :sp_s_14, :sp_s_27, :sp_i_state, :created_at], name: '14_27_state_created_at'
  end
end
