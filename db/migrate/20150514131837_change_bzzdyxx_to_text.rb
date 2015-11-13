class ChangeBzzdyxxToText < ActiveRecord::Migration
  def change
		change_column :check_items, :BZZDYXX, :text
  end
end
