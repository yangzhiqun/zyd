class ChangeSpS21FromSpBsbs < ActiveRecord::Migration
  def up
      change_column :sp_bsbs, :sp_s_2_1, :string
  end

  def down
  end
end
