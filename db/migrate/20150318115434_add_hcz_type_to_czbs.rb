class AddHczTypeToCzbs < ActiveRecord::Migration
  def change
		add_column :wtyp_czbs, :czb_type, :integer, :default => -1
  end
end
