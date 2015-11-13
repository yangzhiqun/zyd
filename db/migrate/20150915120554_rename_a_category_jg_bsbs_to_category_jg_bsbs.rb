class RenameACategoryJgBsbsToCategoryJgBsbs < ActiveRecord::Migration
  def change
		rename_table :a_category_jg_bsbs, :category_jg_bsbs
  end
end
