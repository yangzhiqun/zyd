class ChangeDatetype2 < ActiveRecord::Migration
  def change
	change_column :check_items,:BZFFJCX,:text

  end
end
