class AddWtyp < ActiveRecord::Migration
  def change
  add_column :wtyp_czbs, :pczgfc_9, :text
  end
end
