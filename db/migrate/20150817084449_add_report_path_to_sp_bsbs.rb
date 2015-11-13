class AddReportPathToSpBsbs < ActiveRecord::Migration
  def change
		add_column :sp_bsbs, :report_path, :string
  end
end
