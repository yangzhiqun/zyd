class AddSsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_i_spys, :integer
    add_column :users, :user_i_spss, :integer
  end
end
