class AddCurrentStateToWtypCzbs < ActiveRecord::Migration
  def change
		add_column :wtyp_czbs, :current_state, :integer, :default => -1
  end
end
