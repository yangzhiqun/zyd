class AddTypeToSpPublication < ActiveRecord::Migration
  def change
		add_column :sp_publications, :pub_type, :integer, :default => -1
  end
end
