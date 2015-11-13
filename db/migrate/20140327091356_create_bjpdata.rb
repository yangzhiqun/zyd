class CreateBjpdata < ActiveRecord::Migration
  def change
    create_table :bjpdata do |t|
      t.string :bjpdata_0
      t.string :bjpdata_1
      t.string :bjpdata_2
      t.string :bjpdata_3
      t.string :bjpdata_4
      t.string :bjpdata_5
      t.string :bjpdata_6
      t.string :bjpdata_7
      t.string :bjpdata_8
      t.string :bjpdata_9
      t.integer :bjp_bsb_id

      t.timestamps
    end
  end
end
