class ModifyLong < ActiveRecord::Migration
  def change
  change_column :sp_bsbs, :sp_s_7, :string
  end

end
