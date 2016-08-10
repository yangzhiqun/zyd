class AddFullnameToSysProvinces < ActiveRecord::Migration
  def change
    add_column :sys_provinces, :fullname, :string, limit: 50
  end
end
