class ChangeBzTypeToCheckItems < ActiveRecord::Migration
  def change
    change_column :check_items, :BZ ,:string, limit:1000
    change_column :check_items, :JYYJJHB,:string, limit:1000
  end
end
