class AddSpProidToSpBsbs < ActiveRecord::Migration
  def change
			add_column :sp_bsbs, :sp_proid, :string unless column_exists?(:sp_bsbs, :sp_proid)
  end
end
