class CreateJgBsbSupers < ActiveRecord::Migration
  def change
    create_table :jg_bsb_supers do |t|
      t.integer :jg_bsb_id
      t.integer :super_jg_bsb_id
      t.text :note

      t.timestamps null: false
    end
  end
end
