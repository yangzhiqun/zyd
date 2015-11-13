class AddIndexSpS3 < ActiveRecord::Migration
  def up
      add_index :sp_bsbs, :sp_s_3
  end

  def down
  end
end
