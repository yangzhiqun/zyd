class AddJubenji < ActiveRecord::Migration
  def change
   add_column :sp_production_infos,:qylx,:integer,:default => "0"
   add_column :sp_company_infos,:qylx,:integer,:default => "0"
  end
end
