class AddSpSCityToPadSpBsb < ActiveRecord::Migration
  def change
    add_column :pad_sp_bsbs, :sp_s_city, :text
  end
end
