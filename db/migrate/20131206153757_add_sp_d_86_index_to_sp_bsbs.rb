class AddSpD86IndexToSpBsbs < ActiveRecord::Migration
  def change
		add_index :sp_bsbs, :sp_d_86
  end
end
