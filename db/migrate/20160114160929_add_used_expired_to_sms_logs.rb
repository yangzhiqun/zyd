class AddUsedExpiredToSmsLogs < ActiveRecord::Migration
  def change
    add_column :sms_logs, :used_at, :datetime
  end
end
