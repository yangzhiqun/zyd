class AddUserSignToUsers < ActiveRecord::Migration
  def change
		add_column :users, :user_sign, :text
  end
end
