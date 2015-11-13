class AddCjbhIndexToWtypCzbParts < ActiveRecord::Migration
  def change
		add_index :wtyp_czb_parts, :cjbh
  end
end
