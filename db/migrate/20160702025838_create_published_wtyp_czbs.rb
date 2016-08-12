class CreatePublishedWtypCzbs < ActiveRecord::Migration
  def change
    create_table :published_wtyp_czbs do |t|
      t.integer :user_id
      t.integer :sp_bsb_id
      t.string :cjbh
      t.date :cfda_published_at
      t.string :WH
      t.string :url

      t.timestamps null: false
    end
  end
end
