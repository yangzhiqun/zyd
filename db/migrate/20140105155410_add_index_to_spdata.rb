class AddIndexToSpdata < ActiveRecord::Migration
  def change
      add_index :spdata, :sp_bsb_id
      add_index :sp_bsbs, :id
  end
end
