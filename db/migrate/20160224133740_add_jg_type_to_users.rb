class AddJgTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :jg_type, :integer, default: 0
  end
end
