class AddFujianjielunToYydjbData < ActiveRecord::Migration
  def change
		add_column :sp_yydjb_spdata, :spdata_2_1, :string
  end
end
