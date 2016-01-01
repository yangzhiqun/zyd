class AddColumnCzbRevertedFlagToTmpSpBsbs < ActiveRecord::Migration
  def change
    add_column :tmp_sp_bsbs ,:czb_reverted_flag, :boolean
  end
end
