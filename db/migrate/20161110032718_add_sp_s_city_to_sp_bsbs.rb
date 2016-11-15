class AddSpSCityToSpBsbs < ActiveRecord::Migration
  def change
    add_column :sp_bsbs, :sp_s_city, :text
  end
end
