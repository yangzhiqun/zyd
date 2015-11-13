class AddFailReportPathToSpBsbs < ActiveRecord::Migration
  def change
		add_column :sp_bsbs, :fail_report_path, :string
  end
end
