class ChangeSpBsbsFor140 < ActiveRecord::Migration
  def up
     change_column :sp_bsbs, :sp_s_140_0, :string, :limit => 60
  end

  def down
  end
end
