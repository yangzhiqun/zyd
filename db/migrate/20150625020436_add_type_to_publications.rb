class AddTypeToPublications < ActiveRecord::Migration
  def change
		add_column :sp_bsb_publications, :publication_type, :integer, :default => -1
  end
end
