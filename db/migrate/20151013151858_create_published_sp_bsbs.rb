class CreatePublishedSpBsbs < ActiveRecord::Migration
  def change
    create_table :published_sp_bsbs do |t|
      t.string :cjbh
      t.datetime :published_at
      t.integer :user_id

      t.timestamps
    end
  end
end
