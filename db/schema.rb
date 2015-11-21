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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151121020804) do

  create_table "a_categories", force: :cascade do |t|
    t.integer  "bgfl_id",    limit: 4
    t.string   "name",       limit: 255
    t.string   "note",       limit: 255
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "identifier", limit: 255
    t.boolean  "enable",                 default: true
  end

  create_table "a_categories_provinces", force: :cascade do |t|
    t.integer  "sys_province_id", limit: 4
    t.integer  "a_category_id",   limit: 4
    t.integer  "quota",           limit: 4
    t.string   "year",            limit: 255
    t.string   "note",            limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "b_category_id",   limit: 4
    t.integer  "c_category_id",   limit: 4
    t.integer  "d_category_id",   limit: 4
    t.string   "identifier",      limit: 255
  end

  create_table "a_category_jg_bsbs", force: :cascade do |t|
    t.integer  "a_category_id",   limit: 4
    t.integer  "jg_bsb_id",       limit: 4
    t.string   "note",            limit: 255
    t.integer  "quota",           limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "sys_province_id", limit: 4
    t.integer  "b_category_id",   limit: 4
    t.integer  "c_category_id",   limit: 4
    t.integer  "d_category_id",   limit: 4
    t.string   "identifier",      limit: 255
  end

  create_table "a_category_testers", force: :cascade do |t|
    t.integer  "a_category_id", limit: 4
    t.integer  "tester_id",     limit: 4
    t.string   "note",          limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "attachments", force: :cascade do |t|
    t.string   "filename",     limit: 255
    t.string   "path",         limit: 255
    t.string   "content_type", limit: 255
    t.string   "md5",          limit: 255
    t.integer  "user_id",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "b_categories", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "a_category_id", limit: 4
    t.string   "note",          limit: 255
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "identifier",    limit: 255
    t.boolean  "enable",                    default: true
  end

  create_table "baosong_as", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "note",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "prov",       limit: 255
    t.string   "rwlylx",     limit: 255
  end

  create_table "baosong_bs", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "note",         limit: 255
    t.integer  "baosong_a_id", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "identifier",   limit: 255
    t.string   "prov",         limit: 255
  end

  create_table "baosong_mofify_logs", force: :cascade do |t|
    t.integer  "baosong_a_id", limit: 4
    t.integer  "baosong_b_id", limit: 4
    t.string   "identifier",   limit: 255
    t.text     "msg",          limit: 65535
    t.integer  "user_id",      limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "bjp_bsbs", force: :cascade do |t|
    t.string   "bjp_s_1",        limit: 60
    t.string   "bjp_s_2",        limit: 60
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "bjp_s_6",        limit: 100
    t.string   "bjp_s_7",        limit: 60
    t.string   "bjp_s_8",        limit: 60
    t.string   "bjp_s_9",        limit: 60
    t.string   "bjp_s_10",       limit: 60
    t.string   "bjp_s_11",       limit: 60
    t.string   "bjp_s_12",       limit: 60
    t.string   "bjp_s_13",       limit: 60
    t.string   "bjp_s_14",       limit: 60
    t.string   "bjp_s_15",       limit: 30
    t.string   "bjp_s_16",       limit: 30
    t.string   "bjp_s_17",       limit: 30
    t.string   "bjp_s_18",       limit: 30
    t.string   "bjp_s_19",       limit: 30
    t.string   "bjp_s_20",       limit: 30
    t.string   "bjp_s_22",       limit: 30
    t.date     "bjp_d_21"
    t.string   "bjp_s_3",        limit: 60
    t.string   "bjp_s_4",        limit: 60
    t.string   "bjp_s_5",        limit: 60
    t.string   "bjp_s_23",       limit: 30
    t.decimal  "bjp_n_24",                   precision: 10
    t.string   "bjp_s_25",       limit: 30
    t.decimal  "bjp_n_26",                   precision: 10
    t.string   "bjp_s_27",       limit: 30
    t.string   "bjp_s_28",       limit: 60
    t.string   "bjp_s_29",       limit: 60
    t.string   "bjp_s_30",       limit: 60
    t.string   "bjp_s_31",       limit: 60
    t.string   "bjp_s_32",       limit: 30
    t.string   "bjp_s_33",       limit: 30
    t.date     "bjp_d_34"
    t.string   "bjp_s_35",       limit: 30
    t.string   "bjp_s_36",       limit: 30
    t.string   "bjp_s_37",       limit: 255
    t.string   "bjp_s_38",       limit: 30
    t.string   "bjp_s_39",       limit: 255
    t.string   "bjp_s_40",       limit: 255
    t.string   "bjp_s_41",       limit: 255
    t.date     "bjp_d_42"
    t.date     "bjp_d_43"
    t.string   "bjp_s_44",       limit: 60
    t.string   "bjp_s_45",       limit: 60
    t.string   "bjp_s_46",       limit: 60
    t.string   "bjp_s_47",       limit: 60
    t.string   "bjp_s_48",       limit: 60
    t.string   "bjp_s_49",       limit: 60
    t.string   "bjp_s_50",       limit: 60
    t.string   "bjp_s_51",       limit: 60
    t.string   "bjp_s_52",       limit: 60
    t.string   "bjp_s_53",       limit: 60
    t.string   "bjp_s_54",       limit: 60
    t.string   "bjp_s_55",       limit: 60
    t.string   "bjp_s_56",       limit: 60
    t.string   "bjp_s_57",       limit: 60
    t.string   "bjp_s_58",       limit: 60
    t.string   "bjp_s_59",       limit: 60
    t.string   "bjp_s_60",       limit: 60
    t.string   "bjp_s_61",       limit: 60
    t.string   "bjp_s_62",       limit: 60
    t.string   "bjp_s_63",       limit: 60
    t.string   "bjp_s_64",       limit: 60
    t.string   "bjp_s_65",       limit: 255
    t.string   "bjp_s_66",       limit: 255
    t.string   "bjp_s_67",       limit: 255
    t.string   "bjp_s_68",       limit: 255
    t.string   "bjp_s_69",       limit: 255
    t.string   "bjp_s_70",       limit: 255
    t.string   "bjp_s_71",       limit: 255
    t.string   "bjp_s_72",       limit: 255
    t.string   "bjp_s_73",       limit: 255
    t.string   "bjp_s_74",       limit: 255
    t.string   "bjp_s_75",       limit: 255
    t.string   "bjp_s_76",       limit: 255
    t.string   "bjp_s_77",       limit: 255
    t.string   "bjp_s_78",       limit: 255
    t.string   "bjp_s_79",       limit: 255
    t.string   "bjp_s_80",       limit: 255
    t.string   "bjp_s_81",       limit: 255
    t.string   "bjp_s_82",       limit: 255
    t.string   "bjp_s_83",       limit: 255
    t.string   "bjp_s_84",       limit: 255
    t.string   "bjp_s_85",       limit: 255
    t.string   "bjp_s_87",       limit: 255
    t.string   "bjp_s_88",       limit: 255
    t.string   "bjp_s_86",       limit: 255
    t.string   "bjp_s_89",       limit: 255
    t.string   "bjp_s_90",       limit: 255
    t.string   "bjp_s_91",       limit: 255
    t.string   "bjp_s_92",       limit: 255
    t.string   "bjp_s_93",       limit: 255
    t.string   "bjp_s_94",       limit: 255
    t.date     "bjp_d_95"
    t.string   "bjp_s_96",       limit: 255
    t.string   "bjp_s_97",       limit: 255
    t.string   "tname",          limit: 60
    t.datetime "submit_d_flag"
    t.decimal  "bjp_n_jcxcount",             precision: 10
    t.string   "bjp_s_bsfl",     limit: 16
    t.string   "bjp_s_2_1",      limit: 16
    t.string   "bjp_s_40_1",     limit: 16
    t.string   "bjp_s_110_1",    limit: 16
    t.string   "bjp_s_110_2",    limit: 16
    t.string   "bjp_s_110_3",    limit: 16
    t.string   "bjp_s_110_4",    limit: 16
    t.string   "bjp_s_110_5",    limit: 16
    t.string   "bjp_s_110_6",    limit: 16
    t.string   "bjp_s_110_7",    limit: 16
    t.string   "bjp_s_110_8",    limit: 16
    t.string   "bjp_s_111_1",    limit: 16
    t.string   "bjp_s_111_2",    limit: 16
    t.string   "bjp_s_111_3",    limit: 16
    t.string   "bjp_s_111_4",    limit: 16
    t.string   "bjp_s_111_5",    limit: 16
    t.string   "bjp_s_111_6",    limit: 16
    t.string   "bjp_s_111_7",    limit: 16
    t.string   "bjp_s_111_8",    limit: 16
    t.string   "bjp_s_112_1",    limit: 16
    t.string   "bjp_s_112_2",    limit: 16
    t.string   "bjp_s_112_3",    limit: 16
    t.string   "bjp_s_112_4",    limit: 16
    t.string   "bjp_s_112_5",    limit: 16
    t.string   "bjp_s_112_6",    limit: 16
    t.string   "bjp_s_112_7",    limit: 16
    t.string   "bjp_s_112_8",    limit: 16
    t.string   "bjp_s_113_1",    limit: 16
    t.string   "bjp_s_113_2",    limit: 16
    t.string   "bjp_s_113_3",    limit: 16
    t.string   "bjp_s_113_4",    limit: 16
    t.string   "bjp_s_113_5",    limit: 16
    t.string   "bjp_s_113_6",    limit: 16
    t.string   "bjp_s_113_7",    limit: 16
    t.string   "bjp_s_113_8",    limit: 16
    t.string   "bjp_s_114_1",    limit: 16
    t.string   "bjp_s_114_2",    limit: 16
    t.string   "bjp_s_114_3",    limit: 16
    t.string   "bjp_s_114_4",    limit: 16
    t.string   "bjp_s_114_5",    limit: 16
    t.string   "bjp_s_114_6",    limit: 16
    t.string   "bjp_s_114_7",    limit: 16
    t.string   "bjp_s_114_8",    limit: 16
    t.string   "bjp_s_115_1",    limit: 16
    t.string   "bjp_s_115_2",    limit: 16
    t.string   "bjp_s_115_3",    limit: 16
    t.string   "bjp_s_115_4",    limit: 16
    t.string   "bjp_s_115_5",    limit: 16
    t.string   "bjp_s_115_6",    limit: 16
    t.string   "bjp_s_115_7",    limit: 16
    t.string   "bjp_s_115_8",    limit: 16
    t.string   "bjp_s_116_1",    limit: 16
    t.string   "bjp_s_116_2",    limit: 16
    t.string   "bjp_s_116_3",    limit: 16
    t.string   "bjp_s_116_4",    limit: 16
    t.string   "bjp_s_116_5",    limit: 16
    t.string   "bjp_s_116_6",    limit: 16
    t.string   "bjp_s_116_7",    limit: 16
    t.string   "bjp_s_116_8",    limit: 16
    t.string   "bjp_s_117_1",    limit: 16
    t.string   "bjp_s_117_2",    limit: 16
    t.string   "bjp_s_117_3",    limit: 16
    t.string   "bjp_s_117_4",    limit: 16
    t.string   "bjp_s_117_5",    limit: 16
    t.string   "bjp_s_117_6",    limit: 16
    t.string   "bjp_s_117_7",    limit: 16
    t.string   "bjp_s_117_8",    limit: 16
    t.string   "bjp_s_118_1",    limit: 16
    t.string   "bjp_s_118_2",    limit: 16
    t.string   "bjp_s_118_3",    limit: 16
    t.string   "bjp_s_118_4",    limit: 16
    t.string   "bjp_s_118_5",    limit: 16
    t.string   "bjp_s_118_6",    limit: 16
    t.string   "bjp_s_118_7",    limit: 16
    t.string   "bjp_s_118_8",    limit: 16
    t.string   "bjp_s_119_1",    limit: 16
    t.string   "bjp_s_119_2",    limit: 16
    t.string   "bjp_s_119_3",    limit: 16
    t.string   "bjp_s_119_4",    limit: 16
    t.string   "bjp_s_119_5",    limit: 16
    t.string   "bjp_s_119_6",    limit: 16
    t.string   "bjp_s_119_7",    limit: 16
    t.string   "bjp_s_119_8",    limit: 16
    t.string   "bjp_s_120_1",    limit: 16
    t.string   "bjp_s_120_2",    limit: 16
    t.string   "bjp_s_120_3",    limit: 16
    t.string   "bjp_s_120_4",    limit: 16
    t.string   "bjp_s_120_5",    limit: 16
    t.string   "bjp_s_120_6",    limit: 16
    t.string   "bjp_s_120_7",    limit: 16
    t.string   "bjp_s_120_8",    limit: 16
    t.string   "bjp_s_121_1",    limit: 16
    t.string   "bjp_s_121_2",    limit: 16
    t.string   "bjp_s_121_3",    limit: 16
    t.string   "bjp_s_121_4",    limit: 16
    t.string   "bjp_s_121_5",    limit: 16
    t.string   "bjp_s_121_6",    limit: 16
    t.string   "bjp_s_121_7",    limit: 16
    t.string   "bjp_s_121_8",    limit: 16
    t.string   "bjp_s_122_1",    limit: 16
    t.string   "bjp_s_122_2",    limit: 16
    t.string   "bjp_s_122_3",    limit: 16
    t.string   "bjp_s_122_4",    limit: 16
    t.string   "bjp_s_122_5",    limit: 16
    t.string   "bjp_s_122_6",    limit: 16
    t.string   "bjp_s_122_7",    limit: 16
    t.string   "bjp_s_122_8",    limit: 16
    t.string   "bjp_s_123_1",    limit: 16
    t.string   "bjp_s_123_2",    limit: 16
    t.string   "bjp_s_123_3",    limit: 16
    t.string   "bjp_s_123_4",    limit: 16
    t.string   "bjp_s_123_5",    limit: 16
    t.string   "bjp_s_123_6",    limit: 16
    t.string   "bjp_s_123_7",    limit: 16
    t.string   "bjp_s_123_8",    limit: 16
    t.string   "bjp_s_124_1",    limit: 16
    t.string   "bjp_s_124_2",    limit: 16
    t.string   "bjp_s_124_3",    limit: 16
    t.string   "bjp_s_124_4",    limit: 16
    t.string   "bjp_s_124_5",    limit: 16
    t.string   "bjp_s_124_6",    limit: 16
    t.string   "bjp_s_124_7",    limit: 16
    t.string   "bjp_s_124_8",    limit: 16
    t.string   "bjp_s_125_1",    limit: 16
    t.string   "bjp_s_125_2",    limit: 16
    t.string   "bjp_s_125_3",    limit: 16
    t.string   "bjp_s_125_4",    limit: 16
    t.string   "bjp_s_125_5",    limit: 16
    t.string   "bjp_s_125_6",    limit: 16
    t.string   "bjp_s_125_7",    limit: 16
    t.string   "bjp_s_125_8",    limit: 16
    t.string   "bjp_s_126_1",    limit: 16
    t.string   "bjp_s_126_2",    limit: 16
    t.string   "bjp_s_126_3",    limit: 16
    t.string   "bjp_s_126_4",    limit: 16
    t.string   "bjp_s_126_5",    limit: 16
    t.string   "bjp_s_126_6",    limit: 16
    t.string   "bjp_s_126_7",    limit: 16
    t.string   "bjp_s_126_8",    limit: 16
    t.string   "bjp_s_127_1",    limit: 16
    t.string   "bjp_s_127_2",    limit: 16
    t.string   "bjp_s_127_3",    limit: 16
    t.string   "bjp_s_127_4",    limit: 16
    t.string   "bjp_s_127_5",    limit: 16
    t.string   "bjp_s_127_6",    limit: 16
    t.string   "bjp_s_127_7",    limit: 16
    t.string   "bjp_s_127_8",    limit: 16
    t.string   "bjp_s_128_1",    limit: 16
    t.string   "bjp_s_128_2",    limit: 16
    t.string   "bjp_s_128_3",    limit: 16
    t.string   "bjp_s_128_4",    limit: 16
    t.string   "bjp_s_128_5",    limit: 16
    t.string   "bjp_s_128_6",    limit: 16
    t.string   "bjp_s_128_7",    limit: 16
    t.string   "bjp_s_128_8",    limit: 16
    t.string   "bjp_s_129_1",    limit: 16
    t.string   "bjp_s_129_2",    limit: 16
    t.string   "bjp_s_129_3",    limit: 16
    t.string   "bjp_s_129_4",    limit: 16
    t.string   "bjp_s_129_5",    limit: 16
    t.string   "bjp_s_129_6",    limit: 16
    t.string   "bjp_s_129_7",    limit: 16
    t.string   "bjp_s_129_8",    limit: 16
    t.string   "bjp_s_130_1",    limit: 16
    t.string   "bjp_s_130_2",    limit: 16
    t.string   "bjp_s_130_3",    limit: 16
    t.string   "bjp_s_130_4",    limit: 16
    t.string   "bjp_s_130_5",    limit: 16
    t.string   "bjp_s_130_6",    limit: 16
    t.string   "bjp_s_130_7",    limit: 16
    t.string   "bjp_s_130_8",    limit: 16
    t.string   "bjp_s_131_1",    limit: 16
    t.string   "bjp_s_131_2",    limit: 16
    t.string   "bjp_s_131_3",    limit: 16
    t.string   "bjp_s_131_4",    limit: 16
    t.string   "bjp_s_131_5",    limit: 16
    t.string   "bjp_s_131_6",    limit: 16
    t.string   "bjp_s_131_7",    limit: 16
    t.string   "bjp_s_131_8",    limit: 16
    t.string   "bjp_s_132_1",    limit: 16
    t.string   "bjp_s_132_2",    limit: 16
    t.string   "bjp_s_132_3",    limit: 16
    t.string   "bjp_s_132_4",    limit: 16
    t.string   "bjp_s_132_5",    limit: 16
    t.string   "bjp_s_132_6",    limit: 16
    t.string   "bjp_s_132_7",    limit: 16
    t.string   "bjp_s_132_8",    limit: 16
    t.string   "bjp_s_133_1",    limit: 16
    t.string   "bjp_s_133_2",    limit: 16
    t.string   "bjp_s_133_3",    limit: 16
    t.string   "bjp_s_133_4",    limit: 16
    t.string   "bjp_s_133_5",    limit: 16
    t.string   "bjp_s_133_6",    limit: 16
    t.string   "bjp_s_133_7",    limit: 16
    t.string   "bjp_s_133_8",    limit: 16
    t.string   "bjp_s_134_1",    limit: 16
    t.string   "bjp_s_134_2",    limit: 16
    t.string   "bjp_s_134_3",    limit: 16
    t.string   "bjp_s_134_4",    limit: 16
    t.string   "bjp_s_134_5",    limit: 16
    t.string   "bjp_s_134_6",    limit: 16
    t.string   "bjp_s_134_7",    limit: 16
    t.string   "bjp_s_134_8",    limit: 16
    t.string   "bjp_s_135_1",    limit: 16
    t.string   "bjp_s_135_2",    limit: 16
    t.string   "bjp_s_135_3",    limit: 16
    t.string   "bjp_s_135_4",    limit: 16
    t.string   "bjp_s_135_5",    limit: 16
    t.string   "bjp_s_135_6",    limit: 16
    t.string   "bjp_s_135_7",    limit: 16
    t.string   "bjp_s_135_8",    limit: 16
    t.string   "bjp_s_136_1",    limit: 16
    t.string   "bjp_s_136_2",    limit: 16
    t.string   "bjp_s_136_3",    limit: 16
    t.string   "bjp_s_136_4",    limit: 16
    t.string   "bjp_s_136_5",    limit: 16
    t.string   "bjp_s_136_6",    limit: 16
    t.string   "bjp_s_136_7",    limit: 16
    t.string   "bjp_s_136_8",    limit: 16
    t.string   "bjp_s_137_1",    limit: 16
    t.string   "bjp_s_137_2",    limit: 16
    t.string   "bjp_s_137_3",    limit: 16
    t.string   "bjp_s_137_4",    limit: 16
    t.string   "bjp_s_137_5",    limit: 16
    t.string   "bjp_s_137_6",    limit: 16
    t.string   "bjp_s_137_7",    limit: 16
    t.string   "bjp_s_137_8",    limit: 16
    t.string   "bjp_s_138_1",    limit: 16
    t.string   "bjp_s_138_2",    limit: 16
    t.string   "bjp_s_138_3",    limit: 16
    t.string   "bjp_s_138_4",    limit: 16
    t.string   "bjp_s_138_5",    limit: 16
    t.string   "bjp_s_138_6",    limit: 16
    t.string   "bjp_s_138_7",    limit: 16
    t.string   "bjp_s_138_8",    limit: 16
    t.string   "bjp_s_139_1",    limit: 16
    t.string   "bjp_s_139_2",    limit: 16
    t.string   "bjp_s_139_3",    limit: 16
    t.string   "bjp_s_139_4",    limit: 16
    t.string   "bjp_s_139_5",    limit: 16
    t.string   "bjp_s_139_6",    limit: 16
    t.string   "bjp_s_139_7",    limit: 16
    t.string   "bjp_s_139_8",    limit: 16
    t.string   "bjp_s_140_1",    limit: 16
    t.string   "bjp_s_140_2",    limit: 16
    t.string   "bjp_s_140_3",    limit: 16
    t.string   "bjp_s_140_4",    limit: 16
    t.string   "bjp_s_140_5",    limit: 16
    t.string   "bjp_s_140_6",    limit: 16
    t.string   "bjp_s_140_7",    limit: 16
    t.string   "bjp_s_140_8",    limit: 16
    t.string   "bjp_s_110_9",    limit: 16
    t.string   "bjp_s_111_9",    limit: 16
    t.string   "bjp_s_112_9",    limit: 16
    t.string   "bjp_s_113_9",    limit: 16
    t.string   "bjp_s_114_9",    limit: 16
    t.string   "bjp_s_115_9",    limit: 16
    t.string   "bjp_s_116_9",    limit: 16
    t.string   "bjp_s_117_9",    limit: 16
    t.string   "bjp_s_118_9",    limit: 16
    t.string   "bjp_s_119_9",    limit: 16
    t.string   "bjp_s_120_9",    limit: 16
    t.string   "bjp_s_121_9",    limit: 16
    t.string   "bjp_s_122_9",    limit: 16
    t.string   "bjp_s_123_9",    limit: 16
    t.string   "bjp_s_124_9",    limit: 16
    t.string   "bjp_s_125_9",    limit: 16
    t.string   "bjp_s_126_9",    limit: 16
    t.string   "bjp_s_127_9",    limit: 16
    t.string   "bjp_s_128_9",    limit: 16
    t.string   "bjp_s_129_9",    limit: 16
    t.string   "bjp_s_130_9",    limit: 16
    t.string   "bjp_s_131_9",    limit: 16
    t.string   "bjp_s_132_9",    limit: 16
    t.string   "bjp_s_133_9",    limit: 16
    t.string   "bjp_s_134_9",    limit: 16
    t.string   "bjp_s_135_9",    limit: 16
    t.string   "bjp_s_136_9",    limit: 16
    t.string   "bjp_s_137_9",    limit: 16
    t.string   "bjp_s_138_9",    limit: 16
    t.string   "bjp_s_139_9",    limit: 16
    t.string   "bjp_s_140_9",    limit: 16
    t.string   "bjp_s_110_0",    limit: 16
    t.string   "bjp_s_111_0",    limit: 16
    t.string   "bjp_s_112_0",    limit: 16
    t.string   "bjp_s_113_0",    limit: 16
    t.string   "bjp_s_114_0",    limit: 16
    t.string   "bjp_s_115_0",    limit: 16
    t.string   "bjp_s_116_0",    limit: 16
    t.string   "bjp_s_117_0",    limit: 16
    t.string   "bjp_s_118_0",    limit: 16
    t.string   "bjp_s_119_0",    limit: 16
    t.string   "bjp_s_120_0",    limit: 16
    t.string   "bjp_s_121_0",    limit: 16
    t.string   "bjp_s_122_0",    limit: 16
    t.string   "bjp_s_123_0",    limit: 16
    t.string   "bjp_s_124_0",    limit: 16
    t.string   "bjp_s_125_0",    limit: 16
    t.string   "bjp_s_126_0",    limit: 16
    t.string   "bjp_s_127_0",    limit: 16
    t.string   "bjp_s_128_0",    limit: 16
    t.string   "bjp_s_129_0",    limit: 16
    t.string   "bjp_s_130_0",    limit: 16
    t.string   "bjp_s_131_0",    limit: 16
    t.string   "bjp_s_132_0",    limit: 16
    t.string   "bjp_s_133_0",    limit: 16
    t.string   "bjp_s_134_0",    limit: 16
    t.string   "bjp_s_135_0",    limit: 16
    t.string   "bjp_s_136_0",    limit: 16
    t.string   "bjp_s_137_0",    limit: 16
    t.string   "bjp_s_138_0",    limit: 16
    t.string   "bjp_s_139_0",    limit: 16
    t.string   "bjp_s_140_0",    limit: 16
    t.string   "bjp_s_110_10",   limit: 16
    t.string   "bjp_s_111_10",   limit: 16
    t.string   "bjp_s_112_10",   limit: 16
    t.string   "bjp_s_113_10",   limit: 16
    t.string   "bjp_s_114_10",   limit: 16
    t.string   "bjp_s_115_10",   limit: 16
    t.string   "bjp_s_116_10",   limit: 16
    t.string   "bjp_s_117_10",   limit: 16
    t.string   "bjp_s_118_10",   limit: 16
    t.string   "bjp_s_119_10",   limit: 16
    t.string   "bjp_s_120_10",   limit: 16
    t.string   "bjp_s_121_10",   limit: 16
    t.string   "bjp_s_122_10",   limit: 16
    t.string   "bjp_s_123_10",   limit: 16
    t.string   "bjp_s_124_10",   limit: 16
    t.string   "bjp_s_125_10",   limit: 16
    t.string   "bjp_s_126_10",   limit: 16
    t.string   "bjp_s_127_10",   limit: 16
    t.string   "bjp_s_128_10",   limit: 16
    t.string   "bjp_s_129_10",   limit: 16
    t.string   "bjp_s_130_10",   limit: 16
    t.string   "bjp_s_131_10",   limit: 16
    t.string   "bjp_s_132_10",   limit: 16
    t.string   "bjp_s_133_10",   limit: 16
    t.string   "bjp_s_134_10",   limit: 16
    t.string   "bjp_s_135_10",   limit: 16
    t.string   "bjp_s_136_10",   limit: 16
    t.string   "bjp_s_137_10",   limit: 16
    t.string   "bjp_s_138_10",   limit: 16
    t.string   "bjp_s_139_10",   limit: 16
    t.string   "bjp_s_140_10",   limit: 16
    t.integer  "bjp_i_state",    limit: 4
  end

  create_table "bjpdata", force: :cascade do |t|
    t.string   "bjpdata_0",  limit: 255
    t.string   "bjpdata_1",  limit: 255
    t.string   "bjpdata_2",  limit: 255
    t.string   "bjpdata_3",  limit: 255
    t.string   "bjpdata_4",  limit: 255
    t.string   "bjpdata_5",  limit: 255
    t.string   "bjpdata_6",  limit: 255
    t.string   "bjpdata_7",  limit: 255
    t.string   "bjpdata_8",  limit: 255
    t.string   "bjpdata_9",  limit: 255
    t.integer  "bjp_bsb_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "c_categories", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "a_category_id", limit: 4
    t.integer  "b_category_id", limit: 4
    t.string   "note",          limit: 255
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "identifier",    limit: 255
    t.boolean  "enable",                    default: true
  end

  create_table "check_items", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.text     "JGDW",          limit: 65535
    t.text     "JYYJ",          limit: 65535
    t.text     "PDYJ",          limit: 65535
    t.text     "BZFFJCX",       limit: 65535
    t.string   "BZFFJCXDW",     limit: 255
    t.string   "BZZXYXX",       limit: 255
    t.string   "BZZXYXXDW",     limit: 255
    t.text     "BZZDYXX",       limit: 65535
    t.string   "BZZDYXXDW",     limit: 255
    t.integer  "d_category_id", limit: 4
    t.integer  "a_category_id", limit: 4
    t.integer  "b_category_id", limit: 4
    t.integer  "c_category_id", limit: 4
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "identifier",    limit: 255
    t.boolean  "enable",                      default: true
  end

  create_table "company_standards", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "number",          limit: 255
    t.string   "author_company",  limit: 255
    t.date     "valid_at"
    t.integer  "attachment_id",   limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "user_id",         limit: 4
    t.string   "attachment_path", limit: 255
  end

  create_table "d_categories", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "a_category_id", limit: 4
    t.integer  "b_category_id", limit: 4
    t.integer  "c_category_id", limit: 4
    t.string   "note",          limit: 255
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "identifier",    limit: 255
    t.boolean  "enable",                    default: true
  end

  create_table "flexcontents", force: :cascade do |t|
    t.string   "flex_field",   limit: 255
    t.string   "flex_name",    limit: 255
    t.string   "flex_id",      limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "flex_sortid",  limit: 4
    t.integer  "flex_groupid", limit: 4
  end

  create_table "hzp_bc_dws", force: :cascade do |t|
    t.string   "dwname",     limit: 255
    t.string   "dwlx",       limit: 255
    t.string   "dwsf",       limit: 255
    t.string   "dwdq",       limit: 255
    t.string   "dwxs",       limit: 255
    t.string   "dwxz",       limit: 255
    t.string   "dwdz",       limit: 255
    t.string   "dwyb",       limit: 255
    t.string   "dwfr",       limit: 255
    t.string   "dwfrdh",     limit: 255
    t.string   "dwfzr",      limit: 255
    t.string   "dwfzrdh",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "dwlxzdy",    limit: 255
  end

  create_table "hzp_bsbs", force: :cascade do |t|
    t.string   "hzp_s_1",        limit: 60
    t.string   "hzp_s_2",        limit: 60
    t.string   "hzp_s_3",        limit: 60
    t.string   "hzp_s_4",        limit: 60
    t.string   "hzp_s_5",        limit: 60
    t.string   "hzp_s_6",        limit: 60
    t.string   "hzp_s_7",        limit: 60
    t.string   "hzp_s_8",        limit: 60
    t.string   "hzp_s_9",        limit: 60
    t.string   "hzp_s_10",       limit: 60
    t.string   "hzp_s_11",       limit: 60
    t.string   "hzp_s_12",       limit: 60
    t.string   "hzp_s_13",       limit: 60
    t.string   "hzp_s_14",       limit: 60
    t.string   "hzp_s_15",       limit: 60
    t.string   "hzp_s_16",       limit: 60
    t.string   "hzp_s_17",       limit: 60
    t.string   "hzp_s_18",       limit: 60
    t.string   "hzp_s_19",       limit: 60
    t.date     "hzp_d_20"
    t.string   "hzp_s_21",       limit: 60
    t.string   "hzp_s_22",       limit: 60
    t.string   "hzp_s_23",       limit: 60
    t.string   "hzp_s_24",       limit: 60
    t.string   "hzp_s_25",       limit: 60
    t.decimal  "hzp_n_26",                  precision: 10
    t.string   "hzp_s_27",       limit: 60
    t.decimal  "hzp_n_28",                  precision: 10
    t.string   "hzp_s_29",       limit: 60
    t.string   "hzp_s_30",       limit: 60
    t.string   "hzp_s_31",       limit: 60
    t.string   "hzp_s_32",       limit: 60
    t.string   "hzp_s_33",       limit: 60
    t.date     "hzp_d_34"
    t.string   "hzp_s_35",       limit: 60
    t.string   "hzp_s_36",       limit: 60
    t.string   "hzp_s_37",       limit: 60
    t.string   "hzp_s_38",       limit: 60
    t.string   "hzp_s_39",       limit: 60
    t.string   "hzp_s_40",       limit: 60
    t.string   "hzp_s_41",       limit: 60
    t.date     "hzp_d_42"
    t.date     "hzp_d_43"
    t.string   "hzp_s_44",       limit: 60
    t.string   "hzp_s_45",       limit: 60
    t.string   "hzp_s_46",       limit: 60
    t.string   "hzp_s_47",       limit: 60
    t.string   "hzp_s_48",       limit: 60
    t.string   "hzp_s_49",       limit: 60
    t.string   "hzp_s_50",       limit: 60
    t.string   "hzp_s_51",       limit: 60
    t.string   "hzp_s_52",       limit: 60
    t.string   "hzp_s_53",       limit: 60
    t.string   "hzp_s_54",       limit: 60
    t.string   "hzp_s_55",       limit: 60
    t.string   "hzp_s_56",       limit: 60
    t.string   "hzp_s_57",       limit: 60
    t.string   "hzp_s_58",       limit: 60
    t.string   "hzp_s_59",       limit: 60
    t.string   "hzp_s_60",       limit: 60
    t.string   "hzp_s_61",       limit: 60
    t.string   "hzp_s_62",       limit: 60
    t.string   "hzp_s_63",       limit: 60
    t.string   "hzp_s_64",       limit: 60
    t.string   "hzp_s_65",       limit: 60
    t.string   "hzp_s_66",       limit: 60
    t.string   "hzp_s_67",       limit: 60
    t.string   "hzp_s_68",       limit: 60
    t.string   "hzp_s_69",       limit: 60
    t.string   "hzp_s_70",       limit: 60
    t.string   "hzp_s_71",       limit: 60
    t.string   "hzp_s_72",       limit: 60
    t.string   "hzp_s_73",       limit: 60
    t.string   "hzp_s_74",       limit: 60
    t.string   "hzp_s_75",       limit: 60
    t.string   "hzp_s_76",       limit: 60
    t.string   "hzp_s_77",       limit: 60
    t.string   "hzp_s_78",       limit: 60
    t.string   "hzp_s_79",       limit: 60
    t.string   "hzp_s_80",       limit: 60
    t.string   "hzp_s_81",       limit: 60
    t.string   "hzp_s_82",       limit: 60
    t.string   "hzp_s_83",       limit: 60
    t.string   "hzp_s_84",       limit: 60
    t.string   "hzp_s_85",       limit: 60
    t.string   "hzp_s_86",       limit: 60
    t.string   "hzp_s_87",       limit: 60
    t.string   "hzp_s_88",       limit: 60
    t.string   "hzp_s_89",       limit: 60
    t.date     "hzp_d_90"
    t.string   "hzp_s_91",       limit: 60
    t.string   "hzp_s_92",       limit: 60
    t.string   "tname",          limit: 60
    t.date     "submit_d_flag"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.decimal  "hzp_n_jcxcount",            precision: 10
    t.string   "hzp_s_bsfl",     limit: 16
    t.string   "hzp_s_2_1",      limit: 16
    t.string   "hzp_s_16_1",     limit: 16
    t.string   "hzp_s_40_1",     limit: 16
    t.string   "hzp_s_110_1",    limit: 16
    t.string   "hzp_s_110_2",    limit: 16
    t.string   "hzp_s_110_3",    limit: 16
    t.string   "hzp_s_110_4",    limit: 16
    t.string   "hzp_s_110_5",    limit: 16
    t.string   "hzp_s_110_6",    limit: 16
    t.string   "hzp_s_110_7",    limit: 16
    t.string   "hzp_s_110_8",    limit: 16
    t.string   "hzp_s_111_1",    limit: 16
    t.string   "hzp_s_111_2",    limit: 16
    t.string   "hzp_s_111_3",    limit: 16
    t.string   "hzp_s_111_4",    limit: 16
    t.string   "hzp_s_111_5",    limit: 16
    t.string   "hzp_s_111_6",    limit: 16
    t.string   "hzp_s_111_7",    limit: 16
    t.string   "hzp_s_111_8",    limit: 16
    t.string   "hzp_s_112_1",    limit: 16
    t.string   "hzp_s_112_2",    limit: 16
    t.string   "hzp_s_112_3",    limit: 16
    t.string   "hzp_s_112_4",    limit: 16
    t.string   "hzp_s_112_5",    limit: 16
    t.string   "hzp_s_112_6",    limit: 16
    t.string   "hzp_s_112_7",    limit: 16
    t.string   "hzp_s_112_8",    limit: 16
    t.string   "hzp_s_113_1",    limit: 16
    t.string   "hzp_s_113_2",    limit: 16
    t.string   "hzp_s_113_3",    limit: 16
    t.string   "hzp_s_113_4",    limit: 16
    t.string   "hzp_s_113_5",    limit: 16
    t.string   "hzp_s_113_6",    limit: 16
    t.string   "hzp_s_113_7",    limit: 16
    t.string   "hzp_s_113_8",    limit: 16
    t.string   "hzp_s_114_1",    limit: 16
    t.string   "hzp_s_114_2",    limit: 16
    t.string   "hzp_s_114_3",    limit: 16
    t.string   "hzp_s_114_4",    limit: 16
    t.string   "hzp_s_114_5",    limit: 16
    t.string   "hzp_s_114_6",    limit: 16
    t.string   "hzp_s_114_7",    limit: 16
    t.string   "hzp_s_114_8",    limit: 16
    t.string   "hzp_s_115_1",    limit: 16
    t.string   "hzp_s_115_2",    limit: 16
    t.string   "hzp_s_115_3",    limit: 16
    t.string   "hzp_s_115_4",    limit: 16
    t.string   "hzp_s_115_5",    limit: 16
    t.string   "hzp_s_115_6",    limit: 16
    t.string   "hzp_s_115_7",    limit: 16
    t.string   "hzp_s_115_8",    limit: 16
    t.string   "hzp_s_116_1",    limit: 16
    t.string   "hzp_s_116_2",    limit: 16
    t.string   "hzp_s_116_3",    limit: 16
    t.string   "hzp_s_116_4",    limit: 16
    t.string   "hzp_s_116_5",    limit: 16
    t.string   "hzp_s_116_6",    limit: 16
    t.string   "hzp_s_116_7",    limit: 16
    t.string   "hzp_s_116_8",    limit: 16
    t.string   "hzp_s_117_1",    limit: 16
    t.string   "hzp_s_117_2",    limit: 16
    t.string   "hzp_s_117_3",    limit: 16
    t.string   "hzp_s_117_4",    limit: 16
    t.string   "hzp_s_117_5",    limit: 16
    t.string   "hzp_s_117_6",    limit: 16
    t.string   "hzp_s_117_7",    limit: 16
    t.string   "hzp_s_117_8",    limit: 16
    t.string   "hzp_s_118_1",    limit: 16
    t.string   "hzp_s_118_2",    limit: 16
    t.string   "hzp_s_118_3",    limit: 16
    t.string   "hzp_s_118_4",    limit: 16
    t.string   "hzp_s_118_5",    limit: 16
    t.string   "hzp_s_118_6",    limit: 16
    t.string   "hzp_s_118_7",    limit: 16
    t.string   "hzp_s_118_8",    limit: 16
    t.string   "hzp_s_119_1",    limit: 16
    t.string   "hzp_s_119_2",    limit: 16
    t.string   "hzp_s_119_3",    limit: 16
    t.string   "hzp_s_119_4",    limit: 16
    t.string   "hzp_s_119_5",    limit: 16
    t.string   "hzp_s_119_6",    limit: 16
    t.string   "hzp_s_119_7",    limit: 16
    t.string   "hzp_s_119_8",    limit: 16
    t.string   "hzp_s_120_1",    limit: 16
    t.string   "hzp_s_120_2",    limit: 16
    t.string   "hzp_s_120_3",    limit: 16
    t.string   "hzp_s_120_4",    limit: 16
    t.string   "hzp_s_120_5",    limit: 16
    t.string   "hzp_s_120_6",    limit: 16
    t.string   "hzp_s_120_7",    limit: 16
    t.string   "hzp_s_120_8",    limit: 16
    t.string   "hzp_s_121_1",    limit: 16
    t.string   "hzp_s_121_2",    limit: 16
    t.string   "hzp_s_121_3",    limit: 16
    t.string   "hzp_s_121_4",    limit: 16
    t.string   "hzp_s_121_5",    limit: 16
    t.string   "hzp_s_121_6",    limit: 16
    t.string   "hzp_s_121_7",    limit: 16
    t.string   "hzp_s_121_8",    limit: 16
    t.string   "hzp_s_122_1",    limit: 16
    t.string   "hzp_s_122_2",    limit: 16
    t.string   "hzp_s_122_3",    limit: 16
    t.string   "hzp_s_122_4",    limit: 16
    t.string   "hzp_s_122_5",    limit: 16
    t.string   "hzp_s_122_6",    limit: 16
    t.string   "hzp_s_122_7",    limit: 16
    t.string   "hzp_s_122_8",    limit: 16
    t.string   "hzp_s_123_1",    limit: 16
    t.string   "hzp_s_123_2",    limit: 16
    t.string   "hzp_s_123_3",    limit: 16
    t.string   "hzp_s_123_4",    limit: 16
    t.string   "hzp_s_123_5",    limit: 16
    t.string   "hzp_s_123_6",    limit: 16
    t.string   "hzp_s_123_7",    limit: 16
    t.string   "hzp_s_123_8",    limit: 16
    t.string   "hzp_s_124_1",    limit: 16
    t.string   "hzp_s_124_2",    limit: 16
    t.string   "hzp_s_124_3",    limit: 16
    t.string   "hzp_s_124_4",    limit: 16
    t.string   "hzp_s_124_5",    limit: 16
    t.string   "hzp_s_124_6",    limit: 16
    t.string   "hzp_s_124_7",    limit: 16
    t.string   "hzp_s_124_8",    limit: 16
    t.string   "hzp_s_125_1",    limit: 16
    t.string   "hzp_s_125_2",    limit: 16
    t.string   "hzp_s_125_3",    limit: 16
    t.string   "hzp_s_125_4",    limit: 16
    t.string   "hzp_s_125_5",    limit: 16
    t.string   "hzp_s_125_6",    limit: 16
    t.string   "hzp_s_125_7",    limit: 16
    t.string   "hzp_s_125_8",    limit: 16
    t.string   "hzp_s_126_1",    limit: 16
    t.string   "hzp_s_126_2",    limit: 16
    t.string   "hzp_s_126_3",    limit: 16
    t.string   "hzp_s_126_4",    limit: 16
    t.string   "hzp_s_126_5",    limit: 16
    t.string   "hzp_s_126_6",    limit: 16
    t.string   "hzp_s_126_7",    limit: 16
    t.string   "hzp_s_126_8",    limit: 16
    t.string   "hzp_s_127_1",    limit: 16
    t.string   "hzp_s_127_2",    limit: 16
    t.string   "hzp_s_127_3",    limit: 16
    t.string   "hzp_s_127_4",    limit: 16
    t.string   "hzp_s_127_5",    limit: 16
    t.string   "hzp_s_127_6",    limit: 16
    t.string   "hzp_s_127_7",    limit: 16
    t.string   "hzp_s_127_8",    limit: 16
    t.string   "hzp_s_128_1",    limit: 16
    t.string   "hzp_s_128_2",    limit: 16
    t.string   "hzp_s_128_3",    limit: 16
    t.string   "hzp_s_128_4",    limit: 16
    t.string   "hzp_s_128_5",    limit: 16
    t.string   "hzp_s_128_6",    limit: 16
    t.string   "hzp_s_128_7",    limit: 16
    t.string   "hzp_s_128_8",    limit: 16
    t.string   "hzp_s_129_1",    limit: 16
    t.string   "hzp_s_129_2",    limit: 16
    t.string   "hzp_s_129_3",    limit: 16
    t.string   "hzp_s_129_4",    limit: 16
    t.string   "hzp_s_129_5",    limit: 16
    t.string   "hzp_s_129_6",    limit: 16
    t.string   "hzp_s_129_7",    limit: 16
    t.string   "hzp_s_129_8",    limit: 16
    t.string   "hzp_s_130_1",    limit: 16
    t.string   "hzp_s_130_2",    limit: 16
    t.string   "hzp_s_130_3",    limit: 16
    t.string   "hzp_s_130_4",    limit: 16
    t.string   "hzp_s_130_5",    limit: 16
    t.string   "hzp_s_130_6",    limit: 16
    t.string   "hzp_s_130_7",    limit: 16
    t.string   "hzp_s_130_8",    limit: 16
    t.string   "hzp_s_131_1",    limit: 16
    t.string   "hzp_s_131_2",    limit: 16
    t.string   "hzp_s_131_3",    limit: 16
    t.string   "hzp_s_131_4",    limit: 16
    t.string   "hzp_s_131_5",    limit: 16
    t.string   "hzp_s_131_6",    limit: 16
    t.string   "hzp_s_131_7",    limit: 16
    t.string   "hzp_s_131_8",    limit: 16
    t.string   "hzp_s_132_1",    limit: 16
    t.string   "hzp_s_132_2",    limit: 16
    t.string   "hzp_s_132_3",    limit: 16
    t.string   "hzp_s_132_4",    limit: 16
    t.string   "hzp_s_132_5",    limit: 16
    t.string   "hzp_s_132_6",    limit: 16
    t.string   "hzp_s_132_7",    limit: 16
    t.string   "hzp_s_132_8",    limit: 16
    t.string   "hzp_s_133_1",    limit: 16
    t.string   "hzp_s_133_2",    limit: 16
    t.string   "hzp_s_133_3",    limit: 16
    t.string   "hzp_s_133_4",    limit: 16
    t.string   "hzp_s_133_5",    limit: 16
    t.string   "hzp_s_133_6",    limit: 16
    t.string   "hzp_s_133_7",    limit: 16
    t.string   "hzp_s_133_8",    limit: 16
    t.string   "hzp_s_134_1",    limit: 16
    t.string   "hzp_s_134_2",    limit: 16
    t.string   "hzp_s_134_3",    limit: 16
    t.string   "hzp_s_134_4",    limit: 16
    t.string   "hzp_s_134_5",    limit: 16
    t.string   "hzp_s_134_6",    limit: 16
    t.string   "hzp_s_134_7",    limit: 16
    t.string   "hzp_s_134_8",    limit: 16
    t.string   "hzp_s_135_1",    limit: 16
    t.string   "hzp_s_135_2",    limit: 16
    t.string   "hzp_s_135_3",    limit: 16
    t.string   "hzp_s_135_4",    limit: 16
    t.string   "hzp_s_135_5",    limit: 16
    t.string   "hzp_s_135_6",    limit: 16
    t.string   "hzp_s_135_7",    limit: 16
    t.string   "hzp_s_135_8",    limit: 16
    t.string   "hzp_s_136_1",    limit: 16
    t.string   "hzp_s_136_2",    limit: 16
    t.string   "hzp_s_136_3",    limit: 16
    t.string   "hzp_s_136_4",    limit: 16
    t.string   "hzp_s_136_5",    limit: 16
    t.string   "hzp_s_136_6",    limit: 16
    t.string   "hzp_s_136_7",    limit: 16
    t.string   "hzp_s_136_8",    limit: 16
    t.string   "hzp_s_137_1",    limit: 16
    t.string   "hzp_s_137_2",    limit: 16
    t.string   "hzp_s_137_3",    limit: 16
    t.string   "hzp_s_137_4",    limit: 16
    t.string   "hzp_s_137_5",    limit: 16
    t.string   "hzp_s_137_6",    limit: 16
    t.string   "hzp_s_137_7",    limit: 16
    t.string   "hzp_s_137_8",    limit: 16
    t.string   "hzp_s_138_1",    limit: 16
    t.string   "hzp_s_138_2",    limit: 16
    t.string   "hzp_s_138_3",    limit: 16
    t.string   "hzp_s_138_4",    limit: 16
    t.string   "hzp_s_138_5",    limit: 16
    t.string   "hzp_s_138_6",    limit: 16
    t.string   "hzp_s_138_7",    limit: 16
    t.string   "hzp_s_138_8",    limit: 16
    t.string   "hzp_s_139_1",    limit: 16
    t.string   "hzp_s_139_2",    limit: 16
    t.string   "hzp_s_139_3",    limit: 16
    t.string   "hzp_s_139_4",    limit: 16
    t.string   "hzp_s_139_5",    limit: 16
    t.string   "hzp_s_139_6",    limit: 16
    t.string   "hzp_s_139_7",    limit: 16
    t.string   "hzp_s_139_8",    limit: 16
    t.string   "hzp_s_140_1",    limit: 16
    t.string   "hzp_s_140_2",    limit: 16
    t.string   "hzp_s_140_3",    limit: 16
    t.string   "hzp_s_140_4",    limit: 16
    t.string   "hzp_s_140_5",    limit: 16
    t.string   "hzp_s_140_6",    limit: 16
    t.string   "hzp_s_140_7",    limit: 16
    t.string   "hzp_s_140_8",    limit: 16
    t.string   "hzp_s_110_0",    limit: 16
    t.string   "hzp_s_111_0",    limit: 16
    t.string   "hzp_s_112_0",    limit: 16
    t.string   "hzp_s_113_0",    limit: 16
    t.string   "hzp_s_114_0",    limit: 16
    t.string   "hzp_s_115_0",    limit: 16
    t.string   "hzp_s_116_0",    limit: 16
    t.string   "hzp_s_117_0",    limit: 16
    t.string   "hzp_s_118_0",    limit: 16
    t.string   "hzp_s_119_0",    limit: 16
    t.string   "hzp_s_120_0",    limit: 16
    t.string   "hzp_s_121_0",    limit: 16
    t.string   "hzp_s_122_0",    limit: 16
    t.string   "hzp_s_123_0",    limit: 16
    t.string   "hzp_s_124_0",    limit: 16
    t.string   "hzp_s_125_0",    limit: 16
    t.string   "hzp_s_126_0",    limit: 16
    t.string   "hzp_s_127_0",    limit: 16
    t.string   "hzp_s_128_0",    limit: 16
    t.string   "hzp_s_129_0",    limit: 16
    t.string   "hzp_s_130_0",    limit: 16
    t.string   "hzp_s_131_0",    limit: 16
    t.string   "hzp_s_132_0",    limit: 16
    t.string   "hzp_s_133_0",    limit: 16
    t.string   "hzp_s_134_0",    limit: 16
    t.string   "hzp_s_135_0",    limit: 16
    t.string   "hzp_s_136_0",    limit: 16
    t.string   "hzp_s_137_0",    limit: 16
    t.string   "hzp_s_138_0",    limit: 16
    t.string   "hzp_s_139_0",    limit: 16
    t.string   "hzp_s_140_0",    limit: 16
    t.string   "hzp_s_110_9",    limit: 16
    t.string   "hzp_s_111_9",    limit: 16
    t.string   "hzp_s_112_9",    limit: 16
    t.string   "hzp_s_113_9",    limit: 16
    t.string   "hzp_s_114_9",    limit: 16
    t.string   "hzp_s_115_9",    limit: 16
    t.string   "hzp_s_116_9",    limit: 16
    t.string   "hzp_s_117_9",    limit: 16
    t.string   "hzp_s_118_9",    limit: 16
    t.string   "hzp_s_119_9",    limit: 16
    t.string   "hzp_s_120_9",    limit: 16
    t.string   "hzp_s_121_9",    limit: 16
    t.string   "hzp_s_122_9",    limit: 16
    t.string   "hzp_s_123_9",    limit: 16
    t.string   "hzp_s_124_9",    limit: 16
    t.string   "hzp_s_125_9",    limit: 16
    t.string   "hzp_s_126_9",    limit: 16
    t.string   "hzp_s_127_9",    limit: 16
    t.string   "hzp_s_128_9",    limit: 16
    t.string   "hzp_s_129_9",    limit: 16
    t.string   "hzp_s_130_9",    limit: 16
    t.string   "hzp_s_131_9",    limit: 16
    t.string   "hzp_s_132_9",    limit: 16
    t.string   "hzp_s_133_9",    limit: 16
    t.string   "hzp_s_134_9",    limit: 16
    t.string   "hzp_s_135_9",    limit: 16
    t.string   "hzp_s_136_9",    limit: 16
    t.string   "hzp_s_137_9",    limit: 16
    t.string   "hzp_s_138_9",    limit: 16
    t.string   "hzp_s_139_9",    limit: 16
    t.string   "hzp_s_140_9",    limit: 16
    t.integer  "hzp_i_state",    limit: 4
    t.string   "hzp_s_110_10",   limit: 16
    t.string   "hzp_s_111_10",   limit: 16
    t.string   "hzp_s_112_10",   limit: 16
    t.string   "hzp_s_113_10",   limit: 16
    t.string   "hzp_s_114_10",   limit: 16
    t.string   "hzp_s_115_10",   limit: 16
    t.string   "hzp_s_116_10",   limit: 16
    t.string   "hzp_s_117_10",   limit: 16
    t.string   "hzp_s_118_10",   limit: 16
    t.string   "hzp_s_119_10",   limit: 16
    t.string   "hzp_s_120_10",   limit: 16
    t.string   "hzp_s_121_10",   limit: 16
    t.string   "hzp_s_122_10",   limit: 16
    t.string   "hzp_s_123_10",   limit: 16
    t.string   "hzp_s_124_10",   limit: 16
    t.string   "hzp_s_125_10",   limit: 16
    t.string   "hzp_s_126_10",   limit: 16
    t.string   "hzp_s_127_10",   limit: 16
    t.string   "hzp_s_128_10",   limit: 16
    t.string   "hzp_s_129_10",   limit: 16
    t.string   "hzp_s_130_10",   limit: 16
    t.string   "hzp_s_131_10",   limit: 16
    t.string   "hzp_s_132_10",   limit: 16
    t.string   "hzp_s_133_10",   limit: 16
    t.string   "hzp_s_134_10",   limit: 16
    t.string   "hzp_s_135_10",   limit: 16
    t.string   "hzp_s_136_10",   limit: 16
    t.string   "hzp_s_137_10",   limit: 16
    t.string   "hzp_s_138_10",   limit: 16
    t.string   "hzp_s_139_10",   limit: 16
    t.string   "hzp_s_140_10",   limit: 16
  end

  create_table "hzp_ypbs", force: :cascade do |t|
    t.string   "dwname",     limit: 255
    t.string   "ypname",     limit: 255
    t.string   "ypno",       limit: 255
    t.string   "ypflei",     limit: 255
    t.string   "ypleib",     limit: 255
    t.string   "ypleibzdy",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "hzpdata", force: :cascade do |t|
    t.string   "hzpdata_0",  limit: 255
    t.string   "hzpdata_1",  limit: 255
    t.string   "hzpdata_2",  limit: 255
    t.string   "hzpdata_3",  limit: 255
    t.string   "hzpdata_4",  limit: 255
    t.string   "hzpdata_5",  limit: 255
    t.string   "hzpdata_6",  limit: 255
    t.string   "hzpdata_7",  limit: 255
    t.string   "hzpdata_8",  limit: 255
    t.string   "hzpdata_9",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "hzp_bsb_id", limit: 255
  end

  create_table "jg_bsb_names", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "jg_bsb_id",       limit: 4
    t.string   "note",            limit: 255
    t.integer  "creator_user_id", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "jg_bsb_stamps", force: :cascade do |t|
    t.integer  "jg_bsb_id",  limit: 4
    t.string   "stamp_no",   limit: 255
    t.string   "note",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_path", limit: 255
    t.string   "name",       limit: 255
    t.integer  "stamp_type", limit: 4
  end

  create_table "jg_bsbs", force: :cascade do |t|
    t.string   "jg_name",           limit: 255
    t.string   "jg_address",        limit: 255
    t.string   "jg_leader",         limit: 255
    t.string   "jg_higher_level",   limit: 255
    t.string   "jg_contacts",       limit: 255
    t.string   "jg_tel",            limit: 255
    t.string   "jg_certification",  limit: 255
    t.string   "jg_word_area",      limit: 255
    t.integer  "jg_sampling",       limit: 4
    t.integer  "jg_detection",      limit: 4
    t.integer  "jg_group",          limit: 4
    t.string   "jg_group_category", limit: 255
    t.integer  "jg_administrion",   limit: 4
    t.integer  "jg_sp_permission",  limit: 4
    t.integer  "jg_bjp_permission", limit: 4
    t.integer  "jg_hzp_permission", limit: 4
    t.integer  "jg_enable",         limit: 4
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "jg_province",       limit: 255
    t.string   "jg_email",          limit: 255
    t.string   "code",              limit: 255
    t.string   "api_ip_address",    limit: 255
    t.string   "gpsname",           limit: 255
    t.string   "gpspassword",       limit: 255
    t.string   "attachment_path",   limit: 255
    t.string   "pdf_sign_rules",    limit: 255
    t.integer  "status",            limit: 4,   default: 0
  end

  create_table "mytests", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "age",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", limit: 4,     null: false
    t.integer  "application_id",    limit: 4,     null: false
    t.string   "token",             limit: 255,   null: false
    t.integer  "expires_in",        limit: 4,     null: false
    t.text     "redirect_uri",      limit: 65535, null: false
    t.datetime "created_at",                      null: false
    t.datetime "revoked_at"
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id", limit: 4
    t.integer  "application_id",    limit: 4
    t.string   "token",             limit: 255, null: false
    t.string   "refresh_token",     limit: 255
    t.integer  "expires_in",        limit: 4
    t.datetime "revoked_at"
    t.datetime "created_at",                    null: false
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",         limit: 255,                   null: false
    t.string   "uid",          limit: 255,                   null: false
    t.string   "secret",       limit: 255,                   null: false
    t.text     "redirect_uri", limit: 65535,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",      limit: 4
    t.string   "prov",         limit: 255
    t.string   "jg",           limit: 255
    t.boolean  "auto_submit",                default: false
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "address",    limit: 65535
    t.string   "email",      limit: 255
    t.string   "pay_type",   limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "pad_sp_bsbs", force: :cascade do |t|
    t.string   "sp_s_1",            limit: 60
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.string   "sp_s_2",            limit: 255,                  default: ""
    t.string   "sp_s_3",            limit: 255,                  default: ""
    t.string   "sp_s_4",            limit: 60
    t.string   "sp_s_5",            limit: 60
    t.string   "sp_s_6",            limit: 60
    t.string   "sp_s_7",            limit: 60
    t.string   "sp_s_8",            limit: 60
    t.string   "sp_s_9",            limit: 60
    t.string   "sp_s_10",           limit: 60
    t.string   "sp_s_11",           limit: 60
    t.string   "sp_s_12",           limit: 60
    t.string   "sp_s_13",           limit: 60
    t.string   "sp_s_14",           limit: 255,                  default: ""
    t.float    "sp_n_15",           limit: 24
    t.string   "sp_s_16",           limit: 255,                  default: ""
    t.string   "sp_s_17",           limit: 255,                  default: ""
    t.string   "sp_s_18",           limit: 60
    t.string   "sp_s_19",           limit: 60
    t.string   "sp_s_20",           limit: 255,                  default: ""
    t.string   "sp_s_21",           limit: 60
    t.date     "sp_d_22"
    t.string   "sp_s_23",           limit: 60
    t.string   "sp_s_24",           limit: 60
    t.string   "sp_s_25",           limit: 60
    t.string   "sp_s_26",           limit: 60
    t.string   "sp_s_27",           limit: 60
    t.date     "sp_d_28"
    t.string   "sp_n_29",           limit: 255
    t.string   "sp_s_30",           limit: 60
    t.decimal  "sp_n_31",                         precision: 10
    t.decimal  "sp_n_32",                         precision: 10
    t.string   "sp_s_33",           limit: 60
    t.string   "sp_s_34",           limit: 255
    t.string   "sp_s_35",           limit: 255,                  default: ""
    t.string   "sp_s_36",           limit: 60
    t.string   "sp_s_37",           limit: 60
    t.date     "sp_d_38"
    t.string   "sp_s_39",           limit: 60
    t.string   "sp_s_40",           limit: 60
    t.string   "sp_s_41",           limit: 60
    t.string   "sp_s_42",           limit: 60
    t.string   "sp_s_43",           limit: 255,                  default: ""
    t.string   "sp_s_44",           limit: 60
    t.string   "sp_s_45",           limit: 60
    t.date     "sp_d_46"
    t.date     "sp_d_47"
    t.string   "sp_s_48",           limit: 60
    t.string   "sp_s_49",           limit: 60
    t.string   "sp_s_50",           limit: 60
    t.string   "sp_s_51",           limit: 60
    t.text     "sp_s_52",           limit: 65535
    t.text     "sp_s_53",           limit: 65535
    t.text     "sp_s_54",           limit: 65535
    t.text     "sp_s_55",           limit: 65535
    t.string   "sp_s_56",           limit: 60
    t.string   "sp_s_57",           limit: 60
    t.string   "sp_s_58",           limit: 60
    t.string   "sp_s_59",           limit: 60
    t.string   "sp_s_60",           limit: 60
    t.string   "sp_s_61",           limit: 60
    t.string   "sp_s_62",           limit: 60
    t.string   "sp_s_63",           limit: 60
    t.string   "sp_s_64",           limit: 60
    t.string   "sp_s_65",           limit: 255
    t.string   "sp_s_66",           limit: 60
    t.string   "sp_s_67",           limit: 60
    t.string   "sp_s_68",           limit: 60
    t.string   "sp_s_69",           limit: 60
    t.string   "sp_s_70",           limit: 60
    t.text     "sp_s_71",           limit: 65535
    t.string   "sp_s_72",           limit: 60
    t.string   "sp_s_73",           limit: 60
    t.string   "sp_s_74",           limit: 60
    t.string   "sp_s_75",           limit: 60
    t.string   "sp_s_76",           limit: 60
    t.string   "sp_s_77",           limit: 60
    t.string   "sp_s_78",           limit: 60
    t.string   "sp_s_79",           limit: 60
    t.string   "sp_s_80",           limit: 60
    t.string   "sp_s_81",           limit: 60
    t.string   "sp_s_82",           limit: 60
    t.string   "sp_s_83",           limit: 60
    t.string   "sp_s_84",           limit: 255
    t.string   "sp_s_85",           limit: 255,                  default: ""
    t.date     "sp_d_86"
    t.string   "sp_s_87",           limit: 60
    t.string   "sp_s_88",           limit: 60
    t.string   "tname",             limit: 60
    t.datetime "submit_d_flag"
    t.decimal  "sp_n_jcxcount",                   precision: 10
    t.string   "sp_s_bsfl",         limit: 60
    t.string   "sp_s_2_1",          limit: 255
    t.integer  "sp_i_state",        limit: 4
    t.integer  "sp_i_jgback",       limit: 4
    t.text     "sp_s_reason",       limit: 65535
    t.integer  "sp_i_backtimes",    limit: 4
    t.string   "sp_s_201",          limit: 255
    t.string   "sp_s_202",          limit: 255
    t.string   "sp_s_203",          limit: 255
    t.string   "sp_s_204",          limit: 255
    t.string   "sp_s_205",          limit: 255
    t.string   "sp_s_206",          limit: 255
    t.string   "sp_s_207",          limit: 255
    t.string   "sp_s_208",          limit: 255
    t.string   "sp_s_209",          limit: 255
    t.string   "sp_s_210",          limit: 255
    t.string   "sp_s_211",          limit: 255
    t.string   "sp_s_212",          limit: 255
    t.string   "sp_s_213",          limit: 255
    t.string   "sp_s_214",          limit: 255
    t.string   "sp_s_215",          limit: 255
    t.text     "sp_t_procedure",    limit: 65535
    t.string   "gps",               limit: 255
    t.text     "failed_message",    limit: 65535
    t.string   "refuse_pic_path",   limit: 255
    t.boolean  "via_api",                                        default: false
    t.string   "bgfl",              limit: 255
    t.string   "fail_report_path",  limit: 255
    t.integer  "jg_bsb_id",         limit: 4
    t.integer  "sys_province_id",   limit: 4
    t.integer  "a_category_id",     limit: 4
    t.text     "refuse_reason",     limit: 65535
    t.string   "accept_file_path",  limit: 255
    t.integer  "b_category_id",     limit: 4
    t.integer  "c_category_id",     limit: 4
    t.integer  "d_category_id",     limit: 4
    t.string   "sp_xkz",            limit: 255
    t.string   "sp_xkz_id",         limit: 255
    t.string   "cyd_file_path",     limit: 255
    t.string   "cyjygzs_file_path", limit: 255
  end

  add_index "pad_sp_bsbs", ["sp_s_1"], name: "index_pad_sp_bsbs_on_sp_s_1", using: :btree

  create_table "pad_sp_logs", force: :cascade do |t|
    t.text     "remark",        limit: 65535
    t.integer  "pad_sp_bsb_id", limit: 4
    t.text     "sp_s_16",       limit: 65535
    t.integer  "sp_i_state",    limit: 4
    t.integer  "user_id",       limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.string   "image_url",   limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "provinces", id: false, force: :cascade do |t|
    t.string "sp_s_3", limit: 255, default: ""
  end

  create_table "pub_sp_bsbs", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.integer  "user_id",           limit: 4
    t.string   "username",          limit: 255
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
    t.integer  "publication_type",  limit: 4,                              default: -1
    t.string   "sp_s_1",            limit: 255,                            default: ""
    t.string   "sp_s_2",            limit: 255,                            default: ""
    t.string   "sp_s_3",            limit: 255,                            default: ""
    t.string   "sp_s_4",            limit: 60
    t.string   "sp_s_5",            limit: 60
    t.string   "sp_s_6",            limit: 60
    t.string   "sp_s_7",            limit: 255
    t.string   "sp_s_8",            limit: 60
    t.string   "sp_s_9",            limit: 60
    t.string   "sp_s_10",           limit: 60
    t.string   "sp_s_11",           limit: 60
    t.string   "sp_s_12",           limit: 60
    t.string   "sp_s_13",           limit: 60
    t.string   "sp_s_14",           limit: 255,                            default: ""
    t.decimal  "sp_n_15",                         precision: 10, scale: 2
    t.string   "sp_s_16",           limit: 60
    t.string   "sp_s_17",           limit: 255,                            default: ""
    t.string   "sp_s_18",           limit: 60
    t.string   "sp_s_19",           limit: 60
    t.string   "sp_s_20",           limit: 255,                            default: ""
    t.string   "sp_s_21",           limit: 60
    t.date     "sp_d_22"
    t.string   "sp_s_23",           limit: 60
    t.string   "sp_s_24",           limit: 60
    t.string   "sp_s_25",           limit: 60
    t.string   "sp_s_26",           limit: 60
    t.string   "sp_s_27",           limit: 60
    t.date     "sp_d_28"
    t.string   "sp_n_29",           limit: 255
    t.string   "sp_s_30",           limit: 60
    t.decimal  "sp_n_31",                         precision: 10
    t.decimal  "sp_n_32",                         precision: 10
    t.string   "sp_s_33",           limit: 60
    t.string   "sp_s_34",           limit: 255
    t.string   "sp_s_35",           limit: 255,                            default: ""
    t.string   "sp_s_36",           limit: 60
    t.string   "sp_s_37",           limit: 60
    t.date     "sp_d_38"
    t.string   "sp_s_39",           limit: 60
    t.string   "sp_s_40",           limit: 60
    t.string   "sp_s_41",           limit: 60
    t.string   "sp_s_42",           limit: 60
    t.string   "sp_s_43",           limit: 255,                            default: ""
    t.string   "sp_s_44",           limit: 60
    t.string   "sp_s_45",           limit: 60
    t.date     "sp_d_46"
    t.date     "sp_d_47"
    t.string   "sp_s_48",           limit: 60
    t.string   "sp_s_49",           limit: 60
    t.string   "sp_s_50",           limit: 60
    t.string   "sp_s_51",           limit: 60
    t.text     "sp_s_52",           limit: 65535
    t.text     "sp_s_53",           limit: 65535
    t.text     "sp_s_54",           limit: 65535
    t.text     "sp_s_55",           limit: 65535
    t.string   "sp_s_56",           limit: 60
    t.string   "sp_s_57",           limit: 60
    t.string   "sp_s_58",           limit: 60
    t.string   "sp_s_59",           limit: 60
    t.string   "sp_s_60",           limit: 60
    t.string   "sp_s_61",           limit: 60
    t.string   "sp_s_62",           limit: 60
    t.string   "sp_s_63",           limit: 60
    t.string   "sp_s_64",           limit: 255,                            default: ""
    t.string   "sp_s_65",           limit: 255
    t.string   "sp_s_66",           limit: 60
    t.string   "sp_s_67",           limit: 60
    t.string   "sp_s_68",           limit: 60
    t.string   "sp_s_69",           limit: 60
    t.string   "sp_s_70",           limit: 60
    t.string   "sp_s_71",           limit: 60
    t.string   "sp_s_72",           limit: 60
    t.string   "sp_s_73",           limit: 60
    t.string   "sp_s_74",           limit: 60
    t.string   "sp_s_75",           limit: 60
    t.string   "sp_s_76",           limit: 60
    t.string   "sp_s_77",           limit: 60
    t.string   "sp_s_78",           limit: 60
    t.string   "sp_s_79",           limit: 60
    t.string   "sp_s_80",           limit: 60
    t.string   "sp_s_81",           limit: 60
    t.string   "sp_s_82",           limit: 60
    t.string   "sp_s_83",           limit: 60
    t.string   "sp_s_84",           limit: 255
    t.string   "sp_s_85",           limit: 60
    t.date     "sp_d_86"
    t.string   "sp_s_87",           limit: 60
    t.string   "sp_s_88",           limit: 60
    t.string   "tname",             limit: 60
    t.datetime "submit_d_flag"
    t.decimal  "sp_n_jcxcount",                   precision: 10
    t.string   "sp_s_bsfl",         limit: 60
    t.string   "sp_s_2_1",          limit: 255,                            default: ""
    t.integer  "sp_i_state",        limit: 4
    t.integer  "sp_i_jgback",       limit: 4
    t.text     "sp_s_reason",       limit: 65535
    t.integer  "sp_i_backtimes",    limit: 4
    t.string   "sp_s_201",          limit: 255
    t.string   "sp_s_202",          limit: 255
    t.string   "sp_s_203",          limit: 255
    t.string   "sp_s_204",          limit: 255
    t.string   "sp_s_205",          limit: 255
    t.string   "sp_s_206",          limit: 255
    t.string   "sp_s_207",          limit: 255
    t.string   "sp_s_208",          limit: 255
    t.string   "sp_s_209",          limit: 255
    t.string   "sp_s_210",          limit: 255
    t.string   "sp_s_211",          limit: 255
    t.string   "sp_s_212",          limit: 255
    t.string   "sp_s_213",          limit: 255
    t.string   "sp_s_214",          limit: 255
    t.string   "sp_s_215",          limit: 255
    t.text     "sp_t_procedure",    limit: 65535
    t.string   "fail_report_path",  limit: 255
    t.boolean  "is_yydj",                                                  default: false
    t.integer  "current_yycz_step", limit: 4,                              default: -1
    t.string   "bgfl",              limit: 255,                            default: ""
    t.string   "sp_xkz",            limit: 255
    t.string   "sp_xkz_id",         limit: 255
    t.datetime "fail_report_at"
    t.boolean  "czb_reverted_flag",                                        default: false
    t.boolean  "synced",                                                   default: false
    t.string   "gbsj",              limit: 255,                            default: "0"
    t.integer  "sp_bsb_id",         limit: 4,                                              null: false
  end

  create_table "pub_spdata", force: :cascade do |t|
    t.integer  "sp_bsb_publication_id", limit: 4
    t.string   "spdata_0",              limit: 255
    t.string   "spdata_1",              limit: 255
    t.string   "spdata_2",              limit: 255
    t.string   "spdata_3",              limit: 255
    t.string   "spdata_4",              limit: 255
    t.string   "spdata_5",              limit: 255
    t.string   "spdata_6",              limit: 255
    t.string   "spdata_7",              limit: 255
    t.string   "spdata_8",              limit: 255
    t.string   "spdata_9",              limit: 255
    t.string   "spdata_10",             limit: 255
    t.string   "spdata_11",             limit: 255
    t.string   "spdata_12",             limit: 255
    t.string   "spdata_13",             limit: 255
    t.string   "spdata_14",             limit: 255
    t.string   "spdata_15",             limit: 255
    t.string   "spdata_16",             limit: 255
    t.string   "spdata_17",             limit: 255
    t.string   "spdata_18",             limit: 255
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "spdata_id",             limit: 4,   null: false
  end

  create_table "published_sp_bsbs", force: :cascade do |t|
    t.string   "cjbh",              limit: 255
    t.datetime "published_at"
    t.integer  "user_id",           limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.date     "cfda_published_at"
  end

  create_table "sample_members", force: :cascade do |t|
    t.string   "jg_name",       limit: 255
    t.string   "username",      limit: 255
    t.string   "uid",           limit: 255
    t.string   "major",         limit: 255
    t.string   "edu_bg",        limit: 255
    t.string   "title",         limit: 255
    t.string   "mobile",        limit: 255
    t.string   "work_history",  limit: 255
    t.string   "note",          limit: 255
    t.integer  "attachment_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "gender",        limit: 5
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "sp_bsb_api_logs", force: :cascade do |t|
    t.integer  "application_id", limit: 4
    t.integer  "sp_bsb_id",      limit: 4
    t.text     "snapshot",       limit: 65535
    t.string   "note",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sp_bsb_certs", force: :cascade do |t|
    t.text     "source",     limit: 65535
    t.text     "user_cert",  limit: 65535
    t.text     "sign",       limit: 65535
    t.integer  "user_id",    limit: 4
    t.integer  "sp_i_state", limit: 4
    t.integer  "sp_bsb_id",  limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "sp_bsb_pictures", force: :cascade do |t|
    t.integer  "sp_bsb_id",  limit: 4
    t.string   "desc",       limit: 255
    t.string   "path",       limit: 255
    t.integer  "sort_index", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "md5",        limit: 255
  end

  create_table "sp_bsb_reports", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.datetime "start_at"
    t.datetime "finished_at"
    t.datetime "failed_at"
    t.string   "result_file",   limit: 255
    t.text     "result_msg",    limit: 65535
    t.string   "flowid",        limit: 255
    t.integer  "user_id",       limit: 4
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "jid",           limit: 255
    t.integer  "current_state", limit: 4,     default: 0
  end

  create_table "sp_bsbs", force: :cascade do |t|
    t.string   "sp_s_1",                   limit: 255,                  default: ""
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.string   "sp_s_2",                   limit: 255,                  default: ""
    t.string   "sp_s_3",                   limit: 255,                  default: ""
    t.string   "sp_s_4",                   limit: 60
    t.string   "sp_s_5",                   limit: 60
    t.string   "sp_s_6",                   limit: 60
    t.string   "sp_s_7",                   limit: 255
    t.string   "sp_s_8",                   limit: 60
    t.string   "sp_s_9",                   limit: 60
    t.string   "sp_s_10",                  limit: 60
    t.string   "sp_s_11",                  limit: 60
    t.string   "sp_s_12",                  limit: 60
    t.string   "sp_s_13",                  limit: 60
    t.string   "sp_s_14",                  limit: 255,                  default: ""
    t.float    "sp_n_15",                  limit: 24
    t.string   "sp_s_16",                  limit: 60
    t.string   "sp_s_17",                  limit: 255,                  default: ""
    t.string   "sp_s_18",                  limit: 60
    t.string   "sp_s_19",                  limit: 60
    t.string   "sp_s_20",                  limit: 255,                  default: ""
    t.string   "sp_s_21",                  limit: 60
    t.date     "sp_d_22"
    t.string   "sp_s_23",                  limit: 60
    t.string   "sp_s_24",                  limit: 60
    t.string   "sp_s_25",                  limit: 60
    t.string   "sp_s_26",                  limit: 60
    t.string   "sp_s_27",                  limit: 60
    t.date     "sp_d_28"
    t.string   "sp_n_29",                  limit: 255
    t.string   "sp_s_30",                  limit: 60
    t.decimal  "sp_n_31",                                precision: 10
    t.decimal  "sp_n_32",                                precision: 10
    t.string   "sp_s_33",                  limit: 60
    t.string   "sp_s_34",                  limit: 255
    t.string   "sp_s_35",                  limit: 255,                  default: ""
    t.string   "sp_s_36",                  limit: 60
    t.string   "sp_s_37",                  limit: 60
    t.date     "sp_d_38"
    t.string   "sp_s_39",                  limit: 60
    t.string   "sp_s_40",                  limit: 60
    t.string   "sp_s_41",                  limit: 60
    t.string   "sp_s_42",                  limit: 60
    t.string   "sp_s_43",                  limit: 255,                  default: ""
    t.string   "sp_s_44",                  limit: 60
    t.string   "sp_s_45",                  limit: 60
    t.date     "sp_d_46"
    t.date     "sp_d_47"
    t.string   "sp_s_48",                  limit: 60
    t.string   "sp_s_49",                  limit: 60
    t.string   "sp_s_50",                  limit: 60
    t.string   "sp_s_51",                  limit: 60
    t.text     "sp_s_52",                  limit: 65535
    t.text     "sp_s_53",                  limit: 65535
    t.text     "sp_s_54",                  limit: 65535
    t.text     "sp_s_55",                  limit: 65535
    t.string   "sp_s_56",                  limit: 60
    t.string   "sp_s_57",                  limit: 60
    t.string   "sp_s_58",                  limit: 60
    t.string   "sp_s_59",                  limit: 60
    t.string   "sp_s_60",                  limit: 60
    t.string   "sp_s_61",                  limit: 60
    t.string   "sp_s_62",                  limit: 60
    t.string   "sp_s_63",                  limit: 60
    t.string   "sp_s_64",                  limit: 255,                  default: ""
    t.string   "sp_s_65",                  limit: 255
    t.string   "sp_s_66",                  limit: 60
    t.string   "sp_s_67",                  limit: 60
    t.string   "sp_s_68",                  limit: 60
    t.string   "sp_s_69",                  limit: 60
    t.string   "sp_s_70",                  limit: 60
    t.string   "sp_s_71",                  limit: 60
    t.string   "sp_s_72",                  limit: 60
    t.string   "sp_s_73",                  limit: 60
    t.string   "sp_s_74",                  limit: 60
    t.string   "sp_s_75",                  limit: 60
    t.string   "sp_s_76",                  limit: 60
    t.string   "sp_s_77",                  limit: 60
    t.string   "sp_s_78",                  limit: 60
    t.string   "sp_s_79",                  limit: 60
    t.string   "sp_s_80",                  limit: 60
    t.string   "sp_s_81",                  limit: 60
    t.string   "sp_s_82",                  limit: 60
    t.string   "sp_s_83",                  limit: 60
    t.string   "sp_s_84",                  limit: 255
    t.string   "sp_s_85",                  limit: 60
    t.date     "sp_d_86"
    t.string   "sp_s_87",                  limit: 60
    t.string   "sp_s_88",                  limit: 60
    t.string   "tname",                    limit: 60
    t.datetime "submit_d_flag"
    t.decimal  "sp_n_jcxcount",                          precision: 10
    t.string   "sp_s_bsfl",                limit: 60
    t.string   "sp_s_2_1",                 limit: 255,                  default: ""
    t.integer  "sp_i_state",               limit: 4,                    default: 0
    t.integer  "sp_i_jgback",              limit: 4
    t.text     "sp_s_reason",              limit: 65535
    t.integer  "sp_i_backtimes",           limit: 4
    t.string   "sp_s_201",                 limit: 255
    t.string   "sp_s_202",                 limit: 255
    t.string   "sp_s_203",                 limit: 255
    t.string   "sp_s_204",                 limit: 255
    t.string   "sp_s_205",                 limit: 255
    t.string   "sp_s_206",                 limit: 255
    t.string   "sp_s_207",                 limit: 255
    t.string   "sp_s_208",                 limit: 255
    t.string   "sp_s_209",                 limit: 255
    t.string   "sp_s_210",                 limit: 255
    t.string   "sp_s_211",                 limit: 255
    t.string   "sp_s_212",                 limit: 255
    t.string   "sp_s_213",                 limit: 255
    t.string   "sp_s_214",                 limit: 255
    t.string   "sp_s_215",                 limit: 255
    t.text     "sp_t_procedure",           limit: 65535
    t.string   "fail_report_path",         limit: 255
    t.boolean  "is_yydj",                                               default: false
    t.integer  "current_yycz_step",        limit: 4,                    default: -1
    t.string   "bgfl",                     limit: 255,                  default: ""
    t.string   "sp_xkz",                   limit: 255
    t.string   "sp_xkz_id",                limit: 255
    t.datetime "fail_report_at"
    t.boolean  "czb_reverted_flag",                                     default: false
    t.boolean  "synced",                                                default: false
    t.string   "gbsj",                     limit: 255,                  default: "未公布"
    t.string   "report_path",              limit: 255
    t.string   "cyd_file_path",            limit: 255
    t.string   "cyjygzs_file_path",        limit: 255
    t.datetime "yydj_enabled_by_admin_at"
  end

  add_index "sp_bsbs", ["id"], name: "index_sp_bsbs_on_id", using: :btree
  add_index "sp_bsbs", ["sp_d_86"], name: "index_sp_bsbs_on_sp_d_86", using: :btree
  add_index "sp_bsbs", ["sp_i_state"], name: "index_on_sp_i_state", using: :btree
  add_index "sp_bsbs", ["sp_s_1"], name: "index_sp_bsbs_on_sp_s_1", using: :btree
  add_index "sp_bsbs", ["sp_s_14"], name: "index_on_sp_s_14", using: :btree
  add_index "sp_bsbs", ["sp_s_16"], name: "index_sp_bsbs_on_sp_s_16", using: :btree
  add_index "sp_bsbs", ["sp_s_202"], name: "index_sp_bsbs_on_sp_s_202", using: :btree
  add_index "sp_bsbs", ["sp_s_214"], name: "index_on_sp_s_214", using: :btree
  add_index "sp_bsbs", ["sp_s_3"], name: "index_sp_bsbs_on_sp_s_3", using: :btree
  add_index "sp_bsbs", ["sp_s_35"], name: "index_on_sp_s_35", using: :btree
  add_index "sp_bsbs", ["sp_s_43"], name: "index_on_sp_s_43", using: :btree
  add_index "sp_bsbs", ["sp_s_5"], name: "index_sp_bsbs_on_sp_s_5", using: :btree
  add_index "sp_bsbs", ["sp_s_71"], name: "index_sp_bsbs_on_sp_s_71", using: :btree
  add_index "sp_bsbs", ["tname"], name: "index_tname", using: :btree
  add_index "sp_bsbs", ["updated_at"], name: "update_desc", using: :btree

  create_table "sp_company_infos", force: :cascade do |t|
    t.string   "sp_s_1",     limit: 60
    t.string   "sp_s_68",    limit: 60
    t.string   "sp_s_23",    limit: 60
    t.string   "sp_s_215",   limit: 255
    t.string   "sp_s_bsfl",  limit: 60
    t.string   "sp_s_201",   limit: 255
    t.string   "sp_s_3",     limit: 60
    t.string   "sp_s_4",     limit: 60
    t.string   "sp_s_5",     limit: 60
    t.string   "sp_s_7",     limit: 60
    t.string   "sp_s_10",    limit: 60
    t.string   "sp_s_8",     limit: 60
    t.string   "sp_s_9",     limit: 60
    t.string   "sp_s_11",    limit: 60
    t.string   "sp_s_12",    limit: 60
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "sp_s_2",     limit: 255
    t.string   "sp_s_17",    limit: 255
    t.string   "sp_s_18",    limit: 255
    t.string   "sp_s_19",    limit: 255
    t.string   "sp_s_20",    limit: 255
    t.integer  "qylx",       limit: 4,   default: 0
  end

  create_table "sp_hcz_spdata", force: :cascade do |t|
    t.string   "spdata_0",    limit: 255
    t.string   "spdata_1",    limit: 255
    t.string   "spdata_2",    limit: 255
    t.string   "spdata_3",    limit: 255
    t.string   "spdata_4",    limit: 255
    t.string   "spdata_5",    limit: 255
    t.string   "spdata_6",    limit: 255
    t.string   "spdata_7",    limit: 255
    t.string   "spdata_8",    limit: 255
    t.string   "spdata_9",    limit: 255
    t.string   "spdata_10",   limit: 255
    t.string   "spdata_11",   limit: 255
    t.string   "spdata_12",   limit: 255
    t.string   "spdata_13",   limit: 255
    t.string   "spdata_14",   limit: 255
    t.string   "spdata_15",   limit: 255
    t.string   "spdata_16",   limit: 255
    t.string   "spdata_17",   limit: 255
    t.string   "spdata_18",   limit: 255
    t.integer  "sp_hcz_id",   limit: 4
    t.string   "spdata_2_1",  limit: 255
    t.string   "gjjg",        limit: 255
    t.string   "jgdw",        limit: 255
    t.string   "fjjl",        limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "wtyp_czb_id", limit: 4
  end

  create_table "sp_logs", force: :cascade do |t|
    t.integer  "sp_bsb_id",  limit: 4
    t.integer  "sp_i_state", limit: 4
    t.string   "remark",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id",    limit: 4
  end

  create_table "sp_production_infos", force: :cascade do |t|
    t.string   "scbh",       limit: 255
    t.string   "cpmc",       limit: 255
    t.string   "fzdw",       limit: 255
    t.date     "fzrq"
    t.string   "jyfs",       limit: 255
    t.string   "qymc",       limit: 255
    t.string   "scdz",       limit: 255
    t.date     "zsyxq"
    t.string   "zs",         limit: 255
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "spdl",       limit: 255
    t.string   "spyl",       limit: 255
    t.string   "spcyl",      limit: 255
    t.string   "spxl",       limit: 255
    t.string   "sp_s_3",     limit: 255
    t.string   "sp_s_4",     limit: 255
    t.string   "sp_s_5",     limit: 255
    t.integer  "qylx",       limit: 4,   default: 0
  end

  create_table "sp_publications", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.integer  "user_id",      limit: 4
    t.integer  "worker_state", limit: 4
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "pub_type",     limit: 4,   default: -1
  end

  create_table "sp_sort_bsbs", force: :cascade do |t|
    t.string   "sp_sort_name", limit: 255
    t.integer  "sp_sort_num",  limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "sp_sta", id: false, force: :cascade do |t|
    t.string "spdata_0", limit: 255
    t.string "spdata_4", limit: 255
    t.string "spdata_5", limit: 255
    t.string "spdata_6", limit: 255
    t.string "spdata_8", limit: 255
    t.string "sp_s_1",   limit: 255, default: ""
    t.string "sp_s_14",  limit: 255, default: ""
    t.string "sp_s_3",   limit: 255, default: ""
    t.string "sp_s_68",  limit: 60
    t.string "sp_s_17",  limit: 255, default: ""
    t.string "sp_s_20",  limit: 255, default: ""
    t.string "sp_s_62",  limit: 60
    t.string "sp_s_16",  limit: 60
    t.string "sp_s_71",  limit: 60
    t.string "sp_s_65",  limit: 255
    t.date   "sp_d_86"
  end

  create_table "sp_standards", force: :cascade do |t|
    t.string   "sp_sta_0",   limit: 255
    t.string   "sp_sta_1",   limit: 255
    t.string   "sp_sta_2",   limit: 255
    t.string   "sp_sta_3",   limit: 255
    t.string   "sp_sta_4",   limit: 255
    t.string   "sp_sta_5",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "sp_standards", ["sp_sta_1", "sp_sta_0"], name: "in_1", using: :btree

  create_table "sp_statistics", id: false, force: :cascade do |t|
    t.string "spdata_0", limit: 255
    t.string "spdata_4", limit: 255
    t.string "spdata_5", limit: 255
    t.string "spdata_6", limit: 255
    t.string "spdata_8", limit: 255
    t.string "sp_s_1",   limit: 255, default: ""
    t.string "sp_s_14",  limit: 255, default: ""
    t.string "sp_s_3",   limit: 255, default: ""
    t.string "sp_s_68",  limit: 60
    t.string "sp_s_17",  limit: 255, default: ""
    t.string "sp_s_20",  limit: 255, default: ""
    t.string "sp_s_62",  limit: 60
    t.string "sp_s_16",  limit: 60
    t.string "sp_s_71",  limit: 60
    t.string "sp_s_65",  limit: 255
    t.string "sp_sta_5", limit: 255
    t.date   "sp_d_86"
  end

  create_table "sp_yydjb_logs", force: :cascade do |t|
    t.integer  "sp_yydjb_id",    limit: 4
    t.text     "cjbh",           limit: 65535
    t.text     "content",        limit: 65535
    t.integer  "user_id",        limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "sp_yydjb_state", limit: 4
  end

  create_table "sp_yydjb_spdata", force: :cascade do |t|
    t.string   "spdata_0",    limit: 255
    t.string   "spdata_1",    limit: 255
    t.string   "spdata_2",    limit: 255
    t.string   "spdata_3",    limit: 255
    t.string   "spdata_4",    limit: 255
    t.string   "spdata_5",    limit: 255
    t.string   "spdata_6",    limit: 255
    t.string   "spdata_7",    limit: 255
    t.string   "spdata_8",    limit: 255
    t.string   "spdata_9",    limit: 255
    t.integer  "sp_yydjb_id", limit: 4
    t.string   "spdata_10",   limit: 255
    t.string   "spdata_11",   limit: 255
    t.string   "spdata_12",   limit: 255
    t.string   "spdata_13",   limit: 255
    t.string   "spdata_14",   limit: 255
    t.string   "spdata_15",   limit: 255
    t.string   "spdata_16",   limit: 255
    t.string   "spdata_17",   limit: 255
    t.string   "spdata_18",   limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "spdata_2_1",  limit: 255
    t.string   "fjjg",        limit: 255
    t.string   "jgdw",        limit: 255
    t.string   "fjjl",        limit: 255
  end

  create_table "sp_yydjbs", force: :cascade do |t|
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "cjbh",            limit: 60
    t.string   "ypmc",            limit: 60
    t.string   "ypgg",            limit: 60
    t.string   "ypph",            limit: 60
    t.datetime "scrq"
    t.string   "spdl",            limit: 60
    t.string   "spyl",            limit: 60
    t.string   "spcyl",           limit: 60
    t.string   "spxl",            limit: 60
    t.string   "jyjl",            limit: 60
    t.string   "yytcr",           limit: 60
    t.datetime "yytcsj"
    t.datetime "yysdsj"
    t.string   "yyfl",            limit: 60
    t.text     "yynr",            limit: 65535
    t.string   "yyczbm",          limit: 60
    t.string   "yyczfzr",         limit: 60
    t.string   "yyczqk",          limit: 60
    t.string   "yyczzt",          limit: 60
    t.string   "yyczjg",          limit: 255,   default: "异议处置中"
    t.integer  "fjsqqk",          limit: 4,     default: 0
    t.string   "fjzt",            limit: 255,   default: "初检结论"
    t.string   "fjsqr",           limit: 60
    t.datetime "fjsqsj"
    t.datetime "fjslrq"
    t.datetime "fjwcsj"
    t.string   "fjxm",            limit: 60
    t.string   "fjjg",            limit: 60
    t.string   "fjjl",            limit: 60
    t.string   "fjjgou",          limit: 60
    t.string   "bljg",            limit: 60
    t.string   "djbm",            limit: 60
    t.string   "djr",             limit: 60
    t.datetime "djsj"
    t.string   "blbm",            limit: 60
    t.string   "blr",             limit: 60
    t.datetime "blsj"
    t.string   "tbbm",            limit: 60
    t.string   "tbr",             limit: 60
    t.datetime "tbsj"
    t.string   "shbm",            limit: 60
    t.string   "shr",             limit: 60
    t.datetime "shsj"
    t.string   "bcydw",           limit: 60
    t.string   "bcydwsf",         limit: 60
    t.string   "cydw",            limit: 60
    t.string   "cydwsf",          limit: 60
    t.string   "bsscqy",          limit: 60
    t.string   "bsscqysf",        limit: 60
    t.string   "jyxm",            limit: 60
    t.string   "jgpd",            limit: 60
    t.string   "jyjg",            limit: 60
    t.integer  "current_state",   limit: 4
    t.text     "thyy",            limit: 65535
    t.boolean  "dj_delayed",                    default: false
    t.integer  "sp_bsb_id",       limit: 4
    t.date     "gzscqyrq"
    t.date     "gzbcydwrq"
    t.string   "attachment_path", limit: 255
    t.string   "attachments",     limit: 255
  end

  create_table "spdata", force: :cascade do |t|
    t.string   "spdata_0",   limit: 255
    t.string   "spdata_1",   limit: 255
    t.string   "spdata_2",   limit: 255
    t.string   "spdata_3",   limit: 255
    t.string   "spdata_4",   limit: 255
    t.string   "spdata_5",   limit: 255
    t.string   "spdata_6",   limit: 255
    t.string   "spdata_7",   limit: 255
    t.string   "spdata_8",   limit: 255
    t.string   "spdata_9",   limit: 255
    t.integer  "sp_bsb_id",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "spdata_10",  limit: 255
    t.string   "spdata_11",  limit: 255
    t.string   "spdata_12",  limit: 255
    t.string   "spdata_13",  limit: 255
    t.string   "spdata_14",  limit: 255
    t.string   "spdata_15",  limit: 255
    t.string   "spdata_16",  limit: 255
    t.string   "spdata_17",  limit: 255
    t.string   "spdata_18",  limit: 255
  end

  add_index "spdata", ["sp_bsb_id"], name: "index_spdata_on_sp_bsb_id", using: :btree

  create_table "spkj_bsbs", force: :cascade do |t|
    t.string   "sp_s_1",         limit: 60
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "sp_s_2",         limit: 60
    t.string   "sp_s_3",         limit: 60
    t.string   "sp_s_4",         limit: 60
    t.string   "sp_s_5",         limit: 60
    t.string   "sp_s_6",         limit: 60
    t.string   "sp_s_7",         limit: 60
    t.string   "sp_s_8",         limit: 60
    t.string   "sp_s_9",         limit: 60
    t.string   "sp_s_10",        limit: 60
    t.string   "sp_s_11",        limit: 60
    t.string   "sp_s_12",        limit: 60
    t.string   "sp_s_13",        limit: 60
    t.string   "sp_s_14",        limit: 60
    t.decimal  "sp_n_15",                      precision: 10, scale: 2
    t.string   "sp_s_16",        limit: 60
    t.string   "sp_s_17",        limit: 60
    t.string   "sp_s_18",        limit: 60
    t.string   "sp_s_19",        limit: 60
    t.string   "sp_s_20",        limit: 60
    t.string   "sp_s_21",        limit: 60
    t.date     "sp_d_22"
    t.string   "sp_s_23",        limit: 60
    t.string   "sp_s_24",        limit: 60
    t.string   "sp_s_25",        limit: 60
    t.string   "sp_s_26",        limit: 60
    t.string   "sp_s_27",        limit: 60
    t.date     "sp_d_28"
    t.decimal  "sp_n_29",                      precision: 10
    t.string   "sp_s_30",        limit: 60
    t.decimal  "sp_n_31",                      precision: 10
    t.decimal  "sp_n_32",                      precision: 10
    t.string   "sp_s_33",        limit: 60
    t.string   "sp_s_34",        limit: 60
    t.string   "sp_s_35",        limit: 60
    t.string   "sp_s_36",        limit: 60
    t.string   "sp_s_37",        limit: 60
    t.date     "sp_d_38"
    t.string   "sp_s_39",        limit: 60
    t.string   "sp_s_40",        limit: 60
    t.string   "sp_s_41",        limit: 60
    t.string   "sp_s_42",        limit: 60
    t.string   "sp_s_43",        limit: 60
    t.string   "sp_s_44",        limit: 60
    t.string   "sp_s_45",        limit: 60
    t.date     "sp_d_46"
    t.date     "sp_d_47"
    t.string   "sp_s_48",        limit: 60
    t.string   "sp_s_49",        limit: 60
    t.string   "sp_s_50",        limit: 60
    t.string   "sp_s_51",        limit: 60
    t.text     "sp_s_52",        limit: 65535
    t.text     "sp_s_53",        limit: 65535
    t.text     "sp_s_54",        limit: 65535
    t.string   "sp_s_55",        limit: 60
    t.string   "sp_s_56",        limit: 60
    t.string   "sp_s_57",        limit: 60
    t.string   "sp_s_58",        limit: 60
    t.string   "sp_s_59",        limit: 60
    t.string   "sp_s_60",        limit: 60
    t.string   "sp_s_61",        limit: 60
    t.string   "sp_s_62",        limit: 60
    t.string   "sp_s_63",        limit: 60
    t.string   "sp_s_64",        limit: 60
    t.string   "sp_s_65",        limit: 60
    t.string   "sp_s_66",        limit: 60
    t.string   "sp_s_67",        limit: 60
    t.string   "sp_s_68",        limit: 60
    t.string   "sp_s_69",        limit: 60
    t.string   "sp_s_70",        limit: 60
    t.string   "sp_s_71",        limit: 60
    t.string   "sp_s_72",        limit: 60
    t.string   "sp_s_73",        limit: 60
    t.string   "sp_s_74",        limit: 60
    t.string   "sp_s_75",        limit: 60
    t.string   "sp_s_76",        limit: 60
    t.string   "sp_s_77",        limit: 60
    t.string   "sp_s_78",        limit: 60
    t.string   "sp_s_79",        limit: 60
    t.string   "sp_s_80",        limit: 60
    t.string   "sp_s_81",        limit: 60
    t.string   "sp_s_82",        limit: 60
    t.string   "sp_s_83",        limit: 60
    t.string   "sp_s_84",        limit: 60
    t.string   "sp_s_85",        limit: 60
    t.date     "sp_d_86"
    t.string   "sp_s_87",        limit: 60
    t.string   "sp_s_88",        limit: 60
    t.string   "tname",          limit: 60
    t.date     "submit_d_flag"
    t.decimal  "sp_n_jcxcount",                precision: 10
    t.string   "sp_s_bsfl",      limit: 16
    t.string   "sp_s_2_1",       limit: 16
    t.string   "sp_s_18_1",      limit: 16
    t.string   "sp_s_30_1",      limit: 16
    t.string   "sp_s_33_1",      limit: 16
    t.string   "sp_s_140_1",     limit: 16
    t.text     "sp_s_140_2",     limit: 65535
    t.text     "sp_s_140_3",     limit: 65535
    t.string   "sp_s_140_4",     limit: 16
    t.string   "sp_s_140_5",     limit: 16
    t.string   "sp_s_140_6",     limit: 16
    t.string   "sp_s_140_7",     limit: 16
    t.string   "sp_s_140_8",     limit: 16
    t.string   "sp_s_140_9",     limit: 16
    t.text     "sp_s_140_0",     limit: 65535
    t.integer  "sp_i_state",     limit: 4
    t.text     "sp_s_141_0",     limit: 65535
    t.integer  "sp_i_jgback",    limit: 4
    t.text     "sp_s_reason",    limit: 65535
    t.integer  "sp_i_backtimes", limit: 4
    t.string   "sp_s_201",       limit: 255
    t.string   "sp_s_202",       limit: 255
    t.string   "sp_s_203",       limit: 255
    t.string   "sp_s_204",       limit: 255
    t.string   "sp_s_205",       limit: 255
    t.string   "sp_s_206",       limit: 255
    t.string   "sp_s_207",       limit: 255
    t.string   "sp_s_208",       limit: 255
    t.string   "sp_s_209",       limit: 255
    t.string   "sp_s_210",       limit: 255
    t.string   "sp_s_211",       limit: 255
    t.string   "sp_s_212",       limit: 255
    t.string   "sp_s_213",       limit: 255
    t.string   "sp_s_214",       limit: 255
    t.string   "sp_s_215",       limit: 255
  end

  create_table "static_queues", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "user_id",     limit: 4
    t.datetime "finished_at"
    t.text     "msg",         limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "sys_provinces", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "note",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "code",       limit: 255
    t.string   "level",      limit: 20
  end

  create_table "task_jg_bsbs", force: :cascade do |t|
    t.integer  "a_category_id",   limit: 4
    t.integer  "jg_bsb_id",       limit: 4
    t.string   "note",            limit: 255
    t.integer  "quota",           limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "sys_province_id", limit: 4
    t.integer  "b_category_id",   limit: 4
    t.integer  "c_category_id",   limit: 4
    t.integer  "d_category_id",   limit: 4
    t.string   "identifier",      limit: 255
    t.string   "a_category_name", limit: 255
    t.string   "b_category_name", limit: 255
    t.string   "c_category_name", limit: 255
    t.string   "d_category_name", limit: 255
  end

  create_table "task_provinces", force: :cascade do |t|
    t.integer  "sys_province_id", limit: 4
    t.integer  "a_category_id",   limit: 4
    t.integer  "quota",           limit: 4
    t.string   "year",            limit: 255
    t.string   "note",            limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "b_category_id",   limit: 4
    t.integer  "c_category_id",   limit: 4
    t.integer  "d_category_id",   limit: 4
    t.string   "identifier",      limit: 255
    t.string   "a_category_name", limit: 255
    t.string   "b_category_name", limit: 255
    t.string   "c_category_name", limit: 255
    t.string   "d_category_name", limit: 255
  end

  create_table "testers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "prov",       limit: 255
    t.string   "city",       limit: 255
    t.string   "country",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "user_locations", force: :cascade do |t|
    t.string   "device_uuid", limit: 255
    t.string   "gps",         limit: 255
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "hashed_password",        limit: 255
    t.string   "salt",                   limit: 255
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "tname",                  limit: 30
    t.string   "tel",                    limit: 255
    t.string   "eaddress",               limit: 255
    t.string   "company",                limit: 255
    t.string   "user_s_province",        limit: 32
    t.integer  "user_d_authority",       limit: 4
    t.integer  "user_d_authority_1",     limit: 4
    t.string   "user_jcjg",              limit: 255
    t.string   "user_jcjg_lxr",          limit: 255
    t.string   "user_jcjg_tel",          limit: 255
    t.string   "user_jcjg_mail",         limit: 255
    t.string   "user_cyjg",              limit: 255
    t.string   "user_cyjg_lxr",          limit: 255
    t.string   "user_cyjg_tel",          limit: 255
    t.string   "user_cyjg_mail",         limit: 255
    t.integer  "user_i_js",              limit: 4
    t.integer  "user_i_switch",          limit: 4
    t.integer  "user_i_sp",              limit: 4
    t.integer  "user_i_bjp",             limit: 4
    t.integer  "user_i_hzp",             limit: 4
    t.integer  "user_d_authority_2",     limit: 4
    t.integer  "user_d_authority_3",     limit: 4
    t.integer  "user_d_authority_4",     limit: 4
    t.integer  "user_d_authority_5",     limit: 4
    t.string   "user_s_dl",              limit: 255
    t.integer  "user_i_spys",            limit: 4
    t.integer  "user_i_spss",            limit: 4
    t.integer  "yycz_permission",        limit: 4,     default: 0
    t.integer  "hcz_permission",         limit: 4,     default: 0
    t.integer  "enable_api",             limit: 4,     default: 0
    t.integer  "pad_permission",         limit: 4,     default: 0
    t.string   "device_uuid",            limit: 40
    t.string   "car_sys_id",             limit: 255
    t.string   "user_s_city",            limit: 255
    t.string   "user_s_lcity",           limit: 255
    t.integer  "publication_permission", limit: 4,     default: 0
    t.string   "id_card",                limit: 255
    t.text     "user_sign",              limit: 65535
    t.integer  "jg_bsb_id",              limit: 4
  end

  add_index "users", ["name"], name: "index_name", using: :btree

  create_table "welcome_notices", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.integer  "red",             limit: 4
    t.integer  "top",             limit: 4
    t.string   "attachment_path", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "url",             limit: 255
  end

  create_table "wtyp_czb_part_logs", force: :cascade do |t|
    t.integer  "user_id",          limit: 4
    t.string   "content",          limit: 255
    t.integer  "wtyp_czb_part_id", limit: 4
    t.integer  "wtyp_czb_state",   limit: 4
    t.integer  "wtyp_czb_type",    limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "sp_bsb_id",        limit: 4
  end

  create_table "wtyp_czb_parts", force: :cascade do |t|
    t.integer  "wtyp_czb_id",         limit: 4
    t.string   "wtyp_jg",             limit: 255
    t.string   "wtyp_contacts",       limit: 255
    t.string   "wtyp_tel",            limit: 255
    t.string   "wtyp_fax",            limit: 255
    t.string   "wtyp_email",          limit: 255
    t.string   "wtyp_verify",         limit: 255
    t.string   "wtyp_state",          limit: 255
    t.date     "wtyp_date"
    t.text     "wtyp_deal_way",       limit: 65535
    t.text     "wtyp_deal_detail",    limit: 65535
    t.string   "wtyp_deal_jg",        limit: 255
    t.text     "wtyp_remark",         limit: 65535
    t.integer  "sp_bsb_id",           limit: 4
    t.string   "wtyp_no",             limit: 255
    t.string   "wtyp_fjstate",        limit: 255
    t.string   "wtyp_deal_segment",   limit: 255
    t.string   "wtyp_deal_affirm",    limit: 255
    t.text     "wtyp_deal_site",      limit: 65535
    t.text     "wtyp_deal_result",    limit: 65535
    t.string   "wtyp_deal_fix1way",   limit: 255
    t.string   "wtyp_deal_fix2way",   limit: 255
    t.string   "wtyp_deal_fix3way",   limit: 255
    t.string   "wtyp_result_fix1way", limit: 255
    t.string   "wtyp_result_fix2way", limit: 255
    t.string   "wtyp_result_fix3way", limit: 255
    t.string   "wtyp_result_fix4way", limit: 255
    t.string   "wtyp_result_fix5way", limit: 255
    t.string   "wtyp_result_fix6way", limit: 255
    t.string   "wtyp_result_fix7way", limit: 255
    t.string   "wtyp_result_fix8way", limit: 255
    t.string   "bgsbh",               limit: 60
    t.string   "cydd",                limit: 60
    t.string   "bgfl",                limit: 60
    t.string   "bcydwdz",             limit: 150
    t.string   "bcydw_sheng",         limit: 60
    t.text     "bsscqydz",            limit: 65535
    t.string   "cyjs",                limit: 60
    t.string   "bsscqy_sheng",        limit: 60
    t.string   "jymd",                limit: 60
    t.string   "bsscqy_xian",         limit: 60
    t.string   "yyzt",                limit: 60
    t.string   "yyfl",                limit: 60
    t.string   "yyczjg",              limit: 60
    t.string   "fjzt",                limit: 60
    t.string   "fjsqr",               limit: 60
    t.datetime "fjsqsj"
    t.datetime "fjslrq"
    t.datetime "fjwcsj"
    t.string   "fjxm",                limit: 60
    t.string   "fjjg",                limit: 60
    t.string   "fjjl",                limit: 60
    t.string   "fjjgou",              limit: 60
    t.string   "czbm",                limit: 60
    t.string   "czfzr",               limit: 60
    t.string   "hcczzt",              limit: 60
    t.string   "blzt",                limit: 60
    t.string   "bljg",                limit: 60
    t.string   "blbm",                limit: 60
    t.string   "blr",                 limit: 60
    t.datetime "blsj"
    t.string   "tbbm",                limit: 60
    t.string   "tbr",                 limit: 60
    t.datetime "tbsj"
    t.string   "shbm",                limit: 60
    t.string   "shr",                 limit: 60
    t.datetime "shsj"
    t.integer  "current_state",       limit: 4,     default: -1
    t.integer  "czb_type",            limit: 4,     default: -1
    t.string   "cjbh",                limit: 60
    t.string   "ypmc",                limit: 60
    t.string   "ypgg",                limit: 60
    t.string   "ypph",                limit: 60
    t.string   "jyjl",                limit: 60
    t.string   "bcydwmc",             limit: 60
    t.string   "cydwmc",              limit: 60
    t.string   "cydwsf",              limit: 60
    t.string   "bsscqymc",            limit: 60
    t.datetime "scrq"
    t.string   "yytcr",               limit: 60
    t.datetime "yytcsj"
    t.datetime "yysdsj"
    t.string   "yynr",                limit: 60
    t.string   "djbm",                limit: 60
    t.string   "djr",                 limit: 60
    t.datetime "djsj"
    t.string   "fjsqzk",              limit: 60
    t.string   "yyczqk",              limit: 60
    t.text     "thyy",                limit: 65535
    t.string   "jyjgzt",              limit: 255
    t.date     "qdhcczrq"
    t.date     "czwbrq"
    t.string   "fxpj_1",              limit: 255
    t.string   "fxpj_2",              limit: 255
    t.string   "fxpj_3",              limit: 255
    t.string   "cpkzqk_1",            limit: 255
    t.string   "cpkzqk_2",            limit: 255
    t.string   "cpkzqk_3",            limit: 255
    t.string   "cpkzqk_4",            limit: 255
    t.string   "cpkzqk_5",            limit: 255
    t.string   "cpkzqk_6",            limit: 255
    t.string   "cpkzqk_7",            limit: 255
    t.string   "cpkzqk_8",            limit: 255
    t.string   "cpkzqk_9",            limit: 255
    t.string   "cpkzqk_10",           limit: 255
    t.string   "cpkzqk_11",           limit: 255
    t.string   "cpkzqk_12",           limit: 255
    t.string   "cpkzqk_13",           limit: 255
    t.string   "cpkzqk_14",           limit: 255
    t.string   "cpkzqk_15",           limit: 255
    t.string   "cpkzqk_16",           limit: 255
    t.string   "cpkzqk_17",           limit: 255
    t.string   "cpkzqk_18",           limit: 255
    t.string   "cpkzqk_19",           limit: 255
    t.string   "pczgfc_1",            limit: 255
    t.integer  "pczgfc_2",            limit: 4,     default: 0
    t.string   "pczgfc_3",            limit: 255
    t.date     "pczgfc_4"
    t.date     "pczgfc_5"
    t.text     "pczgfc_6",            limit: 65535
    t.string   "pczgfc_7",            limit: 255
    t.string   "pczgfc_8",            limit: 255
    t.text     "xzcfqk_1",            limit: 65535
    t.text     "xzcfqk_2",            limit: 65535
    t.text     "xzcfqk_3",            limit: 65535
    t.text     "xzcfqk_4",            limit: 65535
    t.text     "xzcfqk_5",            limit: 65535
    t.date     "xzcfqk_6"
    t.text     "xzcfqk_7",            limit: 65535
    t.date     "xzcfqk_8"
    t.text     "xzcfqk_9",            limit: 65535
    t.text     "xzcfqk_10",           limit: 65535
    t.text     "xzcfqk_11",           limit: 65535
    t.text     "xzcfqk_12",           limit: 65535
    t.text     "xzcfqk_13",           limit: 65535
    t.text     "xzcfqk_14",           limit: 65535
    t.text     "xzcfqk_15",           limit: 65535
    t.text     "xzcfqk_16",           limit: 65535
    t.text     "xzcfqk_17",           limit: 65535
    t.text     "xzcfqk_18",           limit: 65535
    t.text     "xzcfqk_19",           limit: 65535
    t.text     "xzcfqk_20",           limit: 65535
    t.date     "xzcfqk_21"
    t.integer  "hccz_type",           limit: 4,     default: -1
    t.text     "pczgfc_9",            limit: 65535
    t.boolean  "part_submit_flag1",                 default: false
    t.boolean  "part_submit_flag2",                 default: false
    t.boolean  "part_submit_flag3",                 default: false
    t.boolean  "part_submit_flag4",                 default: false
    t.integer  "wtyp_czb_type",       limit: 4,     default: 0
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.text     "pczgfc_10",           limit: 65535
    t.date     "fxpj_4"
    t.integer  "pczgfc_17",           limit: 4
    t.integer  "pczgfc_11",           limit: 4
    t.integer  "pczgfc_12",           limit: 4
    t.integer  "pczgfc_13",           limit: 4
    t.integer  "pczgfc_14",           limit: 4
    t.integer  "pczgfc_15",           limit: 4
    t.integer  "pczgfc_16",           limit: 4
    t.string   "cpkzqk_20",           limit: 255
    t.string   "cpkzqk_21",           limit: 255
    t.string   "cpkzqk_22",           limit: 255
    t.string   "cpkzqk_23",           limit: 255
    t.string   "current_state_desc",  limit: 255
  end

  add_index "wtyp_czb_parts", ["cjbh"], name: "index_wtyp_czb_parts_on_cjbh", using: :btree

  create_table "wtyp_czbs", force: :cascade do |t|
    t.string   "wtyp_jg",                limit: 255
    t.string   "wtyp_contacts",          limit: 255
    t.string   "wtyp_tel",               limit: 255
    t.string   "wtyp_fax",               limit: 255
    t.string   "wtyp_email",             limit: 255
    t.string   "wtyp_verify",            limit: 255
    t.string   "wtyp_state",             limit: 255
    t.date     "wtyp_date"
    t.text     "wtyp_deal_way",          limit: 65535
    t.text     "wtyp_deal_detail",       limit: 65535
    t.string   "wtyp_deal_jg",           limit: 255
    t.text     "wtyp_remark",            limit: 65535
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "wtyp_sp_bsbs_id",        limit: 4
    t.string   "wtyp_no",                limit: 255
    t.string   "wtyp_state_sc",          limit: 255
    t.date     "wtyp_date_sc"
    t.string   "wtyp_fjstate",           limit: 255
    t.string   "wtyp_jg_sc",             limit: 255
    t.string   "wtyp_contacts_sc",       limit: 255
    t.string   "wtyp_tel_sc",            limit: 255
    t.string   "wtyp_fax_sc",            limit: 255
    t.string   "wtyp_email_sc",          limit: 255
    t.string   "wtyp_verify_sc",         limit: 255
    t.string   "wtyp_deal_segment",      limit: 255
    t.string   "wtyp_deal_segment_sc",   limit: 255
    t.string   "wtyp_deal_affirm",       limit: 255
    t.string   "wtyp_deal_affirm_sc",    limit: 255
    t.text     "wtyp_deal_site",         limit: 65535
    t.text     "wtyp_deal_result",       limit: 65535
    t.text     "wtyp_deal_way_sc",       limit: 65535
    t.text     "wtyp_deal_detail_sc",    limit: 65535
    t.string   "wtyp_deal_fix1way",      limit: 255
    t.string   "wtyp_deal_fix1way_sc",   limit: 255
    t.string   "wtyp_deal_fix2way",      limit: 255
    t.string   "wtyp_deal_fix2way_sc",   limit: 255
    t.string   "wtyp_deal_fix3way",      limit: 255
    t.string   "wtyp_deal_fix3way_sc",   limit: 255
    t.string   "wtyp_result_fix1way",    limit: 255
    t.string   "wtyp_result_fix1way_sc", limit: 255
    t.string   "wtyp_result_fix2way",    limit: 255
    t.string   "wtyp_result_fix2way_sc", limit: 255
    t.string   "wtyp_result_fix3way",    limit: 255
    t.string   "wtyp_result_fix3way_sc", limit: 255
    t.string   "wtyp_result_fix4way",    limit: 255
    t.string   "wtyp_result_fix4way_sc", limit: 255
    t.string   "wtyp_result_fix5way",    limit: 255
    t.string   "wtyp_result_fix5way_sc", limit: 255
    t.string   "wtyp_result_fix6way",    limit: 255
    t.string   "wtyp_result_fix6way_sc", limit: 255
    t.string   "wtyp_result_fix7way",    limit: 255
    t.string   "wtyp_result_fix7way_sc", limit: 255
    t.string   "wtyp_result_fix8way",    limit: 255
    t.string   "wtyp_result_fix8way_sc", limit: 255
    t.text     "wtyp_deal_site_sc",      limit: 65535
    t.string   "bgsbh",                  limit: 60
    t.string   "cydd",                   limit: 60
    t.string   "bgfl",                   limit: 60
    t.string   "bcydwdz",                limit: 150
    t.string   "bcydw_sheng",            limit: 60
    t.string   "bsscqydz",               limit: 150
    t.string   "cyjs",                   limit: 60
    t.string   "bsscqy_sheng",           limit: 60
    t.string   "jymd",                   limit: 60
    t.string   "bsscqy_xian",            limit: 60
    t.string   "yyzt",                   limit: 60
    t.string   "yyfl",                   limit: 60
    t.string   "yyczjg",                 limit: 60
    t.string   "fjzt",                   limit: 60
    t.string   "fjsqr",                  limit: 60
    t.datetime "fjsqsj"
    t.datetime "fjslrq"
    t.datetime "fjwcsj"
    t.string   "fjxm",                   limit: 60
    t.string   "fjjg",                   limit: 60
    t.string   "fjjl",                   limit: 60
    t.string   "fjjgou",                 limit: 60
    t.string   "czbm",                   limit: 60
    t.string   "czfzr",                  limit: 60
    t.string   "hcczzt",                 limit: 60
    t.string   "blzt",                   limit: 60
    t.string   "bljg",                   limit: 60
    t.string   "blbm",                   limit: 60
    t.string   "blr",                    limit: 60
    t.datetime "blsj"
    t.string   "tbbm",                   limit: 60
    t.string   "tbr",                    limit: 60
    t.datetime "tbsj"
    t.string   "shbm",                   limit: 60
    t.string   "shr",                    limit: 60
    t.datetime "shsj"
    t.string   "cjbh",                   limit: 60
    t.string   "ypmc",                   limit: 60
    t.string   "ypgg",                   limit: 60
    t.string   "ypph",                   limit: 60
    t.string   "jyjl",                   limit: 60
    t.string   "bcydwmc",                limit: 60
    t.string   "cydwmc",                 limit: 60
    t.string   "cydwsf",                 limit: 60
    t.string   "bsscqymc",               limit: 60
    t.datetime "scrq"
  end

  add_index "wtyp_czbs", ["wtyp_sp_bsbs_id"], name: "index_sp_bsbs_id", using: :btree

  create_table "xsbg_tt_data", force: :cascade do |t|
    t.integer  "xsbg_tt_id", limit: 4
    t.integer  "sp_bsb_id",  limit: 4
    t.string   "CJBH",       limit: 255
    t.string   "spdata_0",   limit: 255
    t.string   "spdata_1",   limit: 255
    t.string   "spdata_2",   limit: 255
    t.string   "spdata_3",   limit: 255
    t.string   "spdata_4",   limit: 255
    t.string   "spdata_5",   limit: 255
    t.string   "spdata_6",   limit: 255
    t.string   "spdata_7",   limit: 255
    t.string   "spdata_8",   limit: 255
    t.string   "spdata_9",   limit: 255
    t.string   "spdata_10",  limit: 255
    t.string   "spdata_11",  limit: 255
    t.string   "spdata_12",  limit: 255
    t.string   "spdata_13",  limit: 255
    t.string   "spdata_14",  limit: 255
    t.string   "spdata_15",  limit: 255
    t.string   "spdata_16",  limit: 255
    t.string   "spdata_17",  limit: 255
    t.string   "spdata_18",  limit: 255
    t.integer  "spdata_id",  limit: 4,   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "xsbg_tts", force: :cascade do |t|
    t.string   "GJMC",       limit: 255
    t.string   "CJBH",       limit: 255
    t.integer  "sp_bsb_id",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
