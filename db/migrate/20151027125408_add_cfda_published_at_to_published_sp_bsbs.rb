class AddCfdaPublishedAtToPublishedSpBsbs < ActiveRecord::Migration
  def change
    add_column :published_sp_bsbs, :cfda_published_at, :date
  end
end
