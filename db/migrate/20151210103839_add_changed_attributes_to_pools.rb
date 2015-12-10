class AddChangedAttributesToPools < ActiveRecord::Migration
  def change
		add_column :api_exchange_pools, :attributes_changed, :string, length: 512
  end
end
