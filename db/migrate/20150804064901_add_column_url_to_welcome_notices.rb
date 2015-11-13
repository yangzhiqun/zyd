class AddColumnUrlToWelcomeNotices < ActiveRecord::Migration
  def change
    add_column :welcome_notices, :url, :string
  end
end
