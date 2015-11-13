class AddCategorisToACategoriesProvinces < ActiveRecord::Migration
  def change
		add_column :a_categories_provinces, :b_category_id, :integer
		add_column :a_categories_provinces, :c_category_id, :integer
		add_column :a_categories_provinces, :d_category_id, :integer
  end
end
