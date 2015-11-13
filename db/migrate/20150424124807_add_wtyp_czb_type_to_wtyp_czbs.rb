class AddWtypCzbTypeToWtypCzbs < ActiveRecord::Migration
  def change
		add_column :wtyp_czbs, :wtyp_czb_type, :integer, :default => 0
  end
end
