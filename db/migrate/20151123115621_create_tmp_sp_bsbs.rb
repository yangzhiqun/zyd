class CreateTmpSpBsbs < ActiveRecord::Migration
  def change
    create_table :tmp_sp_bsbs do |t|
      t.integer :sp_i_state
      t.string :sp_s_16
      t.string :sp_s_3
      t.string :sp_s_202
      t.string :sp_s_14
      t.string :sp_s_43
      t.string :sp_s_2_1
      t.string :sp_s_35
      t.string :sp_s_64
      t.string :sp_s_1
      t.string :sp_s_17
      t.string :sp_s_20
      t.string :sp_s_85

      t.timestamps null: false
    end
  end
end
