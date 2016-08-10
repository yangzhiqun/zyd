class AddIndexToBsscqymcOfWtypCzbs < ActiveRecord::Migration
  def change
    add_index :wtyp_czbs, :bsscqymc
  end
end
