class AddSyncedToSpBsbs < ActiveRecord::Migration
  def change
		add_column :sp_bsbs, :synced, :boolean, :default => false
  end
end
