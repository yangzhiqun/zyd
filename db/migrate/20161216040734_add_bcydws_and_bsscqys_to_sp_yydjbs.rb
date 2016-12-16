class AddBcydwsAndBsscqysToSpYydjbs < ActiveRecord::Migration
  def change
  	add_column :sp_yydjbs, :bcydws, :string
  	add_column :sp_yydjbs, :bsscqys, :string
  end
end
