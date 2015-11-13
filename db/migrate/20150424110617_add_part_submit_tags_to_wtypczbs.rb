class AddPartSubmitTagsToWtypczbs < ActiveRecord::Migration
  def change
		add_column :wtyp_czbs, :part_submit_flag1, :boolean, :default => false
		add_column :wtyp_czbs, :part_submit_flag2, :boolean, :default => false
		add_column :wtyp_czbs, :part_submit_flag3, :boolean, :default => false
		add_column :wtyp_czbs, :part_submit_flag4, :boolean, :default => false
  end
end
