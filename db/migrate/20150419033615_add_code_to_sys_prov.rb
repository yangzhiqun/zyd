class AddCodeToSysProv < ActiveRecord::Migration
  def change
		add_column :sys_provinces, :code, :string
  end
end
