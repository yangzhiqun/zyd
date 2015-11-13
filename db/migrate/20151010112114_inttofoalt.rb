class Inttofoalt < ActiveRecord::Migration
  def change
	  change_column :sp_bsbs,:sp_n_15, :float
		change_column :pad_sp_bsbs,:sp_n_15, :float
	end


end
