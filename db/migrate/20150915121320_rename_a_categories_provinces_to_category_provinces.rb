class RenameACategoriesProvincesToCategoryProvinces < ActiveRecord::Migration
  def change
		rename_table :a_categories_provinces, :category_provinces
  end
end
