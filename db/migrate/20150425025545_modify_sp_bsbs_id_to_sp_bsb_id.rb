class ModifySpBsbsIdToSpBsbId < ActiveRecord::Migration
  def change
		rename_column :wtyp_czb_parts, :sp_bsbs_id, :sp_bsb_id
  end
end
