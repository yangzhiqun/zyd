class ChangeBzzdyxxdwCheckItems < ActiveRecord::Migration
  def change
     change_column :check_items,:BZZDYXXDW,:text 
  end
end
