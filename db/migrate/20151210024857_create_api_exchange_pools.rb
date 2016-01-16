class CreateApiExchangePools < ActiveRecord::Migration
  def change
    create_table :api_exchange_pools do |t|
      t.integer :application_id, null: false
      t.integer :sp_bsb_id, null: false
      t.boolean :fetched, default: false

      t.timestamps null: false
    end unless table_exists?(:api_exchange_pools)
  end
end
