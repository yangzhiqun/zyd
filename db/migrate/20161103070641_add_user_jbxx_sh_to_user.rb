class AddUserJbxxShToUser < ActiveRecord::Migration
  def change
    add_column :users, :jbxx_sh, :integer, default: 0
  end
end
