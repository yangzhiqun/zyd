class AddApiFieldsToSpBsbs < ActiveRecord::Migration
  def change
		add_column :sp_bsbs, :via_api, :boolean, default: false unless column_exists?(:sp_bsbs, :via_api)
		add_column :sp_bsbs, :synced_at, :datetime unless column_exists?(:sp_bsbs, :synced_at)
		add_column :sp_bsbs, :application_id, :integer unless column_exists?(:sp_bsbs, :application_id)
  end
end
