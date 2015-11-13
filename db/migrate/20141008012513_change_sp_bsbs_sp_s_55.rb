class ChangeSpBsbsSpS55 < ActiveRecord::Migration
  def up
      change_column :sp_bsbs, :sp_s_55, :text
  end

  def down
  end
end
