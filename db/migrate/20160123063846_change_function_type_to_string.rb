class ChangeFunctionTypeToString < ActiveRecord::Migration
  def change
    change_column :users, :function_type, :string, limit: 128
  end
end
