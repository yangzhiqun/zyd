class CreateSpYydjbLogs < ActiveRecord::Migration
  def change
    create_table :sp_yydjb_logs do |t|
      t.integer :sp_yydjb_id
      t.text :cjbh
      t.text :content
      t.integer :user_id

      t.timestamps
    end
  end
end
