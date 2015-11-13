class AddColumnSpYydjbStaToSpYydjbLogs < ActiveRecord::Migration
  def change
      add_column :sp_yydjb_logs, :sp_yydjb_state, :integer
  end
end
