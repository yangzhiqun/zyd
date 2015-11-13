class AddCurrentStateDescToWtypCzbParts < ActiveRecord::Migration
  def change
		add_column :wtyp_czb_parts, :current_state_desc, :string
  end
end
