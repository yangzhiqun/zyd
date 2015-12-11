class AddSpS16ToPools < ActiveRecord::Migration
  def change
		add_column :api_exchange_pools, :sp_s_16, :string
		add_index :api_exchange_pools, :sp_s_16
  end
end
