class CreateWtypCzbPartLogs < ActiveRecord::Migration
  def change
    create_table :wtyp_czb_part_logs do |t|
      t.integer :user_id
      t.string :content
      t.integer :wtyp_czb_part_id
      t.integer :wtyp_czb_state
      t.integer :wtyp_czb_type

      t.timestamps
    end
  end
end
