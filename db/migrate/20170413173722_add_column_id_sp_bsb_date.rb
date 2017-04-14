class AddColumnIdSpBsbDate < ActiveRecord::Migration
  def change
     add_column :spdata, :check_item_id, :integer unless column_exists?(:spdata, :check_item_id)
  end
end
