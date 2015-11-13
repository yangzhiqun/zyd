class AddSpdata18ToSpdata < ActiveRecord::Migration
  def change
    add_column :spdata, :spdata_18, :string
  end
end
