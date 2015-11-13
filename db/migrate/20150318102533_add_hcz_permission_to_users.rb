class AddHczPermissionToUsers < ActiveRecord::Migration
  def change
		add_column :users, :hcz_permission, :integer, :default => 0
  end
end
