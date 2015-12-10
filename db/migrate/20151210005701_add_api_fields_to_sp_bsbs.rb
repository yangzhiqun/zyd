class AddApiFieldsToSpBsbs < ActiveRecord::Migration
  def change
		add_column :sp_bsbs, :via_api, :boolean, default: false
		add_column :sp_bsbs, :synced_at, :datetime
		add_column :sp_bsbs, :application_id, :integer
  end
end
