class AddCaLoginToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ca_login, :string, limit: 50, unique: true
  end
end
