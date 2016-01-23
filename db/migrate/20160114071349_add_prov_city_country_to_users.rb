class AddProvCityCountryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :prov_city, :string, limit: 10
    add_column :users, :prov_country, :string, limit: 10
  end
end
