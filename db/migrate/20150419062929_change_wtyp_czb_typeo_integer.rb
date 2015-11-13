class ChangeWtypCzbTypeoInteger < ActiveRecord::Migration
  def change
	change_column :wtyp_czbs, :hccz_type, :integer, :default => -1
  end
end
