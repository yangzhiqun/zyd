class AddSpProidToSpProductionInfos < ActiveRecord::Migration
  def change
	add_column :sp_production_infos, :sp_proid, :string unless column_exists?(:sp_production_infos, :sp_proid)
  end
end
