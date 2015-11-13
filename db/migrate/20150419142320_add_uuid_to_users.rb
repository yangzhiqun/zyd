class AddUuidToUsers < ActiveRecord::Migration
  def change
		add_column :users, :device_uuid, :string, :limit => 40 unless column_exists?(:users, :device_uuid)
  end
end
