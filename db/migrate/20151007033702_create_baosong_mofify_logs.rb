class CreateBaosongMofifyLogs < ActiveRecord::Migration
  def change
    create_table :baosong_mofify_logs do |t|
      t.integer :baosong_a_id
      t.integer :baosong_b_id
      t.string :identifier
      t.text :msg
      t.integer :user_id

      t.timestamps
    end
  end
end
