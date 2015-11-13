class CreateJgBsbStamps < ActiveRecord::Migration
  def change
    create_table :jg_bsb_stamps do |t|
      t.integer :jg_bsb_id
      t.string :stamp_no
      t.string :note

      t.timestamps
    end
  end
end
