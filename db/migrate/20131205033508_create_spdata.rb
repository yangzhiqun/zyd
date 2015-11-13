class CreateSpdata < ActiveRecord::Migration
  def change
    create_table :spdata do |t|
      t.string :spdata_0
      t.string :spdata_1
      t.string :spdata_2
      t.string :spdata_3
      t.string :spdata_4
      t.string :spdata_5
      t.string :spdata_6
      t.string :spdata_7
      t.string :spdata_8
      t.string :spdata_9
      t.integer :sp_bsb_id
      t.timestamps
    end
  end
end
