class AddColumnDeleteAtToPadSpBsbs < ActiveRecord::Migration
  def change
    add_column :pad_sp_bsbs, :deleted_at, :datetime
    add_index :pad_sp_bsbs, :deleted_at
  end
end
