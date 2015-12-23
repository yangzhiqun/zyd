class AddColumnsSessionidToLoginLogs < ActiveRecord::Migration
  def change
    add_column :login_logs, :sessionid, :string
  end
end
