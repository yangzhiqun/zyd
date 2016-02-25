class ChangeEnableToEnabledAtOfUsers < ActiveRecord::Migration
  def change
		remove_column :users, :enable
		add_column :users, :enabled_at, :datetime
  end
end
