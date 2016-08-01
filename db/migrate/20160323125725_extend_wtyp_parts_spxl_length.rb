class ExtendWtypPartsSpxlLength < ActiveRecord::Migration
  def change
		change_column :wtyp_czb_parts, :SPDL, :string, length: 255
		change_column :wtyp_czb_parts, :SPYL, :string, length: 255
		change_column :wtyp_czb_parts, :SPCYL, :string, length: 255
		change_column :wtyp_czb_parts, :SPXL, :string, length: 255
  end
end
