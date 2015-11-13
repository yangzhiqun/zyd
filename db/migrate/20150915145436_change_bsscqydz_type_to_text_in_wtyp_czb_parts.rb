class ChangeBsscqydzTypeToTextInWtypCzbParts < ActiveRecord::Migration
  def change
    change_column:wtyp_czb_parts, :bsscqydz, :text
  end
end
