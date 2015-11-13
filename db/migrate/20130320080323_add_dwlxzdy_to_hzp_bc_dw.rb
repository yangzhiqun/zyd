class AddDwlxzdyToHzpBcDw < ActiveRecord::Migration
  def change
    add_column :hzp_bc_dws, :dwlxzdy, :string
  end
end
