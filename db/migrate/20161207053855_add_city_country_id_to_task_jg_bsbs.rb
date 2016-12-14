class AddCityCountryIdToTaskJgBsbs < ActiveRecord::Migration
  def change
     add_column :task_jg_bsbs, :city_id, :integer, default: 0
     add_column :task_jg_bsbs, :country_id, :integer,default: 0
  end
end
