class AddTelToUser < ActiveRecord::Migration
  def change
      add_column :users, :tel, :string
      add_column :users, :eaddress, :string
      add_column :users, :company, :string
      
  end
end
