class AddWtypCzbPartIdToPublishedWtypCzbs < ActiveRecord::Migration
  def change
		add_column :published_wtyp_czbs, :wtyp_czb_part_id, :integer
  end
end
