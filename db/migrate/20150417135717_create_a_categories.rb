class CreateACategories < ActiveRecord::Migration
  def change
    create_table :a_categories do |t|
      t.integer :bgfl_id
      t.string :name
      t.string :note

      t.timestamps
    end
  end
end
