class AddShengShiXianToBaosongAs < ActiveRecord::Migration
  def change
  	add_column :baosong_as, :sheng, :string , limit: 10 unless column_exists?(:baosong_as, :sheng)
  	add_column :baosong_as, :shi, :string , limit: 10 unless column_exists?(:baosong_as, :shi)
    add_column :baosong_as, :xian, :string , limit: 10 unless column_exists?(:baosong_as, :xian)
  end
end
