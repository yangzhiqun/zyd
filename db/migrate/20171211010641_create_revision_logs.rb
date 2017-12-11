class CreateRevisionLogs < ActiveRecord::Migration
  def change
    create_table :revision_logs do |t|
      t.integer :sp_bsb_id
      t.timestamps null: false
    end

    add_index :revision_logs, :sp_bsb_id
  end
end
