class AddUserIdToTmpSpBsbs < ActiveRecord::Migration
  def change
		add_column :tmp_sp_bsbs, :user_id, :integer unless column_exists?(:tmp_sp_bsbs, :user_id)
		add_column :tmp_sp_bsbs, :uid, :string, limit: 20 unless column_exists?(:tmp_sp_bsbs, :uid)
  end
end
