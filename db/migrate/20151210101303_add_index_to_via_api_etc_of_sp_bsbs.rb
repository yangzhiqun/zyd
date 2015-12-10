class AddIndexToViaApiEtcOfSpBsbs < ActiveRecord::Migration
  def change
		add_index :sp_bsbs, :via_api
		add_index :sp_bsbs, :application_id
  end
end
