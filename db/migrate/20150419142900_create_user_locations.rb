class CreateUserLocations < ActiveRecord::Migration
  def change
    create_table :user_locations do |t|
      t.string :device_uuid
      t.string :gps
      t.integer :user_id

      t.timestamps
    end unless table_exists?(:user_locations)
  end
end
