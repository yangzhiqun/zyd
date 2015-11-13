class CreateAttachments < ActiveRecord::Migration
  def change
		create_table "attachments", force: true do |t| 
			t.string   "filename"
			t.string   "path"
			t.string   "content_type"
			t.string   "md5"
			t.integer  "user_id"
			t.datetime "created_at"
			t.datetime "updated_at"
		end
  end
end
