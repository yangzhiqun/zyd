class AddEnableTagToCheckItems < ActiveRecord::Migration
  def change
		add_column :check_items, :enable, :boolean, :default => true
		add_column :a_categories, :enable, :boolean, :default => true
		add_column :b_categories, :enable, :boolean, :default => true
		add_column :c_categories, :enable, :boolean, :default => true
		add_column :d_categories, :enable, :boolean, :default => true
  end
end
