class CreateBaosongAs < ActiveRecord::Migration
  def change
    create_table :baosong_as do |t|
      t.string :name
      t.string :note

      t.timestamps
    end unless table_exists?(:baosong_as)
  end
end
