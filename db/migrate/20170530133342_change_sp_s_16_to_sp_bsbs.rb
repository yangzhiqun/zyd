class ChangeSpS16ToSpBsbs < ActiveRecord::Migration
  def change
    change_column :sp_bsbs, :sp_s_7, :text
  end
end
