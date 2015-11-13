class CreateJgBsbNames < ActiveRecord::Migration
  def change
    create_table :jg_bsb_names do |t|
      t.string :name
      t.integer :jg_bsb_id
      t.string :note
      t.integer :creator_user_id

      t.timestamps
    end
  end
end
