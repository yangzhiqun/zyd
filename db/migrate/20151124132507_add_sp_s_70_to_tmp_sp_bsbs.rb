class AddSpS70ToTmpSpBsbs < ActiveRecord::Migration
  def change
		add_column :tmp_sp_bsbs, :sp_s_70, :string
  end
end
