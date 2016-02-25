class AddFunctionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :function_type, :integer, default: -1, limit: 3
  end
end
