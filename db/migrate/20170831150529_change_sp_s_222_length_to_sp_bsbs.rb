class ChangeSpS222LengthToSpBsbs < ActiveRecord::Migration
  def change
    change_column :sp_bsbs,:sp_s_222,:string,limit: 60
  end
end
