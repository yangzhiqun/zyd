class AddSpdata10ToSpdata < ActiveRecord::Migration
  def change
    add_column :spdata, :spdata_10, :string
    add_column :spdata, :spdata_11, :string
    add_column :spdata, :spdata_12, :string
    add_column :spdata, :spdata_13, :string
    add_column :spdata, :spdata_14, :string
    add_column :spdata, :spdata_15, :string
    add_column :spdata, :spdata_16, :string
    add_column :spdata, :spdata_17, :string
  end
end
