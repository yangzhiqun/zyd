class AddBgflToPadSpBsbs < ActiveRecord::Migration
  def change
		add_column :pad_sp_bsbs, :bgfl, :string
  end
end
