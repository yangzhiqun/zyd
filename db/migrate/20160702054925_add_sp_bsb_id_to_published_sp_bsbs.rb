class AddSpBsbIdToPublishedSpBsbs < ActiveRecord::Migration
  def change
		add_column :published_sp_bsbs, :sp_bsb_id, :integer
  end
end
