class ChangeGbsj < ActiveRecord::Migration
  def change
  change_column :sp_bsbs, :gbsj, :string, :default => '未公布'
  end
end
