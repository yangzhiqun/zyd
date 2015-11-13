class AddBgflToSpBsbs < ActiveRecord::Migration
  def change
		add_column :sp_bsbs, :bgfl, :string, :default => ""
  end
end
