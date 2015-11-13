class RenameSpBsbPublicationToPubSpBsb < ActiveRecord::Migration
  def change
		rename_table :sp_bsb_publications, :pub_sp_bsbs
  end
end
