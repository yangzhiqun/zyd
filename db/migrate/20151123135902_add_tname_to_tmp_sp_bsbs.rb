class AddTnameToTmpSpBsbs < ActiveRecord::Migration
  def change
		add_column :tmp_sp_bsbs, :tname, :string
  end
end
