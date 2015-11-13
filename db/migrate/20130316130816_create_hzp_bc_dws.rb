class CreateHzpBcDws < ActiveRecord::Migration
  def change
    create_table :hzp_bc_dws do |t|
      t.string :dwname
      t.string :dwlx
      t.string :dwsf
      t.string :dwdq
      t.string :dwxs
      t.string :dwxz
      t.string :dwdz
      t.string :dwyb
      t.string :dwfr
      t.string :dwfrdh
      t.string :dwfzr
      t.string :dwfzrdh

      t.timestamps
    end
  end
end
