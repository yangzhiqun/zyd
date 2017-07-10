class ChangeBzTypeToCheckItems < ActiveRecord::Migration
  def change
    change_column :check_items, :BZ ,:text
    change_column :check_items, :JYYJJHB,:text
  end
end
