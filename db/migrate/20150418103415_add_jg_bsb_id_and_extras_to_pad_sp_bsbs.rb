class AddJgBsbIdAndExtrasToPadSpBsbs < ActiveRecord::Migration
  def change
		add_column :pad_sp_bsbs, :jg_bsb_id, :integer
		add_column :pad_sp_bsbs, :sys_province_id, :integer
		add_column :pad_sp_bsbs, :a_category_id, :integer
  end
end
