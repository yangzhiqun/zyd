class CreateSpBsbPublications < ActiveRecord::Migration
  def change
    create_table :sp_bsb_publications do |t|
      t.string :title
      t.integer :user_id
      t.string :username

      t.timestamps
    end
  end
end
