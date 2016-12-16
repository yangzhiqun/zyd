class AddBcydwsAndBsscqysToSpYydjbs < ActiveRecord::Migration
  def change
  	add_column :sp_yydjbs, :bcydws, :string  unless column_exists?(:sp_yydjbs, :bcydws)
  	add_column :sp_yydjbs, :bsscqys, :string unless column_exists?(:sp_yydjbs, :bsscqys)
  end
end
