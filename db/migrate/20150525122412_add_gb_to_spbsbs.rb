class AddGbToSpbsbs < ActiveRecord::Migration
  def change
   add_column :sp_bsbs, :gbsj, :boolean, :default => false
  end
end
