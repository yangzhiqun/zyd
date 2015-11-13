class AddPublicationPermissionToUsers < ActiveRecord::Migration
  def change
		add_column :users, :publication_permission, :integer, :default => 0
  end
end
