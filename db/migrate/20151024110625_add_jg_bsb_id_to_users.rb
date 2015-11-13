class AddJgBsbIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :jg_bsb_id, :integer
  end
end
