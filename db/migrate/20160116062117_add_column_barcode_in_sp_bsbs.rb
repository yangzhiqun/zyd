class AddColumnBarcodeInSpBsbs < ActiveRecord::Migration
  def change
    add_column :sp_bsbs, :sp_s_222, :string, limit: 20 unless column_exists?(:sp_bsbs, :sp_s_222)
  end
end
