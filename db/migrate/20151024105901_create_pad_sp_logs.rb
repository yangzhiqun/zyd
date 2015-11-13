class CreatePadSpLogs < ActiveRecord::Migration
  def change
    create_table :pad_sp_logs do |t|
      t.text :remark
      t.integer :pad_sp_bsb_id
      t.text :sp_s_16
      t.integer :sp_i_state
      t.integer :user_id

      t.timestamps
    end
  end
end
