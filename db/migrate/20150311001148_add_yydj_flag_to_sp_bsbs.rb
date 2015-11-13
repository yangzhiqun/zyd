class AddYydjFlagToSpBsbs < ActiveRecord::Migration
  def change
		add_column :sp_bsbs, :is_yydj, :boolean, :default => false
  end
end
