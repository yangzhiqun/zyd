class AddUserIJsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_i_js, :integer
    add_column :users, :user_i_switch, :integer
  end
end
