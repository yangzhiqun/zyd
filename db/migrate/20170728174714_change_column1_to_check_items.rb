class ChangeColumn1ToCheckItems < ActiveRecord::Migration
  def change
    change_column_default(:check_items, :BZZXYXX, nil)
    change_column_default(:check_items, :BZZXYXXDW, nil)
    change_column_default(:check_items, :BZZDYXXDW, nil)
    
    change_column :check_items,:BZFFJCXDW,:text
    change_column :check_items,:BZZXYXX,:text
    change_column :check_items,:BZZXYXXDW,:text
    change_column :check_items,:BZZXYXXDW,:text
    
  end
end
