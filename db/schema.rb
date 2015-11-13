# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20151109130037) do

  create_table "a_categories", :force => true do |t|
    t.integer  "bgfl_id"
    t.string   "name"
    t.string   "note"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "identifier"
    t.boolean  "enable",     :default => true
  end

  create_table "attachments", :force => true do |t|
    t.string   "filename"
    t.string   "path"
    t.string   "content_type"
    t.string   "md5"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "b_categories", :force => true do |t|
    t.string   "name"
    t.integer  "a_category_id"
    t.string   "note"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "identifier"
    t.boolean  "enable",        :default => true
  end

  create_table "baosong_as", :force => true do |t|
    t.string   "name"
    t.string   "note"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "prov"
    t.string   "rwlylx"
  end

  create_table "baosong_bs", :force => true do |t|
    t.string   "name"
    t.string   "note"
    t.integer  "baosong_a_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "identifier"
    t.string   "prov"
  end

  create_table "baosong_mofify_logs", :force => true do |t|
    t.integer  "baosong_a_id"
    t.integer  "baosong_b_id"
    t.string   "identifier"
    t.text     "msg"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "bjp_bsbs", :force => true do |t|
    t.string   "bjp_s_1",        :limit => 60
    t.string   "bjp_s_2",        :limit => 60
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.string   "bjp_s_6",        :limit => 100
    t.string   "bjp_s_7",        :limit => 60
    t.string   "bjp_s_8",        :limit => 60
    t.string   "bjp_s_9",        :limit => 60
    t.string   "bjp_s_10",       :limit => 60
    t.string   "bjp_s_11",       :limit => 60
    t.string   "bjp_s_12",       :limit => 60
    t.string   "bjp_s_13",       :limit => 60
    t.string   "bjp_s_14",       :limit => 60
    t.string   "bjp_s_15",       :limit => 30
    t.string   "bjp_s_16",       :limit => 30
    t.string   "bjp_s_17",       :limit => 30
    t.string   "bjp_s_18",       :limit => 30
    t.string   "bjp_s_19",       :limit => 30
    t.string   "bjp_s_20",       :limit => 30
    t.string   "bjp_s_22",       :limit => 30
    t.date     "bjp_d_21"
    t.string   "bjp_s_3",        :limit => 60
    t.string   "bjp_s_4",        :limit => 60
    t.string   "bjp_s_5",        :limit => 60
    t.string   "bjp_s_23",       :limit => 30
    t.decimal  "bjp_n_24",                      :precision => 10, :scale => 0
    t.string   "bjp_s_25",       :limit => 30
    t.decimal  "bjp_n_26",                      :precision => 10, :scale => 0
    t.string   "bjp_s_27",       :limit => 30
    t.string   "bjp_s_28",       :limit => 60
    t.string   "bjp_s_29",       :limit => 60
    t.string   "bjp_s_30",       :limit => 60
    t.string   "bjp_s_31",       :limit => 60
    t.string   "bjp_s_32",       :limit => 30
    t.string   "bjp_s_33",       :limit => 30
    t.date     "bjp_d_34"
    t.string   "bjp_s_35",       :limit => 30
    t.string   "bjp_s_36",       :limit => 30
    t.string   "bjp_s_37"
    t.string   "bjp_s_38",       :limit => 30
    t.string   "bjp_s_39"
    t.string   "bjp_s_40"
    t.string   "bjp_s_41"
    t.date     "bjp_d_42"
    t.date     "bjp_d_43"
    t.string   "bjp_s_44",       :limit => 60
    t.string   "bjp_s_45",       :limit => 60
    t.string   "bjp_s_46",       :limit => 60
    t.string   "bjp_s_47",       :limit => 60
    t.string   "bjp_s_48",       :limit => 60
    t.string   "bjp_s_49",       :limit => 60
    t.string   "bjp_s_50",       :limit => 60
    t.string   "bjp_s_51",       :limit => 60
    t.string   "bjp_s_52",       :limit => 60
    t.string   "bjp_s_53",       :limit => 60
    t.string   "bjp_s_54",       :limit => 60
    t.string   "bjp_s_55",       :limit => 60
    t.string   "bjp_s_56",       :limit => 60
    t.string   "bjp_s_57",       :limit => 60
    t.string   "bjp_s_58",       :limit => 60
    t.string   "bjp_s_59",       :limit => 60
    t.string   "bjp_s_60",       :limit => 60
    t.string   "bjp_s_61",       :limit => 60
    t.string   "bjp_s_62",       :limit => 60
    t.string   "bjp_s_63",       :limit => 60
    t.string   "bjp_s_64",       :limit => 60
    t.string   "bjp_s_65"
    t.string   "bjp_s_66"
    t.string   "bjp_s_67"
    t.string   "bjp_s_68"
    t.string   "bjp_s_69"
    t.string   "bjp_s_70"
    t.string   "bjp_s_71"
    t.string   "bjp_s_72"
    t.string   "bjp_s_73"
    t.string   "bjp_s_74"
    t.string   "bjp_s_75"
    t.string   "bjp_s_76"
    t.string   "bjp_s_77"
    t.string   "bjp_s_78"
    t.string   "bjp_s_79"
    t.string   "bjp_s_80"
    t.string   "bjp_s_81"
    t.string   "bjp_s_82"
    t.string   "bjp_s_83"
    t.string   "bjp_s_84"
    t.string   "bjp_s_85"
    t.string   "bjp_s_87"
    t.string   "bjp_s_88"
    t.string   "bjp_s_86"
    t.string   "bjp_s_89"
    t.string   "bjp_s_90"
    t.string   "bjp_s_91"
    t.string   "bjp_s_92"
    t.string   "bjp_s_93"
    t.string   "bjp_s_94"
    t.date     "bjp_d_95"
    t.string   "bjp_s_96"
    t.string   "bjp_s_97"
    t.string   "tname",          :limit => 60
    t.datetime "submit_d_flag"
    t.decimal  "bjp_n_jcxcount",                :precision => 10, :scale => 0
    t.string   "bjp_s_bsfl",     :limit => 16
    t.string   "bjp_s_2_1",      :limit => 16
    t.string   "bjp_s_40_1",     :limit => 16
    t.string   "bjp_s_110_1",    :limit => 16
    t.string   "bjp_s_110_2",    :limit => 16
    t.string   "bjp_s_110_3",    :limit => 16
    t.string   "bjp_s_110_4",    :limit => 16
    t.string   "bjp_s_110_5",    :limit => 16
    t.string   "bjp_s_110_6",    :limit => 16
    t.string   "bjp_s_110_7",    :limit => 16
    t.string   "bjp_s_110_8",    :limit => 16
    t.string   "bjp_s_111_1",    :limit => 16
    t.string   "bjp_s_111_2",    :limit => 16
    t.string   "bjp_s_111_3",    :limit => 16
    t.string   "bjp_s_111_4",    :limit => 16
    t.string   "bjp_s_111_5",    :limit => 16
    t.string   "bjp_s_111_6",    :limit => 16
    t.string   "bjp_s_111_7",    :limit => 16
    t.string   "bjp_s_111_8",    :limit => 16
    t.string   "bjp_s_112_1",    :limit => 16
    t.string   "bjp_s_112_2",    :limit => 16
    t.string   "bjp_s_112_3",    :limit => 16
    t.string   "bjp_s_112_4",    :limit => 16
    t.string   "bjp_s_112_5",    :limit => 16
    t.string   "bjp_s_112_6",    :limit => 16
    t.string   "bjp_s_112_7",    :limit => 16
    t.string   "bjp_s_112_8",    :limit => 16
    t.string   "bjp_s_113_1",    :limit => 16
    t.string   "bjp_s_113_2",    :limit => 16
    t.string   "bjp_s_113_3",    :limit => 16
    t.string   "bjp_s_113_4",    :limit => 16
    t.string   "bjp_s_113_5",    :limit => 16
    t.string   "bjp_s_113_6",    :limit => 16
    t.string   "bjp_s_113_7",    :limit => 16
    t.string   "bjp_s_113_8",    :limit => 16
    t.string   "bjp_s_114_1",    :limit => 16
    t.string   "bjp_s_114_2",    :limit => 16
    t.string   "bjp_s_114_3",    :limit => 16
    t.string   "bjp_s_114_4",    :limit => 16
    t.string   "bjp_s_114_5",    :limit => 16
    t.string   "bjp_s_114_6",    :limit => 16
    t.string   "bjp_s_114_7",    :limit => 16
    t.string   "bjp_s_114_8",    :limit => 16
    t.string   "bjp_s_115_1",    :limit => 16
    t.string   "bjp_s_115_2",    :limit => 16
    t.string   "bjp_s_115_3",    :limit => 16
    t.string   "bjp_s_115_4",    :limit => 16
    t.string   "bjp_s_115_5",    :limit => 16
    t.string   "bjp_s_115_6",    :limit => 16
    t.string   "bjp_s_115_7",    :limit => 16
    t.string   "bjp_s_115_8",    :limit => 16
    t.string   "bjp_s_116_1",    :limit => 16
    t.string   "bjp_s_116_2",    :limit => 16
    t.string   "bjp_s_116_3",    :limit => 16
    t.string   "bjp_s_116_4",    :limit => 16
    t.string   "bjp_s_116_5",    :limit => 16
    t.string   "bjp_s_116_6",    :limit => 16
    t.string   "bjp_s_116_7",    :limit => 16
    t.string   "bjp_s_116_8",    :limit => 16
    t.string   "bjp_s_117_1",    :limit => 16
    t.string   "bjp_s_117_2",    :limit => 16
    t.string   "bjp_s_117_3",    :limit => 16
    t.string   "bjp_s_117_4",    :limit => 16
    t.string   "bjp_s_117_5",    :limit => 16
    t.string   "bjp_s_117_6",    :limit => 16
    t.string   "bjp_s_117_7",    :limit => 16
    t.string   "bjp_s_117_8",    :limit => 16
    t.string   "bjp_s_118_1",    :limit => 16
    t.string   "bjp_s_118_2",    :limit => 16
    t.string   "bjp_s_118_3",    :limit => 16
    t.string   "bjp_s_118_4",    :limit => 16
    t.string   "bjp_s_118_5",    :limit => 16
    t.string   "bjp_s_118_6",    :limit => 16
    t.string   "bjp_s_118_7",    :limit => 16
    t.string   "bjp_s_118_8",    :limit => 16
    t.string   "bjp_s_119_1",    :limit => 16
    t.string   "bjp_s_119_2",    :limit => 16
    t.string   "bjp_s_119_3",    :limit => 16
    t.string   "bjp_s_119_4",    :limit => 16
    t.string   "bjp_s_119_5",    :limit => 16
    t.string   "bjp_s_119_6",    :limit => 16
    t.string   "bjp_s_119_7",    :limit => 16
    t.string   "bjp_s_119_8",    :limit => 16
    t.string   "bjp_s_120_1",    :limit => 16
    t.string   "bjp_s_120_2",    :limit => 16
    t.string   "bjp_s_120_3",    :limit => 16
    t.string   "bjp_s_120_4",    :limit => 16
    t.string   "bjp_s_120_5",    :limit => 16
    t.string   "bjp_s_120_6",    :limit => 16
    t.string   "bjp_s_120_7",    :limit => 16
    t.string   "bjp_s_120_8",    :limit => 16
    t.string   "bjp_s_121_1",    :limit => 16
    t.string   "bjp_s_121_2",    :limit => 16
    t.string   "bjp_s_121_3",    :limit => 16
    t.string   "bjp_s_121_4",    :limit => 16
    t.string   "bjp_s_121_5",    :limit => 16
    t.string   "bjp_s_121_6",    :limit => 16
    t.string   "bjp_s_121_7",    :limit => 16
    t.string   "bjp_s_121_8",    :limit => 16
    t.string   "bjp_s_122_1",    :limit => 16
    t.string   "bjp_s_122_2",    :limit => 16
    t.string   "bjp_s_122_3",    :limit => 16
    t.string   "bjp_s_122_4",    :limit => 16
    t.string   "bjp_s_122_5",    :limit => 16
    t.string   "bjp_s_122_6",    :limit => 16
    t.string   "bjp_s_122_7",    :limit => 16
    t.string   "bjp_s_122_8",    :limit => 16
    t.string   "bjp_s_123_1",    :limit => 16
    t.string   "bjp_s_123_2",    :limit => 16
    t.string   "bjp_s_123_3",    :limit => 16
    t.string   "bjp_s_123_4",    :limit => 16
    t.string   "bjp_s_123_5",    :limit => 16
    t.string   "bjp_s_123_6",    :limit => 16
    t.string   "bjp_s_123_7",    :limit => 16
    t.string   "bjp_s_123_8",    :limit => 16
    t.string   "bjp_s_124_1",    :limit => 16
    t.string   "bjp_s_124_2",    :limit => 16
    t.string   "bjp_s_124_3",    :limit => 16
    t.string   "bjp_s_124_4",    :limit => 16
    t.string   "bjp_s_124_5",    :limit => 16
    t.string   "bjp_s_124_6",    :limit => 16
    t.string   "bjp_s_124_7",    :limit => 16
    t.string   "bjp_s_124_8",    :limit => 16
    t.string   "bjp_s_125_1",    :limit => 16
    t.string   "bjp_s_125_2",    :limit => 16
    t.string   "bjp_s_125_3",    :limit => 16
    t.string   "bjp_s_125_4",    :limit => 16
    t.string   "bjp_s_125_5",    :limit => 16
    t.string   "bjp_s_125_6",    :limit => 16
    t.string   "bjp_s_125_7",    :limit => 16
    t.string   "bjp_s_125_8",    :limit => 16
    t.string   "bjp_s_126_1",    :limit => 16
    t.string   "bjp_s_126_2",    :limit => 16
    t.string   "bjp_s_126_3",    :limit => 16
    t.string   "bjp_s_126_4",    :limit => 16
    t.string   "bjp_s_126_5",    :limit => 16
    t.string   "bjp_s_126_6",    :limit => 16
    t.string   "bjp_s_126_7",    :limit => 16
    t.string   "bjp_s_126_8",    :limit => 16
    t.string   "bjp_s_127_1",    :limit => 16
    t.string   "bjp_s_127_2",    :limit => 16
    t.string   "bjp_s_127_3",    :limit => 16
    t.string   "bjp_s_127_4",    :limit => 16
    t.string   "bjp_s_127_5",    :limit => 16
    t.string   "bjp_s_127_6",    :limit => 16
    t.string   "bjp_s_127_7",    :limit => 16
    t.string   "bjp_s_127_8",    :limit => 16
    t.string   "bjp_s_128_1",    :limit => 16
    t.string   "bjp_s_128_2",    :limit => 16
    t.string   "bjp_s_128_3",    :limit => 16
    t.string   "bjp_s_128_4",    :limit => 16
    t.string   "bjp_s_128_5",    :limit => 16
    t.string   "bjp_s_128_6",    :limit => 16
    t.string   "bjp_s_128_7",    :limit => 16
    t.string   "bjp_s_128_8",    :limit => 16
    t.string   "bjp_s_129_1",    :limit => 16
    t.string   "bjp_s_129_2",    :limit => 16
    t.string   "bjp_s_129_3",    :limit => 16
    t.string   "bjp_s_129_4",    :limit => 16
    t.string   "bjp_s_129_5",    :limit => 16
    t.string   "bjp_s_129_6",    :limit => 16
    t.string   "bjp_s_129_7",    :limit => 16
    t.string   "bjp_s_129_8",    :limit => 16
    t.string   "bjp_s_130_1",    :limit => 16
    t.string   "bjp_s_130_2",    :limit => 16
    t.string   "bjp_s_130_3",    :limit => 16
    t.string   "bjp_s_130_4",    :limit => 16
    t.string   "bjp_s_130_5",    :limit => 16
    t.string   "bjp_s_130_6",    :limit => 16
    t.string   "bjp_s_130_7",    :limit => 16
    t.string   "bjp_s_130_8",    :limit => 16
    t.string   "bjp_s_131_1",    :limit => 16
    t.string   "bjp_s_131_2",    :limit => 16
    t.string   "bjp_s_131_3",    :limit => 16
    t.string   "bjp_s_131_4",    :limit => 16
    t.string   "bjp_s_131_5",    :limit => 16
    t.string   "bjp_s_131_6",    :limit => 16
    t.string   "bjp_s_131_7",    :limit => 16
    t.string   "bjp_s_131_8",    :limit => 16
    t.string   "bjp_s_132_1",    :limit => 16
    t.string   "bjp_s_132_2",    :limit => 16
    t.string   "bjp_s_132_3",    :limit => 16
    t.string   "bjp_s_132_4",    :limit => 16
    t.string   "bjp_s_132_5",    :limit => 16
    t.string   "bjp_s_132_6",    :limit => 16
    t.string   "bjp_s_132_7",    :limit => 16
    t.string   "bjp_s_132_8",    :limit => 16
    t.string   "bjp_s_133_1",    :limit => 16
    t.string   "bjp_s_133_2",    :limit => 16
    t.string   "bjp_s_133_3",    :limit => 16
    t.string   "bjp_s_133_4",    :limit => 16
    t.string   "bjp_s_133_5",    :limit => 16
    t.string   "bjp_s_133_6",    :limit => 16
    t.string   "bjp_s_133_7",    :limit => 16
    t.string   "bjp_s_133_8",    :limit => 16
    t.string   "bjp_s_134_1",    :limit => 16
    t.string   "bjp_s_134_2",    :limit => 16
    t.string   "bjp_s_134_3",    :limit => 16
    t.string   "bjp_s_134_4",    :limit => 16
    t.string   "bjp_s_134_5",    :limit => 16
    t.string   "bjp_s_134_6",    :limit => 16
    t.string   "bjp_s_134_7",    :limit => 16
    t.string   "bjp_s_134_8",    :limit => 16
    t.string   "bjp_s_135_1",    :limit => 16
    t.string   "bjp_s_135_2",    :limit => 16
    t.string   "bjp_s_135_3",    :limit => 16
    t.string   "bjp_s_135_4",    :limit => 16
    t.string   "bjp_s_135_5",    :limit => 16
    t.string   "bjp_s_135_6",    :limit => 16
    t.string   "bjp_s_135_7",    :limit => 16
    t.string   "bjp_s_135_8",    :limit => 16
    t.string   "bjp_s_136_1",    :limit => 16
    t.string   "bjp_s_136_2",    :limit => 16
    t.string   "bjp_s_136_3",    :limit => 16
    t.string   "bjp_s_136_4",    :limit => 16
    t.string   "bjp_s_136_5",    :limit => 16
    t.string   "bjp_s_136_6",    :limit => 16
    t.string   "bjp_s_136_7",    :limit => 16
    t.string   "bjp_s_136_8",    :limit => 16
    t.string   "bjp_s_137_1",    :limit => 16
    t.string   "bjp_s_137_2",    :limit => 16
    t.string   "bjp_s_137_3",    :limit => 16
    t.string   "bjp_s_137_4",    :limit => 16
    t.string   "bjp_s_137_5",    :limit => 16
    t.string   "bjp_s_137_6",    :limit => 16
    t.string   "bjp_s_137_7",    :limit => 16
    t.string   "bjp_s_137_8",    :limit => 16
    t.string   "bjp_s_138_1",    :limit => 16
    t.string   "bjp_s_138_2",    :limit => 16
    t.string   "bjp_s_138_3",    :limit => 16
    t.string   "bjp_s_138_4",    :limit => 16
    t.string   "bjp_s_138_5",    :limit => 16
    t.string   "bjp_s_138_6",    :limit => 16
    t.string   "bjp_s_138_7",    :limit => 16
    t.string   "bjp_s_138_8",    :limit => 16
    t.string   "bjp_s_139_1",    :limit => 16
    t.string   "bjp_s_139_2",    :limit => 16
    t.string   "bjp_s_139_3",    :limit => 16
    t.string   "bjp_s_139_4",    :limit => 16
    t.string   "bjp_s_139_5",    :limit => 16
    t.string   "bjp_s_139_6",    :limit => 16
    t.string   "bjp_s_139_7",    :limit => 16
    t.string   "bjp_s_139_8",    :limit => 16
    t.string   "bjp_s_140_1",    :limit => 16
    t.string   "bjp_s_140_2",    :limit => 16
    t.string   "bjp_s_140_3",    :limit => 16
    t.string   "bjp_s_140_4",    :limit => 16
    t.string   "bjp_s_140_5",    :limit => 16
    t.string   "bjp_s_140_6",    :limit => 16
    t.string   "bjp_s_140_7",    :limit => 16
    t.string   "bjp_s_140_8",    :limit => 16
    t.string   "bjp_s_110_9",    :limit => 16
    t.string   "bjp_s_111_9",    :limit => 16
    t.string   "bjp_s_112_9",    :limit => 16
    t.string   "bjp_s_113_9",    :limit => 16
    t.string   "bjp_s_114_9",    :limit => 16
    t.string   "bjp_s_115_9",    :limit => 16
    t.string   "bjp_s_116_9",    :limit => 16
    t.string   "bjp_s_117_9",    :limit => 16
    t.string   "bjp_s_118_9",    :limit => 16
    t.string   "bjp_s_119_9",    :limit => 16
    t.string   "bjp_s_120_9",    :limit => 16
    t.string   "bjp_s_121_9",    :limit => 16
    t.string   "bjp_s_122_9",    :limit => 16
    t.string   "bjp_s_123_9",    :limit => 16
    t.string   "bjp_s_124_9",    :limit => 16
    t.string   "bjp_s_125_9",    :limit => 16
    t.string   "bjp_s_126_9",    :limit => 16
    t.string   "bjp_s_127_9",    :limit => 16
    t.string   "bjp_s_128_9",    :limit => 16
    t.string   "bjp_s_129_9",    :limit => 16
    t.string   "bjp_s_130_9",    :limit => 16
    t.string   "bjp_s_131_9",    :limit => 16
    t.string   "bjp_s_132_9",    :limit => 16
    t.string   "bjp_s_133_9",    :limit => 16
    t.string   "bjp_s_134_9",    :limit => 16
    t.string   "bjp_s_135_9",    :limit => 16
    t.string   "bjp_s_136_9",    :limit => 16
    t.string   "bjp_s_137_9",    :limit => 16
    t.string   "bjp_s_138_9",    :limit => 16
    t.string   "bjp_s_139_9",    :limit => 16
    t.string   "bjp_s_140_9",    :limit => 16
    t.string   "bjp_s_110_0",    :limit => 16
    t.string   "bjp_s_111_0",    :limit => 16
    t.string   "bjp_s_112_0",    :limit => 16
    t.string   "bjp_s_113_0",    :limit => 16
    t.string   "bjp_s_114_0",    :limit => 16
    t.string   "bjp_s_115_0",    :limit => 16
    t.string   "bjp_s_116_0",    :limit => 16
    t.string   "bjp_s_117_0",    :limit => 16
    t.string   "bjp_s_118_0",    :limit => 16
    t.string   "bjp_s_119_0",    :limit => 16
    t.string   "bjp_s_120_0",    :limit => 16
    t.string   "bjp_s_121_0",    :limit => 16
    t.string   "bjp_s_122_0",    :limit => 16
    t.string   "bjp_s_123_0",    :limit => 16
    t.string   "bjp_s_124_0",    :limit => 16
    t.string   "bjp_s_125_0",    :limit => 16
    t.string   "bjp_s_126_0",    :limit => 16
    t.string   "bjp_s_127_0",    :limit => 16
    t.string   "bjp_s_128_0",    :limit => 16
    t.string   "bjp_s_129_0",    :limit => 16
    t.string   "bjp_s_130_0",    :limit => 16
    t.string   "bjp_s_131_0",    :limit => 16
    t.string   "bjp_s_132_0",    :limit => 16
    t.string   "bjp_s_133_0",    :limit => 16
    t.string   "bjp_s_134_0",    :limit => 16
    t.string   "bjp_s_135_0",    :limit => 16
    t.string   "bjp_s_136_0",    :limit => 16
    t.string   "bjp_s_137_0",    :limit => 16
    t.string   "bjp_s_138_0",    :limit => 16
    t.string   "bjp_s_139_0",    :limit => 16
    t.string   "bjp_s_140_0",    :limit => 16
    t.string   "bjp_s_110_10",   :limit => 16
    t.string   "bjp_s_111_10",   :limit => 16
    t.string   "bjp_s_112_10",   :limit => 16
    t.string   "bjp_s_113_10",   :limit => 16
    t.string   "bjp_s_114_10",   :limit => 16
    t.string   "bjp_s_115_10",   :limit => 16
    t.string   "bjp_s_116_10",   :limit => 16
    t.string   "bjp_s_117_10",   :limit => 16
    t.string   "bjp_s_118_10",   :limit => 16
    t.string   "bjp_s_119_10",   :limit => 16
    t.string   "bjp_s_120_10",   :limit => 16
    t.string   "bjp_s_121_10",   :limit => 16
    t.string   "bjp_s_122_10",   :limit => 16
    t.string   "bjp_s_123_10",   :limit => 16
    t.string   "bjp_s_124_10",   :limit => 16
    t.string   "bjp_s_125_10",   :limit => 16
    t.string   "bjp_s_126_10",   :limit => 16
    t.string   "bjp_s_127_10",   :limit => 16
    t.string   "bjp_s_128_10",   :limit => 16
    t.string   "bjp_s_129_10",   :limit => 16
    t.string   "bjp_s_130_10",   :limit => 16
    t.string   "bjp_s_131_10",   :limit => 16
    t.string   "bjp_s_132_10",   :limit => 16
    t.string   "bjp_s_133_10",   :limit => 16
    t.string   "bjp_s_134_10",   :limit => 16
    t.string   "bjp_s_135_10",   :limit => 16
    t.string   "bjp_s_136_10",   :limit => 16
    t.string   "bjp_s_137_10",   :limit => 16
    t.string   "bjp_s_138_10",   :limit => 16
    t.string   "bjp_s_139_10",   :limit => 16
    t.string   "bjp_s_140_10",   :limit => 16
    t.integer  "bjp_i_state"
  end

  create_table "bjpdata", :force => true do |t|
    t.string   "bjpdata_0"
    t.string   "bjpdata_1"
    t.string   "bjpdata_2"
    t.string   "bjpdata_3"
    t.string   "bjpdata_4"
    t.string   "bjpdata_5"
    t.string   "bjpdata_6"
    t.string   "bjpdata_7"
    t.string   "bjpdata_8"
    t.string   "bjpdata_9"
    t.integer  "bjp_bsb_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "c_categories", :force => true do |t|
    t.string   "name"
    t.integer  "a_category_id"
    t.integer  "b_category_id"
    t.string   "note"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "identifier"
    t.boolean  "enable",        :default => true
  end

  create_table "check_items", :force => true do |t|
    t.string   "name"
    t.text     "JGDW"
    t.text     "JYYJ"
    t.text     "PDYJ"
    t.text     "BZFFJCX"
    t.string   "BZFFJCXDW"
    t.string   "BZZXYXX"
    t.string   "BZZXYXXDW"
    t.text     "BZZDYXX"
    t.string   "BZZDYXXDW"
    t.integer  "d_category_id"
    t.integer  "a_category_id"
    t.integer  "b_category_id"
    t.integer  "c_category_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "identifier"
    t.boolean  "enable",        :default => true
  end

  create_table "company_standards", :force => true do |t|
    t.string   "name"
    t.string   "number"
    t.string   "author_company"
    t.date     "valid_at"
    t.integer  "attachment_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "user_id"
    t.string   "attachment_path"
  end

  create_table "d_categories", :force => true do |t|
    t.string   "name"
    t.integer  "a_category_id"
    t.integer  "b_category_id"
    t.integer  "c_category_id"
    t.string   "note"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "identifier"
    t.boolean  "enable",        :default => true
  end

  create_table "flexcontents", :force => true do |t|
    t.string   "flex_field"
    t.string   "flex_name"
    t.string   "flex_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "flex_sortid"
    t.integer  "flex_groupid"
  end

  create_table "hzp_bc_dws", :force => true do |t|
    t.string   "dwname"
    t.string   "dwlx"
    t.string   "dwsf"
    t.string   "dwdq"
    t.string   "dwxs"
    t.string   "dwxz"
    t.string   "dwdz"
    t.string   "dwyb"
    t.string   "dwfr"
    t.string   "dwfrdh"
    t.string   "dwfzr"
    t.string   "dwfzrdh"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "dwlxzdy"
  end

  create_table "hzp_bsbs", :force => true do |t|
    t.string   "hzp_s_1",        :limit => 60
    t.string   "hzp_s_2",        :limit => 60
    t.string   "hzp_s_3",        :limit => 60
    t.string   "hzp_s_4",        :limit => 60
    t.string   "hzp_s_5",        :limit => 60
    t.string   "hzp_s_6",        :limit => 60
    t.string   "hzp_s_7",        :limit => 60
    t.string   "hzp_s_8",        :limit => 60
    t.string   "hzp_s_9",        :limit => 60
    t.string   "hzp_s_10",       :limit => 60
    t.string   "hzp_s_11",       :limit => 60
    t.string   "hzp_s_12",       :limit => 60
    t.string   "hzp_s_13",       :limit => 60
    t.string   "hzp_s_14",       :limit => 60
    t.string   "hzp_s_15",       :limit => 60
    t.string   "hzp_s_16",       :limit => 60
    t.string   "hzp_s_17",       :limit => 60
    t.string   "hzp_s_18",       :limit => 60
    t.string   "hzp_s_19",       :limit => 60
    t.date     "hzp_d_20"
    t.string   "hzp_s_21",       :limit => 60
    t.string   "hzp_s_22",       :limit => 60
    t.string   "hzp_s_23",       :limit => 60
    t.string   "hzp_s_24",       :limit => 60
    t.string   "hzp_s_25",       :limit => 60
    t.decimal  "hzp_n_26",                     :precision => 10, :scale => 0
    t.string   "hzp_s_27",       :limit => 60
    t.decimal  "hzp_n_28",                     :precision => 10, :scale => 0
    t.string   "hzp_s_29",       :limit => 60
    t.string   "hzp_s_30",       :limit => 60
    t.string   "hzp_s_31",       :limit => 60
    t.string   "hzp_s_32",       :limit => 60
    t.string   "hzp_s_33",       :limit => 60
    t.date     "hzp_d_34"
    t.string   "hzp_s_35",       :limit => 60
    t.string   "hzp_s_36",       :limit => 60
    t.string   "hzp_s_37",       :limit => 60
    t.string   "hzp_s_38",       :limit => 60
    t.string   "hzp_s_39",       :limit => 60
    t.string   "hzp_s_40",       :limit => 60
    t.string   "hzp_s_41",       :limit => 60
    t.date     "hzp_d_42"
    t.date     "hzp_d_43"
    t.string   "hzp_s_44",       :limit => 60
    t.string   "hzp_s_45",       :limit => 60
    t.string   "hzp_s_46",       :limit => 60
    t.string   "hzp_s_47",       :limit => 60
    t.string   "hzp_s_48",       :limit => 60
    t.string   "hzp_s_49",       :limit => 60
    t.string   "hzp_s_50",       :limit => 60
    t.string   "hzp_s_51",       :limit => 60
    t.string   "hzp_s_52",       :limit => 60
    t.string   "hzp_s_53",       :limit => 60
    t.string   "hzp_s_54",       :limit => 60
    t.string   "hzp_s_55",       :limit => 60
    t.string   "hzp_s_56",       :limit => 60
    t.string   "hzp_s_57",       :limit => 60
    t.string   "hzp_s_58",       :limit => 60
    t.string   "hzp_s_59",       :limit => 60
    t.string   "hzp_s_60",       :limit => 60
    t.string   "hzp_s_61",       :limit => 60
    t.string   "hzp_s_62",       :limit => 60
    t.string   "hzp_s_63",       :limit => 60
    t.string   "hzp_s_64",       :limit => 60
    t.string   "hzp_s_65",       :limit => 60
    t.string   "hzp_s_66",       :limit => 60
    t.string   "hzp_s_67",       :limit => 60
    t.string   "hzp_s_68",       :limit => 60
    t.string   "hzp_s_69",       :limit => 60
    t.string   "hzp_s_70",       :limit => 60
    t.string   "hzp_s_71",       :limit => 60
    t.string   "hzp_s_72",       :limit => 60
    t.string   "hzp_s_73",       :limit => 60
    t.string   "hzp_s_74",       :limit => 60
    t.string   "hzp_s_75",       :limit => 60
    t.string   "hzp_s_76",       :limit => 60
    t.string   "hzp_s_77",       :limit => 60
    t.string   "hzp_s_78",       :limit => 60
    t.string   "hzp_s_79",       :limit => 60
    t.string   "hzp_s_80",       :limit => 60
    t.string   "hzp_s_81",       :limit => 60
    t.string   "hzp_s_82",       :limit => 60
    t.string   "hzp_s_83",       :limit => 60
    t.string   "hzp_s_84",       :limit => 60
    t.string   "hzp_s_85",       :limit => 60
    t.string   "hzp_s_86",       :limit => 60
    t.string   "hzp_s_87",       :limit => 60
    t.string   "hzp_s_88",       :limit => 60
    t.string   "hzp_s_89",       :limit => 60
    t.date     "hzp_d_90"
    t.string   "hzp_s_91",       :limit => 60
    t.string   "hzp_s_92",       :limit => 60
    t.string   "tname",          :limit => 60
    t.date     "submit_d_flag"
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.decimal  "hzp_n_jcxcount",               :precision => 10, :scale => 0
    t.string   "hzp_s_bsfl",     :limit => 16
    t.string   "hzp_s_2_1",      :limit => 16
    t.string   "hzp_s_16_1",     :limit => 16
    t.string   "hzp_s_40_1",     :limit => 16
    t.string   "hzp_s_110_1",    :limit => 16
    t.string   "hzp_s_110_2",    :limit => 16
    t.string   "hzp_s_110_3",    :limit => 16
    t.string   "hzp_s_110_4",    :limit => 16
    t.string   "hzp_s_110_5",    :limit => 16
    t.string   "hzp_s_110_6",    :limit => 16
    t.string   "hzp_s_110_7",    :limit => 16
    t.string   "hzp_s_110_8",    :limit => 16
    t.string   "hzp_s_111_1",    :limit => 16
    t.string   "hzp_s_111_2",    :limit => 16
    t.string   "hzp_s_111_3",    :limit => 16
    t.string   "hzp_s_111_4",    :limit => 16
    t.string   "hzp_s_111_5",    :limit => 16
    t.string   "hzp_s_111_6",    :limit => 16
    t.string   "hzp_s_111_7",    :limit => 16
    t.string   "hzp_s_111_8",    :limit => 16
    t.string   "hzp_s_112_1",    :limit => 16
    t.string   "hzp_s_112_2",    :limit => 16
    t.string   "hzp_s_112_3",    :limit => 16
    t.string   "hzp_s_112_4",    :limit => 16
    t.string   "hzp_s_112_5",    :limit => 16
    t.string   "hzp_s_112_6",    :limit => 16
    t.string   "hzp_s_112_7",    :limit => 16
    t.string   "hzp_s_112_8",    :limit => 16
    t.string   "hzp_s_113_1",    :limit => 16
    t.string   "hzp_s_113_2",    :limit => 16
    t.string   "hzp_s_113_3",    :limit => 16
    t.string   "hzp_s_113_4",    :limit => 16
    t.string   "hzp_s_113_5",    :limit => 16
    t.string   "hzp_s_113_6",    :limit => 16
    t.string   "hzp_s_113_7",    :limit => 16
    t.string   "hzp_s_113_8",    :limit => 16
    t.string   "hzp_s_114_1",    :limit => 16
    t.string   "hzp_s_114_2",    :limit => 16
    t.string   "hzp_s_114_3",    :limit => 16
    t.string   "hzp_s_114_4",    :limit => 16
    t.string   "hzp_s_114_5",    :limit => 16
    t.string   "hzp_s_114_6",    :limit => 16
    t.string   "hzp_s_114_7",    :limit => 16
    t.string   "hzp_s_114_8",    :limit => 16
    t.string   "hzp_s_115_1",    :limit => 16
    t.string   "hzp_s_115_2",    :limit => 16
    t.string   "hzp_s_115_3",    :limit => 16
    t.string   "hzp_s_115_4",    :limit => 16
    t.string   "hzp_s_115_5",    :limit => 16
    t.string   "hzp_s_115_6",    :limit => 16
    t.string   "hzp_s_115_7",    :limit => 16
    t.string   "hzp_s_115_8",    :limit => 16
    t.string   "hzp_s_116_1",    :limit => 16
    t.string   "hzp_s_116_2",    :limit => 16
    t.string   "hzp_s_116_3",    :limit => 16
    t.string   "hzp_s_116_4",    :limit => 16
    t.string   "hzp_s_116_5",    :limit => 16
    t.string   "hzp_s_116_6",    :limit => 16
    t.string   "hzp_s_116_7",    :limit => 16
    t.string   "hzp_s_116_8",    :limit => 16
    t.string   "hzp_s_117_1",    :limit => 16
    t.string   "hzp_s_117_2",    :limit => 16
    t.string   "hzp_s_117_3",    :limit => 16
    t.string   "hzp_s_117_4",    :limit => 16
    t.string   "hzp_s_117_5",    :limit => 16
    t.string   "hzp_s_117_6",    :limit => 16
    t.string   "hzp_s_117_7",    :limit => 16
    t.string   "hzp_s_117_8",    :limit => 16
    t.string   "hzp_s_118_1",    :limit => 16
    t.string   "hzp_s_118_2",    :limit => 16
    t.string   "hzp_s_118_3",    :limit => 16
    t.string   "hzp_s_118_4",    :limit => 16
    t.string   "hzp_s_118_5",    :limit => 16
    t.string   "hzp_s_118_6",    :limit => 16
    t.string   "hzp_s_118_7",    :limit => 16
    t.string   "hzp_s_118_8",    :limit => 16
    t.string   "hzp_s_119_1",    :limit => 16
    t.string   "hzp_s_119_2",    :limit => 16
    t.string   "hzp_s_119_3",    :limit => 16
    t.string   "hzp_s_119_4",    :limit => 16
    t.string   "hzp_s_119_5",    :limit => 16
    t.string   "hzp_s_119_6",    :limit => 16
    t.string   "hzp_s_119_7",    :limit => 16
    t.string   "hzp_s_119_8",    :limit => 16
    t.string   "hzp_s_120_1",    :limit => 16
    t.string   "hzp_s_120_2",    :limit => 16
    t.string   "hzp_s_120_3",    :limit => 16
    t.string   "hzp_s_120_4",    :limit => 16
    t.string   "hzp_s_120_5",    :limit => 16
    t.string   "hzp_s_120_6",    :limit => 16
    t.string   "hzp_s_120_7",    :limit => 16
    t.string   "hzp_s_120_8",    :limit => 16
    t.string   "hzp_s_121_1",    :limit => 16
    t.string   "hzp_s_121_2",    :limit => 16
    t.string   "hzp_s_121_3",    :limit => 16
    t.string   "hzp_s_121_4",    :limit => 16
    t.string   "hzp_s_121_5",    :limit => 16
    t.string   "hzp_s_121_6",    :limit => 16
    t.string   "hzp_s_121_7",    :limit => 16
    t.string   "hzp_s_121_8",    :limit => 16
    t.string   "hzp_s_122_1",    :limit => 16
    t.string   "hzp_s_122_2",    :limit => 16
    t.string   "hzp_s_122_3",    :limit => 16
    t.string   "hzp_s_122_4",    :limit => 16
    t.string   "hzp_s_122_5",    :limit => 16
    t.string   "hzp_s_122_6",    :limit => 16
    t.string   "hzp_s_122_7",    :limit => 16
    t.string   "hzp_s_122_8",    :limit => 16
    t.string   "hzp_s_123_1",    :limit => 16
    t.string   "hzp_s_123_2",    :limit => 16
    t.string   "hzp_s_123_3",    :limit => 16
    t.string   "hzp_s_123_4",    :limit => 16
    t.string   "hzp_s_123_5",    :limit => 16
    t.string   "hzp_s_123_6",    :limit => 16
    t.string   "hzp_s_123_7",    :limit => 16
    t.string   "hzp_s_123_8",    :limit => 16
    t.string   "hzp_s_124_1",    :limit => 16
    t.string   "hzp_s_124_2",    :limit => 16
    t.string   "hzp_s_124_3",    :limit => 16
    t.string   "hzp_s_124_4",    :limit => 16
    t.string   "hzp_s_124_5",    :limit => 16
    t.string   "hzp_s_124_6",    :limit => 16
    t.string   "hzp_s_124_7",    :limit => 16
    t.string   "hzp_s_124_8",    :limit => 16
    t.string   "hzp_s_125_1",    :limit => 16
    t.string   "hzp_s_125_2",    :limit => 16
    t.string   "hzp_s_125_3",    :limit => 16
    t.string   "hzp_s_125_4",    :limit => 16
    t.string   "hzp_s_125_5",    :limit => 16
    t.string   "hzp_s_125_6",    :limit => 16
    t.string   "hzp_s_125_7",    :limit => 16
    t.string   "hzp_s_125_8",    :limit => 16
    t.string   "hzp_s_126_1",    :limit => 16
    t.string   "hzp_s_126_2",    :limit => 16
    t.string   "hzp_s_126_3",    :limit => 16
    t.string   "hzp_s_126_4",    :limit => 16
    t.string   "hzp_s_126_5",    :limit => 16
    t.string   "hzp_s_126_6",    :limit => 16
    t.string   "hzp_s_126_7",    :limit => 16
    t.string   "hzp_s_126_8",    :limit => 16
    t.string   "hzp_s_127_1",    :limit => 16
    t.string   "hzp_s_127_2",    :limit => 16
    t.string   "hzp_s_127_3",    :limit => 16
    t.string   "hzp_s_127_4",    :limit => 16
    t.string   "hzp_s_127_5",    :limit => 16
    t.string   "hzp_s_127_6",    :limit => 16
    t.string   "hzp_s_127_7",    :limit => 16
    t.string   "hzp_s_127_8",    :limit => 16
    t.string   "hzp_s_128_1",    :limit => 16
    t.string   "hzp_s_128_2",    :limit => 16
    t.string   "hzp_s_128_3",    :limit => 16
    t.string   "hzp_s_128_4",    :limit => 16
    t.string   "hzp_s_128_5",    :limit => 16
    t.string   "hzp_s_128_6",    :limit => 16
    t.string   "hzp_s_128_7",    :limit => 16
    t.string   "hzp_s_128_8",    :limit => 16
    t.string   "hzp_s_129_1",    :limit => 16
    t.string   "hzp_s_129_2",    :limit => 16
    t.string   "hzp_s_129_3",    :limit => 16
    t.string   "hzp_s_129_4",    :limit => 16
    t.string   "hzp_s_129_5",    :limit => 16
    t.string   "hzp_s_129_6",    :limit => 16
    t.string   "hzp_s_129_7",    :limit => 16
    t.string   "hzp_s_129_8",    :limit => 16
    t.string   "hzp_s_130_1",    :limit => 16
    t.string   "hzp_s_130_2",    :limit => 16
    t.string   "hzp_s_130_3",    :limit => 16
    t.string   "hzp_s_130_4",    :limit => 16
    t.string   "hzp_s_130_5",    :limit => 16
    t.string   "hzp_s_130_6",    :limit => 16
    t.string   "hzp_s_130_7",    :limit => 16
    t.string   "hzp_s_130_8",    :limit => 16
    t.string   "hzp_s_131_1",    :limit => 16
    t.string   "hzp_s_131_2",    :limit => 16
    t.string   "hzp_s_131_3",    :limit => 16
    t.string   "hzp_s_131_4",    :limit => 16
    t.string   "hzp_s_131_5",    :limit => 16
    t.string   "hzp_s_131_6",    :limit => 16
    t.string   "hzp_s_131_7",    :limit => 16
    t.string   "hzp_s_131_8",    :limit => 16
    t.string   "hzp_s_132_1",    :limit => 16
    t.string   "hzp_s_132_2",    :limit => 16
    t.string   "hzp_s_132_3",    :limit => 16
    t.string   "hzp_s_132_4",    :limit => 16
    t.string   "hzp_s_132_5",    :limit => 16
    t.string   "hzp_s_132_6",    :limit => 16
    t.string   "hzp_s_132_7",    :limit => 16
    t.string   "hzp_s_132_8",    :limit => 16
    t.string   "hzp_s_133_1",    :limit => 16
    t.string   "hzp_s_133_2",    :limit => 16
    t.string   "hzp_s_133_3",    :limit => 16
    t.string   "hzp_s_133_4",    :limit => 16
    t.string   "hzp_s_133_5",    :limit => 16
    t.string   "hzp_s_133_6",    :limit => 16
    t.string   "hzp_s_133_7",    :limit => 16
    t.string   "hzp_s_133_8",    :limit => 16
    t.string   "hzp_s_134_1",    :limit => 16
    t.string   "hzp_s_134_2",    :limit => 16
    t.string   "hzp_s_134_3",    :limit => 16
    t.string   "hzp_s_134_4",    :limit => 16
    t.string   "hzp_s_134_5",    :limit => 16
    t.string   "hzp_s_134_6",    :limit => 16
    t.string   "hzp_s_134_7",    :limit => 16
    t.string   "hzp_s_134_8",    :limit => 16
    t.string   "hzp_s_135_1",    :limit => 16
    t.string   "hzp_s_135_2",    :limit => 16
    t.string   "hzp_s_135_3",    :limit => 16
    t.string   "hzp_s_135_4",    :limit => 16
    t.string   "hzp_s_135_5",    :limit => 16
    t.string   "hzp_s_135_6",    :limit => 16
    t.string   "hzp_s_135_7",    :limit => 16
    t.string   "hzp_s_135_8",    :limit => 16
    t.string   "hzp_s_136_1",    :limit => 16
    t.string   "hzp_s_136_2",    :limit => 16
    t.string   "hzp_s_136_3",    :limit => 16
    t.string   "hzp_s_136_4",    :limit => 16
    t.string   "hzp_s_136_5",    :limit => 16
    t.string   "hzp_s_136_6",    :limit => 16
    t.string   "hzp_s_136_7",    :limit => 16
    t.string   "hzp_s_136_8",    :limit => 16
    t.string   "hzp_s_137_1",    :limit => 16
    t.string   "hzp_s_137_2",    :limit => 16
    t.string   "hzp_s_137_3",    :limit => 16
    t.string   "hzp_s_137_4",    :limit => 16
    t.string   "hzp_s_137_5",    :limit => 16
    t.string   "hzp_s_137_6",    :limit => 16
    t.string   "hzp_s_137_7",    :limit => 16
    t.string   "hzp_s_137_8",    :limit => 16
    t.string   "hzp_s_138_1",    :limit => 16
    t.string   "hzp_s_138_2",    :limit => 16
    t.string   "hzp_s_138_3",    :limit => 16
    t.string   "hzp_s_138_4",    :limit => 16
    t.string   "hzp_s_138_5",    :limit => 16
    t.string   "hzp_s_138_6",    :limit => 16
    t.string   "hzp_s_138_7",    :limit => 16
    t.string   "hzp_s_138_8",    :limit => 16
    t.string   "hzp_s_139_1",    :limit => 16
    t.string   "hzp_s_139_2",    :limit => 16
    t.string   "hzp_s_139_3",    :limit => 16
    t.string   "hzp_s_139_4",    :limit => 16
    t.string   "hzp_s_139_5",    :limit => 16
    t.string   "hzp_s_139_6",    :limit => 16
    t.string   "hzp_s_139_7",    :limit => 16
    t.string   "hzp_s_139_8",    :limit => 16
    t.string   "hzp_s_140_1",    :limit => 16
    t.string   "hzp_s_140_2",    :limit => 16
    t.string   "hzp_s_140_3",    :limit => 16
    t.string   "hzp_s_140_4",    :limit => 16
    t.string   "hzp_s_140_5",    :limit => 16
    t.string   "hzp_s_140_6",    :limit => 16
    t.string   "hzp_s_140_7",    :limit => 16
    t.string   "hzp_s_140_8",    :limit => 16
    t.string   "hzp_s_110_0",    :limit => 16
    t.string   "hzp_s_111_0",    :limit => 16
    t.string   "hzp_s_112_0",    :limit => 16
    t.string   "hzp_s_113_0",    :limit => 16
    t.string   "hzp_s_114_0",    :limit => 16
    t.string   "hzp_s_115_0",    :limit => 16
    t.string   "hzp_s_116_0",    :limit => 16
    t.string   "hzp_s_117_0",    :limit => 16
    t.string   "hzp_s_118_0",    :limit => 16
    t.string   "hzp_s_119_0",    :limit => 16
    t.string   "hzp_s_120_0",    :limit => 16
    t.string   "hzp_s_121_0",    :limit => 16
    t.string   "hzp_s_122_0",    :limit => 16
    t.string   "hzp_s_123_0",    :limit => 16
    t.string   "hzp_s_124_0",    :limit => 16
    t.string   "hzp_s_125_0",    :limit => 16
    t.string   "hzp_s_126_0",    :limit => 16
    t.string   "hzp_s_127_0",    :limit => 16
    t.string   "hzp_s_128_0",    :limit => 16
    t.string   "hzp_s_129_0",    :limit => 16
    t.string   "hzp_s_130_0",    :limit => 16
    t.string   "hzp_s_131_0",    :limit => 16
    t.string   "hzp_s_132_0",    :limit => 16
    t.string   "hzp_s_133_0",    :limit => 16
    t.string   "hzp_s_134_0",    :limit => 16
    t.string   "hzp_s_135_0",    :limit => 16
    t.string   "hzp_s_136_0",    :limit => 16
    t.string   "hzp_s_137_0",    :limit => 16
    t.string   "hzp_s_138_0",    :limit => 16
    t.string   "hzp_s_139_0",    :limit => 16
    t.string   "hzp_s_140_0",    :limit => 16
    t.string   "hzp_s_110_9",    :limit => 16
    t.string   "hzp_s_111_9",    :limit => 16
    t.string   "hzp_s_112_9",    :limit => 16
    t.string   "hzp_s_113_9",    :limit => 16
    t.string   "hzp_s_114_9",    :limit => 16
    t.string   "hzp_s_115_9",    :limit => 16
    t.string   "hzp_s_116_9",    :limit => 16
    t.string   "hzp_s_117_9",    :limit => 16
    t.string   "hzp_s_118_9",    :limit => 16
    t.string   "hzp_s_119_9",    :limit => 16
    t.string   "hzp_s_120_9",    :limit => 16
    t.string   "hzp_s_121_9",    :limit => 16
    t.string   "hzp_s_122_9",    :limit => 16
    t.string   "hzp_s_123_9",    :limit => 16
    t.string   "hzp_s_124_9",    :limit => 16
    t.string   "hzp_s_125_9",    :limit => 16
    t.string   "hzp_s_126_9",    :limit => 16
    t.string   "hzp_s_127_9",    :limit => 16
    t.string   "hzp_s_128_9",    :limit => 16
    t.string   "hzp_s_129_9",    :limit => 16
    t.string   "hzp_s_130_9",    :limit => 16
    t.string   "hzp_s_131_9",    :limit => 16
    t.string   "hzp_s_132_9",    :limit => 16
    t.string   "hzp_s_133_9",    :limit => 16
    t.string   "hzp_s_134_9",    :limit => 16
    t.string   "hzp_s_135_9",    :limit => 16
    t.string   "hzp_s_136_9",    :limit => 16
    t.string   "hzp_s_137_9",    :limit => 16
    t.string   "hzp_s_138_9",    :limit => 16
    t.string   "hzp_s_139_9",    :limit => 16
    t.string   "hzp_s_140_9",    :limit => 16
    t.integer  "hzp_i_state"
    t.string   "hzp_s_110_10",   :limit => 16
    t.string   "hzp_s_111_10",   :limit => 16
    t.string   "hzp_s_112_10",   :limit => 16
    t.string   "hzp_s_113_10",   :limit => 16
    t.string   "hzp_s_114_10",   :limit => 16
    t.string   "hzp_s_115_10",   :limit => 16
    t.string   "hzp_s_116_10",   :limit => 16
    t.string   "hzp_s_117_10",   :limit => 16
    t.string   "hzp_s_118_10",   :limit => 16
    t.string   "hzp_s_119_10",   :limit => 16
    t.string   "hzp_s_120_10",   :limit => 16
    t.string   "hzp_s_121_10",   :limit => 16
    t.string   "hzp_s_122_10",   :limit => 16
    t.string   "hzp_s_123_10",   :limit => 16
    t.string   "hzp_s_124_10",   :limit => 16
    t.string   "hzp_s_125_10",   :limit => 16
    t.string   "hzp_s_126_10",   :limit => 16
    t.string   "hzp_s_127_10",   :limit => 16
    t.string   "hzp_s_128_10",   :limit => 16
    t.string   "hzp_s_129_10",   :limit => 16
    t.string   "hzp_s_130_10",   :limit => 16
    t.string   "hzp_s_131_10",   :limit => 16
    t.string   "hzp_s_132_10",   :limit => 16
    t.string   "hzp_s_133_10",   :limit => 16
    t.string   "hzp_s_134_10",   :limit => 16
    t.string   "hzp_s_135_10",   :limit => 16
    t.string   "hzp_s_136_10",   :limit => 16
    t.string   "hzp_s_137_10",   :limit => 16
    t.string   "hzp_s_138_10",   :limit => 16
    t.string   "hzp_s_139_10",   :limit => 16
    t.string   "hzp_s_140_10",   :limit => 16
  end

  create_table "hzp_ypbs", :force => true do |t|
    t.string   "dwname"
    t.string   "ypname"
    t.string   "ypno"
    t.string   "ypflei"
    t.string   "ypleib"
    t.string   "ypleibzdy"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "hzpdata", :force => true do |t|
    t.string   "hzpdata_0"
    t.string   "hzpdata_1"
    t.string   "hzpdata_2"
    t.string   "hzpdata_3"
    t.string   "hzpdata_4"
    t.string   "hzpdata_5"
    t.string   "hzpdata_6"
    t.string   "hzpdata_7"
    t.string   "hzpdata_8"
    t.string   "hzpdata_9"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "hzp_bsb_id"
  end

  create_table "jg_bsb_names", :force => true do |t|
    t.string   "name"
    t.integer  "jg_bsb_id"
    t.string   "note"
    t.integer  "creator_user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "jg_bsb_stamps", :force => true do |t|
    t.integer  "jg_bsb_id"
    t.string   "stamp_no"
    t.string   "note"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "image_path"
  end

  create_table "jg_bsbs", :force => true do |t|
    t.string   "jg_name"
    t.string   "jg_address"
    t.string   "jg_leader"
    t.string   "jg_higher_level"
    t.string   "jg_contacts"
    t.string   "jg_tel"
    t.string   "jg_certification"
    t.string   "jg_word_area"
    t.integer  "jg_sampling"
    t.integer  "jg_detection"
    t.integer  "jg_group"
    t.string   "jg_group_category"
    t.integer  "jg_administrion"
    t.integer  "jg_sp_permission"
    t.integer  "jg_bjp_permission"
    t.integer  "jg_hzp_permission"
    t.integer  "jg_enable"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "jg_province"
    t.string   "jg_email"
    t.string   "code"
    t.string   "api_ip_address"
    t.string   "gpsname"
    t.string   "gpspassword"
    t.string   "attachment_path"
    t.string   "pdf_sign_rules"
    t.integer  "status",            :default => 0
  end

  create_table "mytests", :force => true do |t|
    t.string   "name"
    t.string   "age"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "orders", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.string   "email"
    t.string   "pay_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pad_sp_bsbs", :force => true do |t|
    t.string   "sp_s_1",            :limit => 60
    t.datetime "created_at",                                                                        :null => false
    t.datetime "updated_at",                                                                        :null => false
    t.string   "sp_s_2",                                                         :default => ""
    t.string   "sp_s_3",                                                         :default => ""
    t.string   "sp_s_4",            :limit => 60
    t.string   "sp_s_5",            :limit => 60
    t.string   "sp_s_6",            :limit => 60
    t.string   "sp_s_7",            :limit => 60
    t.string   "sp_s_8",            :limit => 60
    t.string   "sp_s_9",            :limit => 60
    t.string   "sp_s_10",           :limit => 60
    t.string   "sp_s_11",           :limit => 60
    t.string   "sp_s_12",           :limit => 60
    t.string   "sp_s_13",           :limit => 60
    t.string   "sp_s_14",                                                        :default => ""
    t.float    "sp_n_15"
    t.string   "sp_s_16",                                                        :default => ""
    t.string   "sp_s_17",                                                        :default => ""
    t.string   "sp_s_18",           :limit => 60
    t.string   "sp_s_19",           :limit => 60
    t.string   "sp_s_20",                                                        :default => ""
    t.string   "sp_s_21",           :limit => 60
    t.date     "sp_d_22"
    t.string   "sp_s_23",           :limit => 60
    t.string   "sp_s_24",           :limit => 60
    t.string   "sp_s_25",           :limit => 60
    t.string   "sp_s_26",           :limit => 60
    t.string   "sp_s_27",           :limit => 60
    t.date     "sp_d_28"
    t.string   "sp_n_29"
    t.string   "sp_s_30",           :limit => 60
    t.decimal  "sp_n_31",                         :precision => 10, :scale => 0
    t.decimal  "sp_n_32",                         :precision => 10, :scale => 0
    t.string   "sp_s_33",           :limit => 60
    t.string   "sp_s_34"
    t.string   "sp_s_35",                                                        :default => ""
    t.string   "sp_s_36",           :limit => 60
    t.string   "sp_s_37",           :limit => 60
    t.date     "sp_d_38"
    t.string   "sp_s_39",           :limit => 60
    t.string   "sp_s_40",           :limit => 60
    t.string   "sp_s_41",           :limit => 60
    t.string   "sp_s_42",           :limit => 60
    t.string   "sp_s_43",                                                        :default => ""
    t.string   "sp_s_44",           :limit => 60
    t.string   "sp_s_45",           :limit => 60
    t.date     "sp_d_46"
    t.date     "sp_d_47"
    t.string   "sp_s_48",           :limit => 60
    t.string   "sp_s_49",           :limit => 60
    t.string   "sp_s_50",           :limit => 60
    t.string   "sp_s_51",           :limit => 60
    t.text     "sp_s_52"
    t.text     "sp_s_53"
    t.text     "sp_s_54"
    t.text     "sp_s_55"
    t.string   "sp_s_56",           :limit => 60
    t.string   "sp_s_57",           :limit => 60
    t.string   "sp_s_58",           :limit => 60
    t.string   "sp_s_59",           :limit => 60
    t.string   "sp_s_60",           :limit => 60
    t.string   "sp_s_61",           :limit => 60
    t.string   "sp_s_62",           :limit => 60
    t.string   "sp_s_63",           :limit => 60
    t.string   "sp_s_64",           :limit => 60
    t.string   "sp_s_65"
    t.string   "sp_s_66",           :limit => 60
    t.string   "sp_s_67",           :limit => 60
    t.string   "sp_s_68",           :limit => 60
    t.string   "sp_s_69",           :limit => 60
    t.string   "sp_s_70",           :limit => 60
    t.text     "sp_s_71"
    t.string   "sp_s_72",           :limit => 60
    t.string   "sp_s_73",           :limit => 60
    t.string   "sp_s_74",           :limit => 60
    t.string   "sp_s_75",           :limit => 60
    t.string   "sp_s_76",           :limit => 60
    t.string   "sp_s_77",           :limit => 60
    t.string   "sp_s_78",           :limit => 60
    t.string   "sp_s_79",           :limit => 60
    t.string   "sp_s_80",           :limit => 60
    t.string   "sp_s_81",           :limit => 60
    t.string   "sp_s_82",           :limit => 60
    t.string   "sp_s_83",           :limit => 60
    t.string   "sp_s_84"
    t.string   "sp_s_85",                                                        :default => ""
    t.date     "sp_d_86"
    t.string   "sp_s_87",           :limit => 60
    t.string   "sp_s_88",           :limit => 60
    t.string   "tname",             :limit => 60
    t.datetime "submit_d_flag"
    t.decimal  "sp_n_jcxcount",                   :precision => 10, :scale => 0
    t.string   "sp_s_bsfl",         :limit => 60
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
    t.boolean  "via_api",                                                        :default => false
    t.string   "bgfl"
    t.string   "fail_report_path"
    t.integer  "jg_bsb_id"
    t.integer  "sys_province_id"
    t.integer  "a_category_id"
    t.text     "refuse_reason"
    t.string   "accept_file_path"
    t.integer  "b_category_id"
    t.integer  "c_category_id"
    t.integer  "d_category_id"
    t.string   "sp_xkz"
    t.string   "sp_xkz_id"
    t.string   "cyd_file_path"
    t.string   "cyjygzs_file_path"
  end

  add_index "pad_sp_bsbs", ["sp_s_1"], :name => "index_pad_sp_bsbs_on_sp_s_1"

  create_table "pad_sp_logs", :force => true do |t|
    t.text     "remark"
    t.integer  "pad_sp_bsb_id"
    t.text     "sp_s_16"
    t.integer  "sp_i_state"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image_url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "provinces", :id => false, :force => true do |t|
    t.string "sp_s_3", :default => ""
  end

  create_table "pub_sp_bsbs", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.string   "username"
    t.datetime "created_at",                                                                        :null => false
    t.datetime "updated_at",                                                                        :null => false
    t.integer  "publication_type",                                               :default => -1
    t.string   "sp_s_1",                                                         :default => ""
    t.string   "sp_s_2",                                                         :default => ""
    t.string   "sp_s_3",                                                         :default => ""
    t.string   "sp_s_4",            :limit => 60
    t.string   "sp_s_5",            :limit => 60
    t.string   "sp_s_6",            :limit => 60
    t.string   "sp_s_7"
    t.string   "sp_s_8",            :limit => 60
    t.string   "sp_s_9",            :limit => 60
    t.string   "sp_s_10",           :limit => 60
    t.string   "sp_s_11",           :limit => 60
    t.string   "sp_s_12",           :limit => 60
    t.string   "sp_s_13",           :limit => 60
    t.string   "sp_s_14",                                                        :default => ""
    t.decimal  "sp_n_15",                         :precision => 10, :scale => 2
    t.string   "sp_s_16",           :limit => 60
    t.string   "sp_s_17",                                                        :default => ""
    t.string   "sp_s_18",           :limit => 60
    t.string   "sp_s_19",           :limit => 60
    t.string   "sp_s_20",                                                        :default => ""
    t.string   "sp_s_21",           :limit => 60
    t.date     "sp_d_22"
    t.string   "sp_s_23",           :limit => 60
    t.string   "sp_s_24",           :limit => 60
    t.string   "sp_s_25",           :limit => 60
    t.string   "sp_s_26",           :limit => 60
    t.string   "sp_s_27",           :limit => 60
    t.date     "sp_d_28"
    t.string   "sp_n_29"
    t.string   "sp_s_30",           :limit => 60
    t.decimal  "sp_n_31",                         :precision => 10, :scale => 0
    t.decimal  "sp_n_32",                         :precision => 10, :scale => 0
    t.string   "sp_s_33",           :limit => 60
    t.string   "sp_s_34"
    t.string   "sp_s_35",                                                        :default => ""
    t.string   "sp_s_36",           :limit => 60
    t.string   "sp_s_37",           :limit => 60
    t.date     "sp_d_38"
    t.string   "sp_s_39",           :limit => 60
    t.string   "sp_s_40",           :limit => 60
    t.string   "sp_s_41",           :limit => 60
    t.string   "sp_s_42",           :limit => 60
    t.string   "sp_s_43",                                                        :default => ""
    t.string   "sp_s_44",           :limit => 60
    t.string   "sp_s_45",           :limit => 60
    t.date     "sp_d_46"
    t.date     "sp_d_47"
    t.string   "sp_s_48",           :limit => 60
    t.string   "sp_s_49",           :limit => 60
    t.string   "sp_s_50",           :limit => 60
    t.string   "sp_s_51",           :limit => 60
    t.text     "sp_s_52"
    t.text     "sp_s_53"
    t.text     "sp_s_54"
    t.text     "sp_s_55"
    t.string   "sp_s_56",           :limit => 60
    t.string   "sp_s_57",           :limit => 60
    t.string   "sp_s_58",           :limit => 60
    t.string   "sp_s_59",           :limit => 60
    t.string   "sp_s_60",           :limit => 60
    t.string   "sp_s_61",           :limit => 60
    t.string   "sp_s_62",           :limit => 60
    t.string   "sp_s_63",           :limit => 60
    t.string   "sp_s_64",                                                        :default => ""
    t.string   "sp_s_65"
    t.string   "sp_s_66",           :limit => 60
    t.string   "sp_s_67",           :limit => 60
    t.string   "sp_s_68",           :limit => 60
    t.string   "sp_s_69",           :limit => 60
    t.string   "sp_s_70",           :limit => 60
    t.string   "sp_s_71",           :limit => 60
    t.string   "sp_s_72",           :limit => 60
    t.string   "sp_s_73",           :limit => 60
    t.string   "sp_s_74",           :limit => 60
    t.string   "sp_s_75",           :limit => 60
    t.string   "sp_s_76",           :limit => 60
    t.string   "sp_s_77",           :limit => 60
    t.string   "sp_s_78",           :limit => 60
    t.string   "sp_s_79",           :limit => 60
    t.string   "sp_s_80",           :limit => 60
    t.string   "sp_s_81",           :limit => 60
    t.string   "sp_s_82",           :limit => 60
    t.string   "sp_s_83",           :limit => 60
    t.string   "sp_s_84"
    t.string   "sp_s_85",           :limit => 60
    t.date     "sp_d_86"
    t.string   "sp_s_87",           :limit => 60
    t.string   "sp_s_88",           :limit => 60
    t.string   "tname",             :limit => 60
    t.datetime "submit_d_flag"
    t.decimal  "sp_n_jcxcount",                   :precision => 10, :scale => 0
    t.string   "sp_s_bsfl",         :limit => 60
    t.string   "sp_s_2_1",                                                       :default => ""
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
    t.string   "fail_report_path"
    t.boolean  "is_yydj",                                                        :default => false
    t.integer  "current_yycz_step",                                              :default => -1
    t.string   "bgfl",                                                           :default => ""
    t.string   "sp_xkz"
    t.string   "sp_xkz_id"
    t.datetime "fail_report_at"
    t.boolean  "czb_reverted_flag",                                              :default => false
    t.boolean  "synced",                                                         :default => false
    t.string   "gbsj",                                                           :default => "0"
    t.integer  "sp_bsb_id",                                                                         :null => false
  end

  create_table "pub_spdata", :force => true do |t|
    t.integer  "sp_bsb_publication_id"
    t.string   "spdata_0"
    t.string   "spdata_1"
    t.string   "spdata_2"
    t.string   "spdata_3"
    t.string   "spdata_4"
    t.string   "spdata_5"
    t.string   "spdata_6"
    t.string   "spdata_7"
    t.string   "spdata_8"
    t.string   "spdata_9"
    t.string   "spdata_10"
    t.string   "spdata_11"
    t.string   "spdata_12"
    t.string   "spdata_13"
    t.string   "spdata_14"
    t.string   "spdata_15"
    t.string   "spdata_16"
    t.string   "spdata_17"
    t.string   "spdata_18"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "spdata_id",             :null => false
  end

  create_table "published_sp_bsbs", :force => true do |t|
    t.string   "cjbh"
    t.datetime "published_at"
    t.integer  "user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.date     "cfda_published_at"
  end

  create_table "sample_members", :force => true do |t|
    t.string   "jg_name"
    t.string   "username"
    t.string   "uid"
    t.string   "major"
    t.string   "edu_bg"
    t.string   "title"
    t.string   "mobile"
    t.string   "work_history"
    t.string   "note"
    t.integer  "attachment_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "gender",        :limit => 5
  end

  create_table "sp_bsb_certs", :force => true do |t|
    t.text     "source"
    t.text     "user_cert"
    t.text     "sign"
    t.integer  "user_id"
    t.integer  "sp_i_state"
    t.integer  "sp_bsb_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sp_bsb_pictures", :force => true do |t|
    t.integer  "sp_bsb_id"
    t.string   "desc"
    t.string   "path"
    t.integer  "sort_index"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "md5"
  end

  create_table "sp_bsb_reports", :force => true do |t|
    t.string   "name"
    t.datetime "start_at"
    t.datetime "finished_at"
    t.datetime "failed_at"
    t.string   "result_file"
    t.text     "result_msg"
    t.string   "flowid"
    t.integer  "user_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "jid"
    t.integer  "current_state", :default => 0
  end

  create_table "sp_bsbs", :force => true do |t|
    t.string   "sp_s_1",                                                                :default => ""
    t.datetime "created_at",                                                                               :null => false
    t.datetime "updated_at",                                                                               :null => false
    t.string   "sp_s_2",                                                                :default => ""
    t.string   "sp_s_3",                                                                :default => ""
    t.string   "sp_s_4",                   :limit => 60
    t.string   "sp_s_5",                   :limit => 60
    t.string   "sp_s_6",                   :limit => 60
    t.string   "sp_s_7"
    t.string   "sp_s_8",                   :limit => 60
    t.string   "sp_s_9",                   :limit => 60
    t.string   "sp_s_10",                  :limit => 60
    t.string   "sp_s_11",                  :limit => 60
    t.string   "sp_s_12",                  :limit => 60
    t.string   "sp_s_13",                  :limit => 60
    t.string   "sp_s_14",                                                               :default => ""
    t.float    "sp_n_15"
    t.string   "sp_s_16",                  :limit => 60
    t.string   "sp_s_17",                                                               :default => ""
    t.string   "sp_s_18",                  :limit => 60
    t.string   "sp_s_19",                  :limit => 60
    t.string   "sp_s_20",                                                               :default => ""
    t.string   "sp_s_21",                  :limit => 60
    t.date     "sp_d_22"
    t.string   "sp_s_23",                  :limit => 60
    t.string   "sp_s_24",                  :limit => 60
    t.string   "sp_s_25",                  :limit => 60
    t.string   "sp_s_26",                  :limit => 60
    t.string   "sp_s_27",                  :limit => 60
    t.date     "sp_d_28"
    t.string   "sp_n_29"
    t.string   "sp_s_30",                  :limit => 60
    t.decimal  "sp_n_31",                                :precision => 10, :scale => 0
    t.decimal  "sp_n_32",                                :precision => 10, :scale => 0
    t.string   "sp_s_33",                  :limit => 60
    t.string   "sp_s_34"
    t.string   "sp_s_35",                                                               :default => ""
    t.string   "sp_s_36",                  :limit => 60
    t.string   "sp_s_37",                  :limit => 60
    t.date     "sp_d_38"
    t.string   "sp_s_39",                  :limit => 60
    t.string   "sp_s_40",                  :limit => 60
    t.string   "sp_s_41",                  :limit => 60
    t.string   "sp_s_42",                  :limit => 60
    t.string   "sp_s_43",                                                               :default => ""
    t.string   "sp_s_44",                  :limit => 60
    t.string   "sp_s_45",                  :limit => 60
    t.date     "sp_d_46"
    t.date     "sp_d_47"
    t.string   "sp_s_48",                  :limit => 60
    t.string   "sp_s_49",                  :limit => 60
    t.string   "sp_s_50",                  :limit => 60
    t.string   "sp_s_51",                  :limit => 60
    t.text     "sp_s_52"
    t.text     "sp_s_53"
    t.text     "sp_s_54"
    t.text     "sp_s_55"
    t.string   "sp_s_56",                  :limit => 60
    t.string   "sp_s_57",                  :limit => 60
    t.string   "sp_s_58",                  :limit => 60
    t.string   "sp_s_59",                  :limit => 60
    t.string   "sp_s_60",                  :limit => 60
    t.string   "sp_s_61",                  :limit => 60
    t.string   "sp_s_62",                  :limit => 60
    t.string   "sp_s_63",                  :limit => 60
    t.string   "sp_s_64",                                                               :default => ""
    t.string   "sp_s_65"
    t.string   "sp_s_66",                  :limit => 60
    t.string   "sp_s_67",                  :limit => 60
    t.string   "sp_s_68",                  :limit => 60
    t.string   "sp_s_69",                  :limit => 60
    t.string   "sp_s_70",                  :limit => 60
    t.string   "sp_s_71",                  :limit => 60
    t.string   "sp_s_72",                  :limit => 60
    t.string   "sp_s_73",                  :limit => 60
    t.string   "sp_s_74",                  :limit => 60
    t.string   "sp_s_75",                  :limit => 60
    t.string   "sp_s_76",                  :limit => 60
    t.string   "sp_s_77",                  :limit => 60
    t.string   "sp_s_78",                  :limit => 60
    t.string   "sp_s_79",                  :limit => 60
    t.string   "sp_s_80",                  :limit => 60
    t.string   "sp_s_81",                  :limit => 60
    t.string   "sp_s_82",                  :limit => 60
    t.string   "sp_s_83",                  :limit => 60
    t.string   "sp_s_84"
    t.string   "sp_s_85",                  :limit => 60
    t.date     "sp_d_86"
    t.string   "sp_s_87",                  :limit => 60
    t.string   "sp_s_88",                  :limit => 60
    t.string   "tname",                    :limit => 60
    t.datetime "submit_d_flag"
    t.decimal  "sp_n_jcxcount",                          :precision => 10, :scale => 0
    t.string   "sp_s_bsfl",                :limit => 60
    t.string   "sp_s_2_1",                                                              :default => ""
    t.integer  "sp_i_state",                                                            :default => 0
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
    t.string   "fail_report_path"
    t.boolean  "is_yydj",                                                               :default => false
    t.integer  "current_yycz_step",                                                     :default => -1
    t.string   "bgfl",                                                                  :default => ""
    t.string   "sp_xkz"
    t.string   "sp_xkz_id"
    t.datetime "fail_report_at"
    t.boolean  "czb_reverted_flag",                                                     :default => false
    t.boolean  "synced",                                                                :default => false
    t.string   "gbsj",                                                                  :default => "未公布"
    t.string   "report_path"
    t.string   "cyd_file_path"
    t.string   "cyjygzs_file_path"
    t.datetime "yydj_enabled_by_admin_at"
  end

  add_index "sp_bsbs", ["id"], :name => "index_sp_bsbs_on_id"
  add_index "sp_bsbs", ["sp_d_86"], :name => "index_sp_bsbs_on_sp_d_86"
  add_index "sp_bsbs", ["sp_i_state"], :name => "index_on_sp_i_state"
  add_index "sp_bsbs", ["sp_s_1"], :name => "index_sp_bsbs_on_sp_s_1"
  add_index "sp_bsbs", ["sp_s_14"], :name => "index_on_sp_s_14"
  add_index "sp_bsbs", ["sp_s_16"], :name => "index_sp_bsbs_on_sp_s_16"
  add_index "sp_bsbs", ["sp_s_202"], :name => "index_sp_bsbs_on_sp_s_202"
  add_index "sp_bsbs", ["sp_s_214"], :name => "index_on_sp_s_214"
  add_index "sp_bsbs", ["sp_s_3"], :name => "index_sp_bsbs_on_sp_s_3"
  add_index "sp_bsbs", ["sp_s_35"], :name => "index_on_sp_s_35"
  add_index "sp_bsbs", ["sp_s_43"], :name => "index_on_sp_s_43"
  add_index "sp_bsbs", ["sp_s_5"], :name => "index_sp_bsbs_on_sp_s_5"
  add_index "sp_bsbs", ["sp_s_71"], :name => "index_sp_bsbs_on_sp_s_71"
  add_index "sp_bsbs", ["tname"], :name => "index_tname"
  add_index "sp_bsbs", ["updated_at"], :name => "update_desc"

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
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "sp_s_2"
    t.string   "sp_s_17"
    t.string   "sp_s_18"
    t.string   "sp_s_19"
    t.string   "sp_s_20"
    t.integer  "qylx",                     :default => 0
  end

  create_table "sp_hcz_spdata", :force => true do |t|
    t.string   "spdata_0"
    t.string   "spdata_1"
    t.string   "spdata_2"
    t.string   "spdata_3"
    t.string   "spdata_4"
    t.string   "spdata_5"
    t.string   "spdata_6"
    t.string   "spdata_7"
    t.string   "spdata_8"
    t.string   "spdata_9"
    t.string   "spdata_10"
    t.string   "spdata_11"
    t.string   "spdata_12"
    t.string   "spdata_13"
    t.string   "spdata_14"
    t.string   "spdata_15"
    t.string   "spdata_16"
    t.string   "spdata_17"
    t.string   "spdata_18"
    t.integer  "sp_hcz_id"
    t.string   "spdata_2_1"
    t.string   "gjjg"
    t.string   "jgdw"
    t.string   "fjjl"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "wtyp_czb_id"
  end

  create_table "sp_logs", :force => true do |t|
    t.integer  "sp_bsb_id"
    t.integer  "sp_i_state"
    t.string   "remark"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

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
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "spdl"
    t.string   "spyl"
    t.string   "spcyl"
    t.string   "spxl"
    t.string   "sp_s_3"
    t.string   "sp_s_4"
    t.string   "sp_s_5"
    t.integer  "qylx",       :default => 0
  end

  create_table "sp_publications", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "worker_state"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "pub_type",     :default => -1
  end

  create_table "sp_sta", :id => false, :force => true do |t|
    t.string "spdata_0"
    t.string "spdata_4"
    t.string "spdata_5"
    t.string "spdata_6"
    t.string "spdata_8"
    t.string "sp_s_1",                 :default => ""
    t.string "sp_s_14",                :default => ""
    t.string "sp_s_3",                 :default => ""
    t.string "sp_s_68",  :limit => 60
    t.string "sp_s_17",                :default => ""
    t.string "sp_s_20",                :default => ""
    t.string "sp_s_62",  :limit => 60
    t.string "sp_s_16",  :limit => 60
    t.string "sp_s_71",  :limit => 60
    t.string "sp_s_65"
    t.date   "sp_d_86"
  end

  create_table "sp_standards", :force => true do |t|
    t.string   "sp_sta_0"
    t.string   "sp_sta_1"
    t.string   "sp_sta_2"
    t.string   "sp_sta_3"
    t.string   "sp_sta_4"
    t.string   "sp_sta_5"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sp_standards", ["sp_sta_1", "sp_sta_0"], :name => "in_1"

  create_table "sp_statistics", :id => false, :force => true do |t|
    t.string "spdata_0"
    t.string "spdata_4"
    t.string "spdata_5"
    t.string "spdata_6"
    t.string "spdata_8"
    t.string "sp_s_1",                 :default => ""
    t.string "sp_s_14",                :default => ""
    t.string "sp_s_3",                 :default => ""
    t.string "sp_s_68",  :limit => 60
    t.string "sp_s_17",                :default => ""
    t.string "sp_s_20",                :default => ""
    t.string "sp_s_62",  :limit => 60
    t.string "sp_s_16",  :limit => 60
    t.string "sp_s_71",  :limit => 60
    t.string "sp_s_65"
    t.string "sp_sta_5"
    t.date   "sp_d_86"
  end

  create_table "sp_yydjb_logs", :force => true do |t|
    t.integer  "sp_yydjb_id"
    t.text     "cjbh"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "sp_yydjb_state"
  end

  create_table "sp_yydjb_spdata", :force => true do |t|
    t.string   "spdata_0"
    t.string   "spdata_1"
    t.string   "spdata_2"
    t.string   "spdata_3"
    t.string   "spdata_4"
    t.string   "spdata_5"
    t.string   "spdata_6"
    t.string   "spdata_7"
    t.string   "spdata_8"
    t.string   "spdata_9"
    t.integer  "sp_yydjb_id"
    t.string   "spdata_10"
    t.string   "spdata_11"
    t.string   "spdata_12"
    t.string   "spdata_13"
    t.string   "spdata_14"
    t.string   "spdata_15"
    t.string   "spdata_16"
    t.string   "spdata_17"
    t.string   "spdata_18"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "spdata_2_1"
    t.string   "fjjg"
    t.string   "jgdw"
    t.string   "fjjl"
  end

  create_table "sp_yydjbs", :force => true do |t|
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "cjbh",            :limit => 60
    t.string   "ypmc",            :limit => 60
    t.string   "ypgg",            :limit => 60
    t.string   "ypph",            :limit => 60
    t.datetime "scrq"
    t.string   "spdl",            :limit => 60
    t.string   "spyl",            :limit => 60
    t.string   "spcyl",           :limit => 60
    t.string   "spxl",            :limit => 60
    t.string   "jyjl",            :limit => 60
    t.string   "yytcr",           :limit => 60
    t.datetime "yytcsj"
    t.datetime "yysdsj"
    t.string   "yyfl",            :limit => 60
    t.text     "yynr"
    t.string   "yyczbm",          :limit => 60
    t.string   "yyczfzr",         :limit => 60
    t.string   "yyczqk",          :limit => 60
    t.string   "yyczzt",          :limit => 60
    t.string   "yyczjg",                        :default => "异议处置中"
    t.integer  "fjsqqk",                        :default => 0
    t.string   "fjzt",                          :default => "初检结论"
    t.string   "fjsqr",           :limit => 60
    t.datetime "fjsqsj"
    t.datetime "fjslrq"
    t.datetime "fjwcsj"
    t.string   "fjxm",            :limit => 60
    t.string   "fjjg",            :limit => 60
    t.string   "fjjl",            :limit => 60
    t.string   "fjjgou",          :limit => 60
    t.string   "bljg",            :limit => 60
    t.string   "djbm",            :limit => 60
    t.string   "djr",             :limit => 60
    t.datetime "djsj"
    t.string   "blbm",            :limit => 60
    t.string   "blr",             :limit => 60
    t.datetime "blsj"
    t.string   "tbbm",            :limit => 60
    t.string   "tbr",             :limit => 60
    t.datetime "tbsj"
    t.string   "shbm",            :limit => 60
    t.string   "shr",             :limit => 60
    t.datetime "shsj"
    t.string   "bcydw",           :limit => 60
    t.string   "bcydwsf",         :limit => 60
    t.string   "cydw",            :limit => 60
    t.string   "cydwsf",          :limit => 60
    t.string   "bsscqy",          :limit => 60
    t.string   "bsscqysf",        :limit => 60
    t.string   "jyxm",            :limit => 60
    t.string   "jgpd",            :limit => 60
    t.string   "jyjg",            :limit => 60
    t.integer  "current_state"
    t.text     "thyy"
    t.boolean  "dj_delayed",                    :default => false
    t.integer  "sp_bsb_id"
    t.date     "gzscqyrq"
    t.date     "gzbcydwrq"
    t.string   "attachment_path"
    t.string   "attachments"
  end

  create_table "spdata", :force => true do |t|
    t.string   "spdata_0"
    t.string   "spdata_1"
    t.string   "spdata_2"
    t.string   "spdata_3"
    t.string   "spdata_4"
    t.string   "spdata_5"
    t.string   "spdata_6"
    t.string   "spdata_7"
    t.string   "spdata_8"
    t.string   "spdata_9"
    t.integer  "sp_bsb_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "spdata_10"
    t.string   "spdata_11"
    t.string   "spdata_12"
    t.string   "spdata_13"
    t.string   "spdata_14"
    t.string   "spdata_15"
    t.string   "spdata_16"
    t.string   "spdata_17"
    t.string   "spdata_18"
  end

  add_index "spdata", ["sp_bsb_id"], :name => "index_spdata_on_sp_bsb_id"

  create_table "spkj_bsbs", :force => true do |t|
    t.string   "sp_s_1",         :limit => 60
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.string   "sp_s_2",         :limit => 60
    t.string   "sp_s_3",         :limit => 60
    t.string   "sp_s_4",         :limit => 60
    t.string   "sp_s_5",         :limit => 60
    t.string   "sp_s_6",         :limit => 60
    t.string   "sp_s_7",         :limit => 60
    t.string   "sp_s_8",         :limit => 60
    t.string   "sp_s_9",         :limit => 60
    t.string   "sp_s_10",        :limit => 60
    t.string   "sp_s_11",        :limit => 60
    t.string   "sp_s_12",        :limit => 60
    t.string   "sp_s_13",        :limit => 60
    t.string   "sp_s_14",        :limit => 60
    t.decimal  "sp_n_15",                      :precision => 10, :scale => 2
    t.string   "sp_s_16",        :limit => 60
    t.string   "sp_s_17",        :limit => 60
    t.string   "sp_s_18",        :limit => 60
    t.string   "sp_s_19",        :limit => 60
    t.string   "sp_s_20",        :limit => 60
    t.string   "sp_s_21",        :limit => 60
    t.date     "sp_d_22"
    t.string   "sp_s_23",        :limit => 60
    t.string   "sp_s_24",        :limit => 60
    t.string   "sp_s_25",        :limit => 60
    t.string   "sp_s_26",        :limit => 60
    t.string   "sp_s_27",        :limit => 60
    t.date     "sp_d_28"
    t.decimal  "sp_n_29",                      :precision => 10, :scale => 0
    t.string   "sp_s_30",        :limit => 60
    t.decimal  "sp_n_31",                      :precision => 10, :scale => 0
    t.decimal  "sp_n_32",                      :precision => 10, :scale => 0
    t.string   "sp_s_33",        :limit => 60
    t.string   "sp_s_34",        :limit => 60
    t.string   "sp_s_35",        :limit => 60
    t.string   "sp_s_36",        :limit => 60
    t.string   "sp_s_37",        :limit => 60
    t.date     "sp_d_38"
    t.string   "sp_s_39",        :limit => 60
    t.string   "sp_s_40",        :limit => 60
    t.string   "sp_s_41",        :limit => 60
    t.string   "sp_s_42",        :limit => 60
    t.string   "sp_s_43",        :limit => 60
    t.string   "sp_s_44",        :limit => 60
    t.string   "sp_s_45",        :limit => 60
    t.date     "sp_d_46"
    t.date     "sp_d_47"
    t.string   "sp_s_48",        :limit => 60
    t.string   "sp_s_49",        :limit => 60
    t.string   "sp_s_50",        :limit => 60
    t.string   "sp_s_51",        :limit => 60
    t.text     "sp_s_52"
    t.text     "sp_s_53"
    t.text     "sp_s_54"
    t.string   "sp_s_55",        :limit => 60
    t.string   "sp_s_56",        :limit => 60
    t.string   "sp_s_57",        :limit => 60
    t.string   "sp_s_58",        :limit => 60
    t.string   "sp_s_59",        :limit => 60
    t.string   "sp_s_60",        :limit => 60
    t.string   "sp_s_61",        :limit => 60
    t.string   "sp_s_62",        :limit => 60
    t.string   "sp_s_63",        :limit => 60
    t.string   "sp_s_64",        :limit => 60
    t.string   "sp_s_65",        :limit => 60
    t.string   "sp_s_66",        :limit => 60
    t.string   "sp_s_67",        :limit => 60
    t.string   "sp_s_68",        :limit => 60
    t.string   "sp_s_69",        :limit => 60
    t.string   "sp_s_70",        :limit => 60
    t.string   "sp_s_71",        :limit => 60
    t.string   "sp_s_72",        :limit => 60
    t.string   "sp_s_73",        :limit => 60
    t.string   "sp_s_74",        :limit => 60
    t.string   "sp_s_75",        :limit => 60
    t.string   "sp_s_76",        :limit => 60
    t.string   "sp_s_77",        :limit => 60
    t.string   "sp_s_78",        :limit => 60
    t.string   "sp_s_79",        :limit => 60
    t.string   "sp_s_80",        :limit => 60
    t.string   "sp_s_81",        :limit => 60
    t.string   "sp_s_82",        :limit => 60
    t.string   "sp_s_83",        :limit => 60
    t.string   "sp_s_84",        :limit => 60
    t.string   "sp_s_85",        :limit => 60
    t.date     "sp_d_86"
    t.string   "sp_s_87",        :limit => 60
    t.string   "sp_s_88",        :limit => 60
    t.string   "tname",          :limit => 60
    t.date     "submit_d_flag"
    t.decimal  "sp_n_jcxcount",                :precision => 10, :scale => 0
    t.string   "sp_s_bsfl",      :limit => 16
    t.string   "sp_s_2_1",       :limit => 16
    t.string   "sp_s_18_1",      :limit => 16
    t.string   "sp_s_30_1",      :limit => 16
    t.string   "sp_s_33_1",      :limit => 16
    t.string   "sp_s_140_1",     :limit => 16
    t.text     "sp_s_140_2"
    t.text     "sp_s_140_3"
    t.string   "sp_s_140_4",     :limit => 16
    t.string   "sp_s_140_5",     :limit => 16
    t.string   "sp_s_140_6",     :limit => 16
    t.string   "sp_s_140_7",     :limit => 16
    t.string   "sp_s_140_8",     :limit => 16
    t.string   "sp_s_140_9",     :limit => 16
    t.text     "sp_s_140_0"
    t.integer  "sp_i_state"
    t.text     "sp_s_141_0"
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
  end

  create_table "sys_provinces", :force => true do |t|
    t.string   "name"
    t.string   "note"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "code"
    t.string   "level",      :limit => 20
  end

  create_table "task_jg_bsbs", :force => true do |t|
    t.integer  "a_category_id"
    t.integer  "jg_bsb_id"
    t.string   "note"
    t.integer  "quota"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "sys_province_id"
    t.integer  "b_category_id"
    t.integer  "c_category_id"
    t.integer  "d_category_id"
    t.string   "identifier"
    t.string   "a_category_name"
    t.string   "b_category_name"
    t.string   "c_category_name"
    t.string   "d_category_name"
  end

  create_table "task_provinces", :force => true do |t|
    t.integer  "sys_province_id"
    t.integer  "a_category_id"
    t.integer  "quota"
    t.string   "year"
    t.string   "note"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "b_category_id"
    t.integer  "c_category_id"
    t.integer  "d_category_id"
    t.string   "identifier"
    t.string   "a_category_name"
    t.string   "b_category_name"
    t.string   "c_category_name"
    t.string   "d_category_name"
  end

  create_table "user_locations", :force => true do |t|
    t.string   "device_uuid"
    t.string   "gps"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.string   "tname",                  :limit => 30
    t.string   "tel"
    t.string   "eaddress"
    t.string   "company"
    t.string   "user_s_province",        :limit => 32
    t.integer  "user_d_authority"
    t.integer  "user_d_authority_1"
    t.string   "user_jcjg"
    t.string   "user_jcjg_lxr"
    t.string   "user_jcjg_tel"
    t.string   "user_jcjg_mail"
    t.string   "user_cyjg"
    t.string   "user_cyjg_lxr"
    t.string   "user_cyjg_tel"
    t.string   "user_cyjg_mail"
    t.integer  "user_i_js"
    t.integer  "user_i_switch"
    t.integer  "user_i_sp"
    t.integer  "user_i_bjp"
    t.integer  "user_i_hzp"
    t.integer  "user_d_authority_2"
    t.integer  "user_d_authority_3"
    t.integer  "user_d_authority_4"
    t.integer  "user_d_authority_5"
    t.string   "user_s_dl"
    t.integer  "user_i_spys"
    t.integer  "user_i_spss"
    t.integer  "yycz_permission",                      :default => 0
    t.integer  "hcz_permission",                       :default => 0
    t.integer  "enable_api",                           :default => 0
    t.integer  "pad_permission",                       :default => 0
    t.string   "device_uuid",            :limit => 40
    t.string   "car_sys_id"
    t.string   "user_s_city"
    t.string   "user_s_lcity"
    t.integer  "publication_permission",               :default => 0
    t.string   "id_card"
    t.text     "user_sign"
    t.integer  "jg_bsb_id"
  end

  add_index "users", ["name"], :name => "index_name"

  create_table "welcome_notices", :force => true do |t|
    t.string   "title"
    t.integer  "red"
    t.integer  "top"
    t.string   "attachment_path"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "url"
  end

  create_table "wtyp_czb_part_logs", :force => true do |t|
    t.integer  "user_id"
    t.string   "content"
    t.integer  "wtyp_czb_part_id"
    t.integer  "wtyp_czb_state"
    t.integer  "wtyp_czb_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "sp_bsb_id"
  end

  create_table "wtyp_czb_parts", :force => true do |t|
    t.integer  "wtyp_czb_id"
    t.string   "wtyp_jg"
    t.string   "wtyp_contacts"
    t.string   "wtyp_tel"
    t.string   "wtyp_fax"
    t.string   "wtyp_email"
    t.string   "wtyp_verify"
    t.string   "wtyp_state"
    t.date     "wtyp_date"
    t.text     "wtyp_deal_way"
    t.text     "wtyp_deal_detail"
    t.string   "wtyp_deal_jg"
    t.text     "wtyp_remark"
    t.integer  "sp_bsb_id"
    t.string   "wtyp_no"
    t.string   "wtyp_fjstate"
    t.string   "wtyp_deal_segment"
    t.string   "wtyp_deal_affirm"
    t.text     "wtyp_deal_site"
    t.text     "wtyp_deal_result"
    t.string   "wtyp_deal_fix1way"
    t.string   "wtyp_deal_fix2way"
    t.string   "wtyp_deal_fix3way"
    t.string   "wtyp_result_fix1way"
    t.string   "wtyp_result_fix2way"
    t.string   "wtyp_result_fix3way"
    t.string   "wtyp_result_fix4way"
    t.string   "wtyp_result_fix5way"
    t.string   "wtyp_result_fix6way"
    t.string   "wtyp_result_fix7way"
    t.string   "wtyp_result_fix8way"
    t.string   "bgsbh",               :limit => 60
    t.string   "cydd",                :limit => 60
    t.string   "bgfl",                :limit => 60
    t.string   "bcydwdz",             :limit => 150
    t.string   "bcydw_sheng",         :limit => 60
    t.text     "bsscqydz"
    t.string   "cyjs",                :limit => 60
    t.string   "bsscqy_sheng",        :limit => 60
    t.string   "jymd",                :limit => 60
    t.string   "bsscqy_xian",         :limit => 60
    t.string   "yyzt",                :limit => 60
    t.string   "yyfl",                :limit => 60
    t.string   "yyczjg",              :limit => 60
    t.string   "fjzt",                :limit => 60
    t.string   "fjsqr",               :limit => 60
    t.datetime "fjsqsj"
    t.datetime "fjslrq"
    t.datetime "fjwcsj"
    t.string   "fjxm",                :limit => 60
    t.string   "fjjg",                :limit => 60
    t.string   "fjjl",                :limit => 60
    t.string   "fjjgou",              :limit => 60
    t.string   "czbm",                :limit => 60
    t.string   "czfzr",               :limit => 60
    t.string   "hcczzt",              :limit => 60
    t.string   "blzt",                :limit => 60
    t.string   "bljg",                :limit => 60
    t.string   "blbm",                :limit => 60
    t.string   "blr",                 :limit => 60
    t.datetime "blsj"
    t.string   "tbbm",                :limit => 60
    t.string   "tbr",                 :limit => 60
    t.datetime "tbsj"
    t.string   "shbm",                :limit => 60
    t.string   "shr",                 :limit => 60
    t.datetime "shsj"
    t.integer  "current_state",                      :default => -1
    t.integer  "czb_type",                           :default => -1
    t.string   "cjbh",                :limit => 60
    t.string   "ypmc",                :limit => 60
    t.string   "ypgg",                :limit => 60
    t.string   "ypph",                :limit => 60
    t.string   "jyjl",                :limit => 60
    t.string   "bcydwmc",             :limit => 60
    t.string   "cydwmc",              :limit => 60
    t.string   "cydwsf",              :limit => 60
    t.string   "bsscqymc",            :limit => 60
    t.datetime "scrq"
    t.string   "yytcr",               :limit => 60
    t.datetime "yytcsj"
    t.datetime "yysdsj"
    t.string   "yynr",                :limit => 60
    t.string   "djbm",                :limit => 60
    t.string   "djr",                 :limit => 60
    t.datetime "djsj"
    t.string   "fjsqzk",              :limit => 60
    t.string   "yyczqk",              :limit => 60
    t.text     "thyy"
    t.string   "jyjgzt"
    t.date     "qdhcczrq"
    t.date     "czwbrq"
    t.string   "fxpj_1"
    t.string   "fxpj_2"
    t.string   "fxpj_3"
    t.string   "cpkzqk_1"
    t.string   "cpkzqk_2"
    t.string   "cpkzqk_3"
    t.string   "cpkzqk_4"
    t.string   "cpkzqk_5"
    t.string   "cpkzqk_6"
    t.string   "cpkzqk_7"
    t.string   "cpkzqk_8"
    t.string   "cpkzqk_9"
    t.string   "cpkzqk_10"
    t.string   "cpkzqk_11"
    t.string   "cpkzqk_12"
    t.string   "cpkzqk_13"
    t.string   "cpkzqk_14"
    t.string   "cpkzqk_15"
    t.string   "cpkzqk_16"
    t.string   "cpkzqk_17"
    t.string   "cpkzqk_18"
    t.string   "cpkzqk_19"
    t.string   "pczgfc_1"
    t.integer  "pczgfc_2",                           :default => 0
    t.string   "pczgfc_3"
    t.date     "pczgfc_4"
    t.date     "pczgfc_5"
    t.text     "pczgfc_6"
    t.string   "pczgfc_7"
    t.string   "pczgfc_8"
    t.text     "xzcfqk_1"
    t.text     "xzcfqk_2"
    t.text     "xzcfqk_3"
    t.text     "xzcfqk_4"
    t.text     "xzcfqk_5"
    t.date     "xzcfqk_6"
    t.text     "xzcfqk_7"
    t.date     "xzcfqk_8"
    t.text     "xzcfqk_9"
    t.text     "xzcfqk_10"
    t.text     "xzcfqk_11"
    t.text     "xzcfqk_12"
    t.text     "xzcfqk_13"
    t.text     "xzcfqk_14"
    t.text     "xzcfqk_15"
    t.text     "xzcfqk_16"
    t.text     "xzcfqk_17"
    t.text     "xzcfqk_18"
    t.text     "xzcfqk_19"
    t.text     "xzcfqk_20"
    t.date     "xzcfqk_21"
    t.integer  "hccz_type",                          :default => -1
    t.text     "pczgfc_9"
    t.boolean  "part_submit_flag1",                  :default => false
    t.boolean  "part_submit_flag2",                  :default => false
    t.boolean  "part_submit_flag3",                  :default => false
    t.boolean  "part_submit_flag4",                  :default => false
    t.integer  "wtyp_czb_type",                      :default => 0
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.text     "pczgfc_10"
    t.date     "fxpj_4"
    t.integer  "pczgfc_17"
    t.integer  "pczgfc_11"
    t.integer  "pczgfc_12"
    t.integer  "pczgfc_13"
    t.integer  "pczgfc_14"
    t.integer  "pczgfc_15"
    t.integer  "pczgfc_16"
    t.string   "cpkzqk_20"
    t.string   "cpkzqk_21"
    t.string   "cpkzqk_22"
    t.string   "cpkzqk_23"
    t.string   "current_state_desc"
  end

  add_index "wtyp_czb_parts", ["cjbh"], :name => "index_wtyp_czb_parts_on_cjbh"

  create_table "wtyp_czbs", :force => true do |t|
    t.string   "wtyp_jg"
    t.string   "wtyp_contacts"
    t.string   "wtyp_tel"
    t.string   "wtyp_fax"
    t.string   "wtyp_email"
    t.string   "wtyp_verify"
    t.string   "wtyp_state"
    t.date     "wtyp_date"
    t.text     "wtyp_deal_way"
    t.text     "wtyp_deal_detail"
    t.string   "wtyp_deal_jg"
    t.text     "wtyp_remark"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "wtyp_sp_bsbs_id"
    t.string   "wtyp_no"
    t.string   "wtyp_state_sc"
    t.date     "wtyp_date_sc"
    t.string   "wtyp_fjstate"
    t.string   "wtyp_jg_sc"
    t.string   "wtyp_contacts_sc"
    t.string   "wtyp_tel_sc"
    t.string   "wtyp_fax_sc"
    t.string   "wtyp_email_sc"
    t.string   "wtyp_verify_sc"
    t.string   "wtyp_deal_segment"
    t.string   "wtyp_deal_segment_sc"
    t.string   "wtyp_deal_affirm"
    t.string   "wtyp_deal_affirm_sc"
    t.text     "wtyp_deal_site"
    t.text     "wtyp_deal_result"
    t.text     "wtyp_deal_way_sc"
    t.text     "wtyp_deal_detail_sc"
    t.string   "wtyp_deal_fix1way"
    t.string   "wtyp_deal_fix1way_sc"
    t.string   "wtyp_deal_fix2way"
    t.string   "wtyp_deal_fix2way_sc"
    t.string   "wtyp_deal_fix3way"
    t.string   "wtyp_deal_fix3way_sc"
    t.string   "wtyp_result_fix1way"
    t.string   "wtyp_result_fix1way_sc"
    t.string   "wtyp_result_fix2way"
    t.string   "wtyp_result_fix2way_sc"
    t.string   "wtyp_result_fix3way"
    t.string   "wtyp_result_fix3way_sc"
    t.string   "wtyp_result_fix4way"
    t.string   "wtyp_result_fix4way_sc"
    t.string   "wtyp_result_fix5way"
    t.string   "wtyp_result_fix5way_sc"
    t.string   "wtyp_result_fix6way"
    t.string   "wtyp_result_fix6way_sc"
    t.string   "wtyp_result_fix7way"
    t.string   "wtyp_result_fix7way_sc"
    t.string   "wtyp_result_fix8way"
    t.string   "wtyp_result_fix8way_sc"
    t.text     "wtyp_deal_site_sc"
    t.string   "bgsbh",                  :limit => 60
    t.string   "cydd",                   :limit => 60
    t.string   "bgfl",                   :limit => 60
    t.string   "bcydwdz",                :limit => 150
    t.string   "bcydw_sheng",            :limit => 60
    t.string   "bsscqydz",               :limit => 150
    t.string   "cyjs",                   :limit => 60
    t.string   "bsscqy_sheng",           :limit => 60
    t.string   "jymd",                   :limit => 60
    t.string   "bsscqy_xian",            :limit => 60
    t.string   "yyzt",                   :limit => 60
    t.string   "yyfl",                   :limit => 60
    t.string   "yyczjg",                 :limit => 60
    t.string   "fjzt",                   :limit => 60
    t.string   "fjsqr",                  :limit => 60
    t.datetime "fjsqsj"
    t.datetime "fjslrq"
    t.datetime "fjwcsj"
    t.string   "fjxm",                   :limit => 60
    t.string   "fjjg",                   :limit => 60
    t.string   "fjjl",                   :limit => 60
    t.string   "fjjgou",                 :limit => 60
    t.string   "czbm",                   :limit => 60
    t.string   "czfzr",                  :limit => 60
    t.string   "hcczzt",                 :limit => 60
    t.string   "blzt",                   :limit => 60
    t.string   "bljg",                   :limit => 60
    t.string   "blbm",                   :limit => 60
    t.string   "blr",                    :limit => 60
    t.datetime "blsj"
    t.string   "tbbm",                   :limit => 60
    t.string   "tbr",                    :limit => 60
    t.datetime "tbsj"
    t.string   "shbm",                   :limit => 60
    t.string   "shr",                    :limit => 60
    t.datetime "shsj"
    t.string   "cjbh",                   :limit => 60
    t.string   "ypmc",                   :limit => 60
    t.string   "ypgg",                   :limit => 60
    t.string   "ypph",                   :limit => 60
    t.string   "jyjl",                   :limit => 60
    t.string   "bcydwmc",                :limit => 60
    t.string   "cydwmc",                 :limit => 60
    t.string   "cydwsf",                 :limit => 60
    t.string   "bsscqymc",               :limit => 60
    t.datetime "scrq"
  end

  add_index "wtyp_czbs", ["wtyp_sp_bsbs_id"], :name => "index_sp_bsbs_id"

  create_table "xsbg_tt_data", :force => true do |t|
    t.integer  "xsbg_tt_id"
    t.integer  "sp_bsb_id"
    t.string   "CJBH"
    t.string   "spdata_0"
    t.string   "spdata_1"
    t.string   "spdata_2"
    t.string   "spdata_3"
    t.string   "spdata_4"
    t.string   "spdata_5"
    t.string   "spdata_6"
    t.string   "spdata_7"
    t.string   "spdata_8"
    t.string   "spdata_9"
    t.string   "spdata_10"
    t.string   "spdata_11"
    t.string   "spdata_12"
    t.string   "spdata_13"
    t.string   "spdata_14"
    t.string   "spdata_15"
    t.string   "spdata_16"
    t.string   "spdata_17"
    t.string   "spdata_18"
    t.integer  "spdata_id",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "xsbg_tts", :force => true do |t|
    t.string   "GJMC"
    t.string   "CJBH"
    t.integer  "sp_bsb_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
