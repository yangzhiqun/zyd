class AddColumnToCheckItems < ActiveRecord::Migration
  def change
    add_column :check_items, :JYYJJHB, :string, limit: 512
    add_column :check_items, :BZ, :string, limit: 512
  end
end
