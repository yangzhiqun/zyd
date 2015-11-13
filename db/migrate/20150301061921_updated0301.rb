class Updated0301 < ActiveRecord::Migration
  def change
  add_column :sp_yydjbs, :bcydw, :string,:limit => 60
  add_column :sp_yydjbs, :bcydwsf, :string,:limit => 60
  add_column :sp_yydjbs, :cydw, :string,:limit => 60
  add_column :sp_yydjbs, :cydwsf, :string,:limit => 60
  add_column :sp_yydjbs, :bsscqy, :string,:limit => 60
  add_column :sp_yydjbs, :bsscqysf, :string,:limit => 60
  add_column :sp_yydjbs, :jyxm, :string,:limit => 60
  add_column :sp_yydjbs, :jgpd, :string,:limit => 60
  add_column :sp_yydjbs, :jyjg, :string,:limit => 60

  
  
  end

end
