class CreateUserAuditLogs < ActiveRecord::Migration
  def change
    create_table :user_audit_logs do |t|
      t.integer :user_id
      t.integer :operator_id
      t.integer :action
      t.string :msg

      t.timestamps null: false
    end
  end
end
