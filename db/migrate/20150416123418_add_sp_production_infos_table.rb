class AddSpProductionInfosTable < ActiveRecord::Migration
  def change
    create_table "sp_production_infos", :force => true do |t|
      t.string   "scbh"
      t.string   "cpmc"
      t.string   "fzdw"
      t.date     "fzrq"
      t.string   "jyfs"
      t.string   "qymc"
      t.string   "scdz"
      t.date     "zsyxq"
      t.string   "zs" 
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.string   "spdl"
      t.string   "spyl"
      t.string   "spcyl"
      t.string   "spxl"
      t.string   "sp_s_3"
      t.string   "sp_s_4"
      t.string   "sp_s_5"
    end unless table_exists? "sp_production_infos"
  end
end
