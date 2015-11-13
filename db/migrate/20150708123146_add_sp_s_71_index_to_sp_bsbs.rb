class AddSpS71IndexToSpBsbs < ActiveRecord::Migration
  def change
		add_index :sp_bsbs, :sp_s_71
  end
end
