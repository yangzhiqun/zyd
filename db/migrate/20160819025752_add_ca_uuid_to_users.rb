class AddCaUuidToUsers < ActiveRecord::Migration
  def change
		add_column :users, :ca_uuid, :string, limit: 50, unique: true
  end
end
