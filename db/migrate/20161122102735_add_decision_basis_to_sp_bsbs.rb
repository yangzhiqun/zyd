class AddDecisionBasisToSpBsbs < ActiveRecord::Migration
  def change
    add_column :sp_bsbs, :decision_basis, :text
  end
end
