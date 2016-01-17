class AddSpS18ToTmpSpBsbs < ActiveRecord::Migration
  def change
		add_column :tmp_sp_bsbs, :sp_s_18, :string
  end
end
