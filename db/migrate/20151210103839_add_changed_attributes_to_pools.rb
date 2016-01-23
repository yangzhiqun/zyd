class AddChangedAttributesToPools < ActiveRecord::Migration
  def change
		add_column :api_exchange_pools, :attributes_changed, :string, length: 512 unless column_exists?(:api_exchange_pools, :attributes_changed)
  end
end
