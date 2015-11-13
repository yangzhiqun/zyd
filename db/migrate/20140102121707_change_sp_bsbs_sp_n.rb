class ChangeSpBsbsSpN < ActiveRecord::Migration
  def up
      change_column :sp_bsbs, :sp_n_15, :decimal,:precision => 10, :scale => 2
  end

  def down
  end
end
