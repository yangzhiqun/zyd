class RemoveZiduan < ActiveRecord::Migration
  def change
   remove_column :wtyp_czbs,:current_state
   remove_column :wtyp_czbs,:czb_type
  end

end
