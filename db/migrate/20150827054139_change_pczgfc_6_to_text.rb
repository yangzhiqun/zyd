class ChangePczgfc6ToText < ActiveRecord::Migration
  def change
		change_column :wtyp_czb_parts, :pczgfc_6, :text
  end
end
