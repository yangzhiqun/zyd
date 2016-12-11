class CreateStandardCheckItems < ActiveRecord::Migration
  def change
    create_table :standard_check_items do |t|
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
      t.integer :standard_a_category_id
      t.integer :standard_b_category_id
      t.integer :standard_c_category_id
      t.integer :standard_d_category_id
			t.string :identifier
			t.boolean :enable
			t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
