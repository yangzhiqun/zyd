class RenameCategoryJgBsbsToTaskJgBsbs < ActiveRecord::Migration
  def change
		rename_table :category_jg_bsbs, :task_jg_bsbs
		rename_table :category_provinces, :task_provinces
  end
end
