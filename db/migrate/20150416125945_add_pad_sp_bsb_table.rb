class AddPadSpBsbTable < ActiveRecord::Migration
  def change
    create_table "pad_sp_bsbs", :force => true do |t|
      t.string   "sp_s_1",          :limit => 60
      t.datetime "created_at",                                                                      :null => false
      t.datetime "updated_at",                                                                      :null => false
      t.string   "sp_s_2",          :limit => 60
      t.string   "sp_s_3",          :limit => 60
      t.string   "sp_s_4",          :limit => 60
      t.string   "sp_s_5",          :limit => 60
      t.string   "sp_s_6",          :limit => 60
      t.string   "sp_s_7",          :limit => 60
      t.string   "sp_s_8",          :limit => 60
      t.string   "sp_s_9",          :limit => 60
      t.string   "sp_s_10",         :limit => 60
      t.string   "sp_s_11",         :limit => 60
      t.string   "sp_s_12",         :limit => 60
      t.string   "sp_s_13",         :limit => 60
      t.string   "sp_s_14",         :limit => 60
      t.decimal  "sp_n_15",                       :precision => 10, :scale => 2
      t.string   "sp_s_16",         :limit => 60
      t.string   "sp_s_17",         :limit => 60
      t.string   "sp_s_18",         :limit => 60
      t.string   "sp_s_19",         :limit => 60
      t.string   "sp_s_20",         :limit => 60
      t.string   "sp_s_21",         :limit => 60
      t.date     "sp_d_22"
      t.string   "sp_s_23",         :limit => 60
      t.string   "sp_s_24",         :limit => 60
      t.string   "sp_s_25",         :limit => 60
      t.string   "sp_s_26",         :limit => 60
      t.string   "sp_s_27",         :limit => 60
      t.date     "sp_d_28"
      t.decimal  "sp_n_29",                       :precision => 10, :scale => 0
      t.string   "sp_s_30",         :limit => 60
      t.decimal  "sp_n_31",                       :precision => 10, :scale => 0
      t.decimal  "sp_n_32",                       :precision => 10, :scale => 0
      t.string   "sp_s_33",         :limit => 60
      t.string   "sp_s_34"
      t.string   "sp_s_35",         :limit => 60
      t.string   "sp_s_36",         :limit => 60
      t.string   "sp_s_37",         :limit => 60
      t.date     "sp_d_38"
      t.string   "sp_s_39",         :limit => 60
      t.string   "sp_s_40",         :limit => 60
      t.string   "sp_s_41",         :limit => 60
      t.string   "sp_s_42",         :limit => 60
      t.string   "sp_s_43",         :limit => 60
      t.string   "sp_s_44",         :limit => 60
      t.string   "sp_s_45",         :limit => 60
      t.date     "sp_d_46"
      t.date     "sp_d_47"
      t.string   "sp_s_48",         :limit => 60
      t.string   "sp_s_49",         :limit => 60
      t.string   "sp_s_50",         :limit => 60
      t.string   "sp_s_51",         :limit => 60
      t.text     "sp_s_52"
      t.text     "sp_s_53"
      t.text     "sp_s_54"
      t.text     "sp_s_55"
      t.string   "sp_s_56",         :limit => 60
      t.string   "sp_s_57",         :limit => 60
      t.string   "sp_s_58",         :limit => 60
      t.string   "sp_s_59",         :limit => 60
      t.string   "sp_s_60",         :limit => 60
      t.string   "sp_s_61",         :limit => 60
      t.string   "sp_s_62",         :limit => 60
      t.string   "sp_s_63",         :limit => 60
      t.string   "sp_s_64",         :limit => 60
      t.string   "sp_s_65"
      t.string   "sp_s_66",         :limit => 60
      t.string   "sp_s_67",         :limit => 60
      t.string   "sp_s_68",         :limit => 60
      t.string   "sp_s_69",         :limit => 60
      t.string   "sp_s_70",         :limit => 60
      t.text     "sp_s_71"
      t.string   "sp_s_72",         :limit => 60
      t.string   "sp_s_73",         :limit => 60
      t.string   "sp_s_74",         :limit => 60
      t.string   "sp_s_75",         :limit => 60
      t.string   "sp_s_76",         :limit => 60
      t.string   "sp_s_77",         :limit => 60
      t.string   "sp_s_78",         :limit => 60
      t.string   "sp_s_79",         :limit => 60
      t.string   "sp_s_80",         :limit => 60
      t.string   "sp_s_81",         :limit => 60
      t.string   "sp_s_82",         :limit => 60
      t.string   "sp_s_83",         :limit => 60
      t.string   "sp_s_84"
      t.string   "sp_s_85",         :limit => 60
      t.date     "sp_d_86"
      t.string   "sp_s_87",         :limit => 60
      t.string   "sp_s_88",         :limit => 60
      t.string   "tname",           :limit => 60
      t.datetime "submit_d_flag"
      t.decimal  "sp_n_jcxcount",                 :precision => 10, :scale => 0
      t.string   "sp_s_bsfl",       :limit => 60
      t.string   "sp_s_2_1"
      t.integer  "sp_i_state"
      t.integer  "sp_i_jgback"
      t.text     "sp_s_reason"
      t.integer  "sp_i_backtimes"
      t.string   "sp_s_201"
      t.string   "sp_s_202"
      t.string   "sp_s_203"
      t.string   "sp_s_204"
      t.string   "sp_s_205"
      t.string   "sp_s_206"
      t.string   "sp_s_207"
      t.string   "sp_s_208"
      t.string   "sp_s_209"
      t.string   "sp_s_210"
      t.string   "sp_s_211"
      t.string   "sp_s_212"
      t.string   "sp_s_213"
      t.string   "sp_s_214"
      t.string   "sp_s_215"
      t.text     "sp_t_procedure"
      t.string   "gps"
      t.text     "failed_message"
      t.string   "refuse_pic_path"
      t.boolean  "via_api",                                                      :default => false
    end
  end
end
