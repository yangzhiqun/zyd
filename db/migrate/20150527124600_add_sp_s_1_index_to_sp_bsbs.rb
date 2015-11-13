class AddSpS1IndexToSpBsbs < ActiveRecord::Migration
  def change
		add_index :sp_bsbs, :sp_s_1
		add_index :pad_sp_bsbs, :sp_s_1
  end
end
