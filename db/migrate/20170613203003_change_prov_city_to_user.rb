class ChangeProvCityToUser < ActiveRecord::Migration
  def change
    change_column :users, :prov_city, :string, limit: 50
    change_column :users, :prov_country, :string, limit: 50
    change_column :jg_bsbs, :city, :string, limit: 50
    change_column :jg_bsbs, :country, :string, limit: 50
  end
end
