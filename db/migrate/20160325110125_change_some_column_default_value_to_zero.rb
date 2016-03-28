class ChangeSomeColumnDefaultValueToZero < ActiveRecord::Migration
  def change
    change_column :users, :user_i_js, :integer, default: 0
    change_column :users, :user_d_authority, :integer, default: 0
    change_column :users, :user_d_authority_2, :integer, default: 0
    change_column :users, :user_d_authority_3, :integer, default: 0
    change_column :users, :user_d_authority_4, :integer, default: 0
    change_column :users, :user_d_authority_5, :integer, default: 0
    change_column :users, :user_i_switch, :integer, default: 0
    change_column :users, :user_i_spys, :integer, default: 0
    change_column :users, :user_i_spss, :integer, default: 0
    change_column :users, :user_i_sp, :integer, default: 0
  end
end
