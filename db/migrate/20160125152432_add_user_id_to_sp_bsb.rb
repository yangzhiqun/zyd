class AddUserIdToSpBsb < ActiveRecord::Migration
  def change
    add_column :sp_bsbs, :user_id, :integer
    add_column :sp_bsbs, :uid, :string, limit: 20

    add_index :sp_bsbs, :uid
    add_index :sp_bsbs, :user_id
  end
end
