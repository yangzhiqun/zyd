class AddWhToPublishedSpBsbs < ActiveRecord::Migration
  def change
		add_column :published_sp_bsbs, :WH, :string, limit: 256
		add_column :published_sp_bsbs, :url, :string, limit: 2048
  end
end
