class AddYyczPermissionToUsers < ActiveRecord::Migration
  def change
		add_column :users, :yycz_permission, :integer
  end
end
