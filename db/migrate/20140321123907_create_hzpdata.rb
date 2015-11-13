class CreateHzpdata < ActiveRecord::Migration
  def change
    create_table :hzpdata do |t|
      t.string :hzpdata_0
      t.string :hzpdata_1
      t.string :hzpdata_2
      t.string :hzpdata_3
      t.string :hzpdata_4
      t.string :hzpdata_5
      t.string :hzpdata_6
      t.string :hzpdata_7
      t.string :hzpdata_8
      t.string :hzpdata_9

      t.timestamps
    end
  end
end
