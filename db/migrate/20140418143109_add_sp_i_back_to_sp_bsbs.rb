class AddSpIBackToSpBsbs < ActiveRecord::Migration
  def change
    add_column :sp_bsbs, :sp_i_jgback, :integer
    add_column :sp_bsbs, :sp_s_reason, :text
    add_column :sp_bsbs, :sp_i_backtimes, :integer
  end
end
