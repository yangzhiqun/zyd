class AddCzapRevertedFlagToSpBsbs < ActiveRecord::Migration
  def change
		add_column :sp_bsbs, :czb_reverted_flag, :boolean, :default => false
  end
end
