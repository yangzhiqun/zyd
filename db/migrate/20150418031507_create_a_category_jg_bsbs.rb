class CreateACategoryJgBsbs < ActiveRecord::Migration
  def change
    create_table :a_category_jg_bsbs do |t|
      t.integer :a_category_id
      t.integer :jg_bsb_id
      t.string :note
      t.integer :quota

      t.timestamps
    end
  end
end
