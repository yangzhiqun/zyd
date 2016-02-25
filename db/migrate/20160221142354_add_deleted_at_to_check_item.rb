class AddDeletedAtToCheckItem < ActiveRecord::Migration
  def change
    add_column :check_items, :deleted_at, :datetime
    add_index :check_items, :deleted_at
  end
end
