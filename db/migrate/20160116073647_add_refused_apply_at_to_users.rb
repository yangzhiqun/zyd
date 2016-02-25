class AddRefusedApplyAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :apply_refused_at, :datetime
  end
end
