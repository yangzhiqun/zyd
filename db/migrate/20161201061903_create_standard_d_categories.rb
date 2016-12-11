class CreateStandardDCategories < ActiveRecord::Migration
  def change
    create_table :standard_d_categories do |t|
			t.string :name
      t.integer :standard_a_category_id
      t.integer :standard_b_category_id
      t.integer :standard_c_category_id
      t.string :note
			t.string :identifier
			t.boolean :enable
			t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
