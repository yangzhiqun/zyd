class AddFailReportPathToPadSpBsbs < ActiveRecord::Migration
  def change
		add_column :pad_sp_bsbs, :fail_report_path, :string unless column_exists?('pad_sp_bsbs','fail_report_path')
  end
end
