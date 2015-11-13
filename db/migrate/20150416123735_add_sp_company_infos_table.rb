class AddSpCompanyInfosTable < ActiveRecord::Migration
  def change
    create_table "sp_company_infos", :force => true do |t|
      t.string   "sp_s_1",     :limit => 60
      t.string   "sp_s_68",    :limit => 60
      t.string   "sp_s_23",    :limit => 60
      t.string   "sp_s_215"
      t.string   "sp_s_bsfl",  :limit => 60
      t.string   "sp_s_201"
      t.string   "sp_s_3",     :limit => 60
      t.string   "sp_s_4",     :limit => 60
      t.string   "sp_s_5",     :limit => 60
      t.string   "sp_s_7",     :limit => 60
      t.string   "sp_s_10",    :limit => 60
      t.string   "sp_s_8",     :limit => 60
      t.string   "sp_s_9",     :limit => 60
      t.string   "sp_s_11",    :limit => 60
      t.string   "sp_s_12",    :limit => 60
      t.datetime "created_at",               :null => false
      t.datetime "updated_at",               :null => false
      t.string   "sp_s_2"
    end unless table_exists?("sp_company_infos")
  end
end
