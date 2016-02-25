class CreatePadCaSigns < ActiveRecord::Migration
  def change
    create_table :pad_ca_signs do |t|
      t.string :sp_s_16
      t.integer :pad_sp_bsb_id
      t.text :user_cert, limit: 65535
      t.text :orig_data, limit: 65535
      t.text :signed_data, limit: 65535
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
