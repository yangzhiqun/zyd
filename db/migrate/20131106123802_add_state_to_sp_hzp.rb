class AddStateToSpHzp < ActiveRecord::Migration
  def change
      add_column :sp_bsbs, :sp_i_state, :integer
      add_column :hzp_bsbs, :hzp_i_state, :integer
  end
end
