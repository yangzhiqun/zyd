class CreateACategoriesProvinces < ActiveRecord::Migration
  def change
    create_table :a_categories_provinces do |t|
      t.integer :province_id
      t.integer :a_category_id
      t.integer :quota
      t.string :year
      t.string :note

      t.timestamps
    end
  end
end
