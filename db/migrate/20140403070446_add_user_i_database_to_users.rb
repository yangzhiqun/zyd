class AddUserIDatabaseToUsers < ActiveRecord::Migration
  def change
      add_column :users, :user_i_sp, :integer
      add_column :users, :user_i_bjp, :integer
      add_column :users, :user_i_hzp, :integer
      add_column :users, :user_d_authority_2, :integer
      add_column :users, :user_d_authority_3, :integer
      add_column :users, :user_d_authority_4, :integer
      add_column :users, :user_d_authority_5, :integer
  end
end
