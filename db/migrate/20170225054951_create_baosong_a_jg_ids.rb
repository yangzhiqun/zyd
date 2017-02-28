class CreateBaosongAJgIds < ActiveRecord::Migration
  def change
    create_table :baosong_a_jg_ids do |t|
      t.integer :jg_bsb_id
      t.integer :baosong_a_id
      t.text :note

      t.timestamps null: false
    end
  end
end
