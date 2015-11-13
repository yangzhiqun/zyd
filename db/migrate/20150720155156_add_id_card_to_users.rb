class AddIdCardToUsers < ActiveRecord::Migration
  def change
		add_column :users, :id_card, :string, :unique => true unless column_exists? :users, :id_card
  end
end
