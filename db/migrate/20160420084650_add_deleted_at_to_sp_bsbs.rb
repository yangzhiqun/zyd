class AddDeletedAtToSpBsbs < ActiveRecord::Migration
  def change
      add_column :sp_bsbs, :deleted_at, :datetime unless column_exists?(:sp_bsbs, :deleted_at)
      add_index :sp_bsbs, :deleted_at unless index_exists?(:sp_bsbs, :deleted_at)
  end
end
