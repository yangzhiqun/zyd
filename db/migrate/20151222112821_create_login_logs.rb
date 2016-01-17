class CreateLoginLogs < ActiveRecord::Migration
  def change
    create_table :login_logs do |t|
      t.string :name
      t.string :action
      t.string :ip
      t.string :os
      t.string :browser
      t.string :brover

      t.timestamps null: false
    end
  end
end
