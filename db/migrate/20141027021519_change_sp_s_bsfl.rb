class ChangeSpSBsfl < ActiveRecord::Migration
  def up
      change_column :sp_bsbs, :sp_s_bsfl, :string,:limit=>60
  end

  def down
  end
end
