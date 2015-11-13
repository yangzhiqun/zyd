class SetDefaultTo0ForSpIStateOfSpBsbs < ActiveRecord::Migration
  def change
		change_column :sp_bsbs, :sp_i_state, :integer, :default => 0
  end
end
