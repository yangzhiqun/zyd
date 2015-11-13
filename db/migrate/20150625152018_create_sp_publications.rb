class CreateSpPublications < ActiveRecord::Migration
  def change
    create_table :sp_publications do |t|
      t.string :name
      t.integer :user_id
      t.integer :worker_state

      t.timestamps
    end
  end
end
