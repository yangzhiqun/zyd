class AddInspectionBasisToSpBsbs < ActiveRecord::Migration
  def change
    add_column :sp_bsbs, :inspection_basis, :text
  end
end
