class AddDeletedAtToSpLogs < ActiveRecord::Migration
  def change
    add_column :sp_logs, :deleted_at, :datetime
    add_index :sp_logs, :deleted_at
  end
end
