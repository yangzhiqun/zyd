class AddStatusToTaskProvinces < ActiveRecord::Migration
  def change
    add_column :task_provinces, :status, :integer ,default: 0
  end
end
