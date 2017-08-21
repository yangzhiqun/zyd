class AddWcToWtypCab < ActiveRecord::Migration
  def change
    add_column :wtyp_czbs,:wc_sheng,:string unless column_exists?(:wtyp_czbs,:wc_sheng)
    add_column :wtyp_czbs,:wc_shi,:string unless column_exists?(:wtyp_czbs,:wc_shi)
    add_column :wtyp_czbs,:wc_xian,:string unless column_exists?(:wtyp_czbs,:wc_xian)
    
  end
end
