class AddFailReportAtToSpBsbs < ActiveRecord::Migration
  def change
		add_column :sp_bsbs, :fail_report_at, :datetime
  end
end
