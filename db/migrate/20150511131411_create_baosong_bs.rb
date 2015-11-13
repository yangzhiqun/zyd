class CreateBaosongBs < ActiveRecord::Migration
  def change
    create_table :baosong_bs do |t|
      t.string :name
      t.string :note
      t.integer :baosong_a_id

      t.timestamps
    end unless table_exists?(:baosong_bs)
  end
end
