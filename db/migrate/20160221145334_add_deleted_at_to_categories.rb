class AddDeletedAtToCategories < ActiveRecord::Migration
  def change
    add_column :a_categories, :deleted_at, :datetime
    add_index :a_categories, :deleted_at

    add_column :b_categories, :deleted_at, :datetime
    add_index :b_categories, :deleted_at

    add_column :c_categories, :deleted_at, :datetime
    add_index :c_categories, :deleted_at

    add_column :d_categories, :deleted_at, :datetime
    add_index :d_categories, :deleted_at

    add_column :baosong_as, :deleted_at, :datetime
    add_index :baosong_as, :deleted_at

    add_column :baosong_bs, :deleted_at, :datetime
    add_index :baosong_bs, :deleted_at
  end
end
