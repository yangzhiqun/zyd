class AddCarSysIdToUsers < ActiveRecord::Migration
  def change
		add_column :users, :car_sys_id, :string
  end
end
