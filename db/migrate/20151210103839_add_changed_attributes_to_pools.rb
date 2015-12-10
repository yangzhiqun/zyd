class AddChangedAttributesToPools < ActiveRecord::Migration
  def change
		add_column :api_exchange_pools, :changed_attributes, :string, length: 512
  end
end
