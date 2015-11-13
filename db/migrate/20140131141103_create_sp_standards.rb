class CreateSpStandards < ActiveRecord::Migration
  def change
    create_table :sp_standards do |t|
      t.string :sp_sta_0
      t.string :sp_sta_1
      t.string :sp_sta_2
      t.string :sp_sta_3
      t.string :sp_sta_4
      t.string :sp_sta_5

      t.timestamps
    end
  end
end
