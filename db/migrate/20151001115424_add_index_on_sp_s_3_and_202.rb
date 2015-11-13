class AddIndexOnSpS3And202 < ActiveRecord::Migration
  def change
		add_index :sp_bsbs, :sp_s_5
		add_index :sp_bsbs, :sp_s_202
  end
end
