class ChangeUserISwitchToFalse < ActiveRecord::Migration
  def change
		change_column :users, :user_i_switch, :integer, default: 0
  end
end
