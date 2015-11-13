class ChangeTypeOfJgdwToText < ActiveRecord::Migration
  def change
		change_column :check_items, :JGDW, :text
  end
end
