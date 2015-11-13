class AddColumnToYydjbSpdata < ActiveRecord::Migration
  def change
  add_column :sp_yydjb_spdata,:fjjg,:string
  add_column :sp_yydjb_spdata,:jgdw,:string
  add_column :sp_yydjb_spdata,:fjjl,:string
  end
end
