class AddColumnBarcodeInSpBsbs < ActiveRecord::Migration
  def change
    add_column :sp_bsbs, :sp_s_222, :string, limit: 20
  end
end
