class CreateBCategories < ActiveRecord::Migration
  def change
    create_table :b_categories do |t|
      t.string :name
      t.integer :a_category_id
      t.string :note

      t.timestamps
    end
  end
end
