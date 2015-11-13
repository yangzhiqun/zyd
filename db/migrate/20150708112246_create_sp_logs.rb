class CreateSpLogs < ActiveRecord::Migration
  def change
    create_table :sp_logs do |t|
      t.integer :sp_bsb_id
      t.integer :sp_i_state
      t.datetime :time
      t.string :remark
      t.datetime :update_time

      t.timestamps
    end
  end
end
