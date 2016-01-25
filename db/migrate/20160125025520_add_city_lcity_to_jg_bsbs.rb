class AddCityLcityToJgBsbs < ActiveRecord::Migration
  def change
		add_column :jg_bsbs, :city, :string, limit: 10
		add_column :jg_bsbs, :country, :string, limit: 10
  end
end
