class AddColumnCzbRevertedReasonToSpBsbs < ActiveRecord::Migration
  def change
     add_column :sp_bsbs, :czb_reverted_reason , :string, default: nil
  end
end
