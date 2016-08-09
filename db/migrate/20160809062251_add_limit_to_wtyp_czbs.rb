class AddLimitToWtypCzbs < ActiveRecord::Migration
  def change
    change_column :wtyp_czbs, :SPDL, :string, length: 255
    change_column :wtyp_czbs, :SPYL, :string, length: 255
    change_column :wtyp_czbs, :SPCYL, :string, length: 255
    change_column :wtyp_czbs, :SPXL, :string, length: 255
  end
end
