class ChangeColumnPczgfc10ToText < ActiveRecord::Migration
  def change
		change_column :wtyp_czb_parts, :pczgfc_10, :text
  end
end
