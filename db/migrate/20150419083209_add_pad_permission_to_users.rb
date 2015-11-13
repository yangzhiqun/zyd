class AddPadPermissionToUsers < ActiveRecord::Migration
  def change
		add_column :users, :pad_permission, :integer
  end
end
