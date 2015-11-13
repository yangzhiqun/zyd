class AddStatusToJgBsbs < ActiveRecord::Migration
  def change
		add_column :jg_bsbs, :status, :integer, default: 0
  end
end
