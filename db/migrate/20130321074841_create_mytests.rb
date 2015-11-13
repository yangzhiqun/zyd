class CreateMytests < ActiveRecord::Migration
  def change
    create_table :mytests do |t|
      t.string :name
      t.string :age

      t.timestamps
    end
  end
end
