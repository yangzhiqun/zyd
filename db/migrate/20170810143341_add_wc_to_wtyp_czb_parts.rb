class AddWcToWtypCzbParts < ActiveRecord::Migration
  def change
   add_column :wtyp_czb_parts,:wc_sheng,:string, limit: 60 unless column_exists?(:wtyp_czb_parts,:wc_sheng)
   add_column :wtyp_czb_parts,:wc_shi,:string, limit: 60 unless column_exists?(:wtyp_czb_parts,:wc_shi)
   add_column :wtyp_czb_parts,:wc_xian,:string, limit: 60 unless column_exists?(:wtyp_czb_parts,:wc_xian)
  end
end
