class AddTestJgBsbIdToTaskJgBsbs < ActiveRecord::Migration
  def change
		add_column :task_jg_bsbs, :test_jg_bsb_id, :integer
		add_column :task_jg_bsbs, :is_national, :boolean, default: false
  end
end
