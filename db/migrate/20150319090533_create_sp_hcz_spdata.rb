class CreateSpHczSpdata < ActiveRecord::Migration
  def change
    create_table :sp_hcz_spdata do |t|
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
      t.string :spdata_10
      t.string :spdata_11
      t.string :spdata_12
      t.string :spdata_13
      t.string :spdata_14
      t.string :spdata_15
      t.string :spdata_16
      t.string :spdata_17
      t.string :spdata_18
      t.integer :sp_hcz_id
      t.string :spdata_2_1
      t.string :gjjg
      t.string :jgdw
      t.string :fjjl

      t.timestamps
    end unless table_exists?("sp_hcz_spdata")
  end
end
