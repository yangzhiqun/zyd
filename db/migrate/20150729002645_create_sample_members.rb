class CreateSampleMembers < ActiveRecord::Migration
  def change
    create_table :sample_members do |t|
      t.string :jg_name
      t.string :username
      t.string :uid
      t.string :major
      t.string :edu_bg
      t.string :title
      t.string :mobile
      t.string :work_history
      t.string :note
      t.integer :attachment_id

      t.timestamps
    end
  end
end
