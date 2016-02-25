class AddSpS16ToPools < ActiveRecord::Migration
  def change
		add_column :api_exchange_pools, :sp_s_16, :string unless column_exists?(:api_exchange_pools, :sp_s_16)
		add_index :api_exchange_pools, :sp_s_16 unless index_exists?(:api_exchange_pools, :sp_s_16)
  end
end
