class ChangeTextToCheckItems < ActiveRecord::Migration
  def up
    change_column_default(:check_items, :BZFFJCXDW, nil)
  end
  
  def down
  # change_column :check_items,:BZFFJCXDW,:text
  end
end
