class AddCaPathToSpBsbs < ActiveRecord::Migration
  def change
	add_column :sp_bsbs, :JDCJ_report_path, :string, limit: 200
	add_column :sp_bsbs, :FXJC_report_path, :string, limit: 200
  end
end
