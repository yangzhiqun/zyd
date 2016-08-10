class AddSpflToWtypCzbs < ActiveRecord::Migration
  def change
    add_column :wtyp_czbs, :SPDL, :string, limit: 20
    add_column :wtyp_czbs, :SPYL, :string, limit: 20
    add_column :wtyp_czbs, :SPCYL, :string, limit: 20
    add_column :wtyp_czbs, :SPXL, :string, limit: 20

    add_column :wtyp_czb_parts, :SPDL, :string, limit: 20
    add_column :wtyp_czb_parts, :SPYL, :string, limit: 20
    add_column :wtyp_czb_parts, :SPCYL, :string, limit: 20
    add_column :wtyp_czb_parts, :SPXL, :string, limit: 20
  end
end
