class AddAuthToUsers < ActiveRecord::Migration
  def change
  add_column :users, :user_s_province, :string, :limit => 32
  add_column :users, :user_d_authority, :integer
  end
end
