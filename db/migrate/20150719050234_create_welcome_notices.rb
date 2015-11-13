class CreateWelcomeNotices < ActiveRecord::Migration
  def change
    create_table :welcome_notices do |t|
      t.string :title
      t.integer :red
      t.integer :top
      t.string :attachment_path

      t.timestamps
    end
  end
end
