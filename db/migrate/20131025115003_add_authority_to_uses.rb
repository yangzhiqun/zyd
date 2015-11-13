class AddAuthorityToUses < ActiveRecord::Migration
  def change
  add_column :users, :user_d_authority_1, :integer
  end
end
