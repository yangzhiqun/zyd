class CreateHzpYpbs < ActiveRecord::Migration
  def change
    create_table :hzp_ypbs do |t|
      t.string :dwname
      t.string :ypname
      t.string :ypno
      t.string :ypflei
      t.string :ypleib
      t.string :ypleibzdy

      t.timestamps
    end
  end
end
