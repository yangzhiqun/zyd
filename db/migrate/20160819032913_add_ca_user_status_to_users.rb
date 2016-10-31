class AddCaUserStatusToUsers < ActiveRecord::Migration
  def change
		add_column :users, :ca_user_status, :integer
  end
end
