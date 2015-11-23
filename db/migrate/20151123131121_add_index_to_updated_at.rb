class AddIndexToUpdatedAt < ActiveRecord::Migration
  def change
		add_index :tmp_sp_bsbs, :updated_at
		add_index :tmp_sp_bsbs, [:updated_at, :sp_i_state]
  end
end
