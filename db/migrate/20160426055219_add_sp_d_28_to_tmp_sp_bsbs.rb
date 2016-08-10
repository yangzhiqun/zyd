class AddSpD28ToTmpSpBsbs < ActiveRecord::Migration
  def change
  add_column :tmp_sp_bsbs, :sp_d_28, :date
 end
end
