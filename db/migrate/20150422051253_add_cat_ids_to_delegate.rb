class AddCatIdsToDelegate < ActiveRecord::Migration
  def change
		add_column :a_category_jg_bsbs, :b_category_id, :integer
		add_column :a_category_jg_bsbs, :c_category_id, :integer
		add_column :a_category_jg_bsbs, :d_category_id, :integer
  end
end
