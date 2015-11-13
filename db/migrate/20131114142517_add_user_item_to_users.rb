class AddUserItemToUsers < ActiveRecord::Migration
  def change
      add_column :users, :user_jcjg, :string
      add_column :users, :user_jcjg_lxr, :string
      add_column :users, :user_jcjg_tel, :string
      add_column :users, :user_jcjg_mail, :string
      add_column :users, :user_cyjg, :string
      add_column :users, :user_cyjg_lxr, :string
      add_column :users, :user_cyjg_tel, :string
      add_column :users, :user_cyjg_mail, :string
  end
end
