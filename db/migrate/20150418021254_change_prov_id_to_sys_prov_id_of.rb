class ChangeProvIdToSysProvIdOf < ActiveRecord::Migration
  def change
		rename_column :a_categories_provinces, :province_id, :sys_province_id
  end
end
