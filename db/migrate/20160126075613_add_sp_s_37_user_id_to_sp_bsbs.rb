class AddSpS37UserIdToSpBsbs < ActiveRecord::Migration
  def change
    add_column :sp_bsbs, :sp_s_37_user_id, :integer
  end
end
