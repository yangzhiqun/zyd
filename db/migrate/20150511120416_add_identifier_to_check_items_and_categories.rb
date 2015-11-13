class AddIdentifierToCheckItemsAndCategories < ActiveRecord::Migration
  def change
		add_column :a_categories, :identifier, :string unless column_exists?(:a_categories, :identifier)
		add_column :b_categories, :identifier, :string unless column_exists?(:b_categories, :identifier)
		add_column :c_categories, :identifier, :string unless column_exists?(:c_categories, :identifier)
		add_column :d_categories, :identifier, :string unless column_exists?(:d_categories, :identifier)
		add_column :check_items, :identifier, :string unless column_exists?(:check_items, :identifier)
  end
end
