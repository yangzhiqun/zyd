class AddEnableToUsers < ActiveRecord::Migration
  def change
    add_column :users, :enable, :boolean, default: false
  end
end
