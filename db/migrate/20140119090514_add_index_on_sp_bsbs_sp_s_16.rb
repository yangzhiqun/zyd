class AddIndexOnSpBsbsSpS16 < ActiveRecord::Migration
    def up
        add_index :sp_bsbs, :sp_s_16
  end

  def down
  end
end
