class ChangeYyczPermissionDefaultTo0 < ActiveRecord::Migration
  def change
		change_column :users, :yycz_permission, :integer, :default => 0
  end
end
