class AddAdminLevelToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin_level, :integer, default: 0
  end
end
