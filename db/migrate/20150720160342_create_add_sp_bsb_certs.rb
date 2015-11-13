class CreateAddSpBsbCerts < ActiveRecord::Migration
  def change
    create_table :sp_bsb_certs, force: true do |t|
      t.text :source
      t.string :user_cert
      t.text :sign
      t.integer :user_id
      t.integer :sp_i_state
      t.integer :sp_bsb_id

      t.timestamps
    end
  end
end
