class AddIssueDateToSpBsbs < ActiveRecord::Migration
  def change
     add_column :sp_bsbs,:issue_date,:date unless column_exists?(:sp_bsbs, :issue_date)
  end
end
