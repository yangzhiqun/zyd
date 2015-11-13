class AddCityLcityToUsers < ActiveRecord::Migration
  def change
		add_column :users, :user_s_city, :string
		add_column :users, :user_s_lcity, :string
  end
end
