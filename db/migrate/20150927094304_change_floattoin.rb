class ChangeFloattoin < ActiveRecord::Migration

  def change
  change_column :sp_bsbs,:sp_n_15,:integer
  change_column :pad_sp_bsbs,:sp_n_15,:integer
  end
end
