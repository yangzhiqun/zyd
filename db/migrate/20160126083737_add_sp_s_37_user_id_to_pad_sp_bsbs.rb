class AddSpS37UserIdToPadSpBsbs < ActiveRecord::Migration
  def change
		add_column :pad_sp_bsbs, :sp_s_37_user_id, :integer
  end
end
