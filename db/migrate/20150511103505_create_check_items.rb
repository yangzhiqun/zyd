class CreateCheckItems < ActiveRecord::Migration
  def change
    create_table :check_items do |t|
      t.string :name
      t.string :JGDW
      t.string :JYYJ
      t.string :PDYJ
      t.string :BZFFJCX
      t.string :BZFFJCXDW
      t.string :BZZXYXX
      t.string :BZZXYXXDW
      t.string :BZZDYXX
      t.string :BZZDYXXDW
      t.integer :d_category_id
      t.integer :a_category_id
      t.integer :b_category_id
      t.integer :c_category_id

      t.timestamps
    end unless table_exists? "check_items"
  end
end
