class AddLevelToSysProvinces < ActiveRecord::Migration
  def change
		add_column :sys_provinces, :level, :string, :limit => 20
  end
end
