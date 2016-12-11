class CreateStandardACategories < ActiveRecord::Migration
  def change
    create_table :standard_a_categories do |t|
			t.string :name
      t.string :note
			t.string :identifier
			t.boolean :enable
			t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
