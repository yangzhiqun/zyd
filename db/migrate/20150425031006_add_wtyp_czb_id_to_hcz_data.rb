class AddWtypCzbIdToHczData < ActiveRecord::Migration
  def change
		add_column :sp_hcz_spdata, :wtyp_czb_id, :integer
  end
end
