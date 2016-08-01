class AddExtraColumn2ToWtypCzbsAndParts < ActiveRecord::Migration
  def change
    add_column :wtyp_czb_parts, :zgfc_fcrq, :date
    add_column :wtyp_czb_parts, :tbys_sfsfys, :string, limit: 60
  end
end
