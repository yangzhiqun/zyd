class AddSpdataIdToSpdataPublications < ActiveRecord::Migration
  def change
		add_column :spdata_publications, :spdata_id, :integer, :null => false
  end
end
