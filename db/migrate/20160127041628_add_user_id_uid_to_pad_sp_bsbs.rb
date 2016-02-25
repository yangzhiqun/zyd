class AddUserIdUidToPadSpBsbs < ActiveRecord::Migration
  def change
		add_column :pad_sp_bsbs, :user_id, :integer
		add_column :pad_sp_bsbs, :uid, :string, limit: 20
  end
end
