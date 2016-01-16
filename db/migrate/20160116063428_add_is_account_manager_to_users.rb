class AddIsAccountManagerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_account_manager, :boolean, default: false
  end
end
