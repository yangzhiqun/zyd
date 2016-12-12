class AddCaKeyStateTo1og < ActiveRecord::Migration
  def change
     add_column :sp_logs, :ca_key_status, :integer, default: 0
  end
end
