class AddColumnSpBsbIdToWtypCzbPartLogs < ActiveRecord::Migration
  def change
    add_column :wtyp_czb_part_logs, :sp_bsb_id, :integer
  end
end
