class AddUserSDlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_s_dl, :string
  end
end
