class AddTnameToUser < ActiveRecord::Migration
  def change
    add_column :users, :tname, :string,:limit => 30
  end
end
