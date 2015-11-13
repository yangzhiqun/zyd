class AddSpBsbsPicturesTable < ActiveRecord::Migration
  def change
		create_table "sp_bsb_pictures", :force => true do |t|
			t.integer  "sp_bsb_id"
			t.string   "desc"
			t.string   "path"
			t.integer  "sort_index"
			t.datetime "created_at", :null => false
			t.datetime "updated_at", :null => false
			t.string   "md5"
		end unless table_exists?('sp_bsb_pictures')
  end
end
