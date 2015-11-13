class AddColumnUseridRemoveColumnTimeUpdateTimeToSpLog < ActiveRecord::Migration
  def change
    add_column :sp_logs, :user_id, :integer
    remove_column :sp_logs, :time
    remove_column :sp_logs, :update_time
  end
end
