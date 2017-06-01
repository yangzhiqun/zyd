class AddIndexSpS16ToSpBsbs < ActiveRecord::Migration
  def change
    add_column :sp_bsbs,:sp_s_16,unique: true if index_exists?(:sp_bsbs, :sp_s_16, unique: true) 
  end
end
