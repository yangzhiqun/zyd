class ChangeCloumnLengthInJgBsbsOnCity < ActiveRecord::Migration
  def change
    change_column:jg_bsbs, :city, :string, :limit => 15
  end
end
