class AddSpBsbIdToYydjb < ActiveRecord::Migration
  def change
		add_column :sp_yydjbs, :sp_bsb_id, :integer
  end
end
