class AddCategoryNameToTaskTables < ActiveRecord::Migration
  def change
		add_column :task_jg_bsbs, :a_category_name, :string
		add_column :task_jg_bsbs, :b_category_name, :string
		add_column :task_jg_bsbs, :c_category_name, :string
		add_column :task_jg_bsbs, :d_category_name, :string

		add_column :task_provinces, :a_category_name, :string
		add_column :task_provinces, :b_category_name, :string
		add_column :task_provinces, :c_category_name, :string
		add_column :task_provinces, :d_category_name, :string
  end
end
