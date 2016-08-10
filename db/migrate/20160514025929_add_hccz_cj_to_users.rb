class AddHcczCjToUsers < ActiveRecord::Migration
  def change
		add_column :users, :hccz_level, :integer, default: 0
		add_column :users, :hccz_type, :integer, default: 0
  end
end
