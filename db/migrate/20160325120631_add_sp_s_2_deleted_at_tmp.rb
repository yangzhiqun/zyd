class AddSpS2DeletedAtTmp < ActiveRecord::Migration
  def change
    add_column :tmp_sp_bsbs, :sp_s_2, :string
    add_column :tmp_sp_bsbs, :deleted_at, :datetime
  end
end
