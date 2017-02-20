class AddColumnToSpdata < ActiveRecord::Migration
  def change
    add_column :spdata, :spdata_19, :text
    add_column :spdata, :spdata_20, :text
  end
end
