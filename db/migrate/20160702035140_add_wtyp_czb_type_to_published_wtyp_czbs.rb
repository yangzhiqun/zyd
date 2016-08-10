class AddWtypCzbTypeToPublishedWtypCzbs < ActiveRecord::Migration
  def change
		add_column :published_wtyp_czbs, :wtyp_czb_type, :integer
  end
end
