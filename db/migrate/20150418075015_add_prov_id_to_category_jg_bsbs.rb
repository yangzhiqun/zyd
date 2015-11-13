class AddProvIdToCategoryJgBsbs < ActiveRecord::Migration
  def change
		add_column :a_category_jg_bsbs, :sys_province_id, :integer
  end
end
