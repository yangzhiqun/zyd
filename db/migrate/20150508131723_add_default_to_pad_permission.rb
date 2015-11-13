class AddDefaultToPadPermission < ActiveRecord::Migration
  def change
		change_column :users, :pad_permission, :integer, :default => 0
  end
end
