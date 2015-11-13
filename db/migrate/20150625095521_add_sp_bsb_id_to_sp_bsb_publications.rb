class AddSpBsbIdToSpBsbPublications < ActiveRecord::Migration
  def change
		add_column :sp_bsb_publications, :sp_bsb_id, :integer, :null => false
  end
end
