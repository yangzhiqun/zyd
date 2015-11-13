class RenameSpdataPublicationToPubSpdata < ActiveRecord::Migration
  def change
		rename_table :spdata_publications, :pub_spdata
  end
end
