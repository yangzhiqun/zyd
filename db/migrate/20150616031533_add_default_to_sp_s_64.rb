class AddDefaultToSpS64 < ActiveRecord::Migration
  def change
		change_column :sp_bsbs, :sp_s_64, :string, :default => ''
  end
end
