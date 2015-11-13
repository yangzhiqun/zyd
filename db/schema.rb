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

ActiveRecord::Schema.define(version: 20130510144106) do

  create_table "bjp_bsbs", force: :cascade do |t|
    t.string   "bjp_s_1"
    t.string   "bjp_s_2"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bjp_s_6"
    t.string   "bjp_s_7"
    t.string   "bjp_s_8"
    t.string   "bjp_s_9"
    t.string   "bjp_s_10"
    t.string   "bjp_s_11"
    t.string   "bjp_s_12"
    t.string   "bjp_s_13"
    t.string   "bjp_s_14"
    t.string   "bjp_s_15"
    t.string   "bjp_s_16"
    t.string   "bjp_s_17"
    t.string   "bjp_s_18"
    t.string   "bjp_s_19"
    t.string   "bjp_s_20"
    t.string   "bjp_s_21"
    t.string   "bjp_s_22"
    t.date     "bjp_d_21"
    t.string   "bjp_s_3",    limit: 60
    t.string   "bjp_s_4",    limit: 60
    t.string   "bjp_s_5",    limit: 60
    t.string   "bjp_s_23",   limit: 60
    t.decimal  "bjp_n_24"
    t.string   "bjp_s_25",   limit: 60
    t.decimal  "bjp_n_26"
    t.string   "bjp_s_27",   limit: 60
    t.string   "bjp_s_28",   limit: 60
    t.string   "bjp_s_29",   limit: 60
    t.string   "bjp_s_30",   limit: 60
    t.string   "bjp_s_31",   limit: 60
    t.string   "bjp_s_32",   limit: 60
    t.string   "bjp_s_33",   limit: 60
    t.date     "bjp_d_34"
    t.string   "bjp_s_35",   limit: 60
    t.string   "bjp_s_36",   limit: 60
    t.string   "bjp_s_37",   limit: 60
    t.string   "bjp_s_38",   limit: 60
    t.string   "bjp_s_39",   limit: 60
    t.string   "bjp_s_40",   limit: 60
    t.string   "bjp_s_41",   limit: 60
    t.date     "bjp_d_42"
    t.date     "bjp_d_43"
    t.string   "bjp_s_44",   limit: 60
    t.string   "bjp_s_45",   limit: 60
    t.string   "bjp_s_46",   limit: 60
    t.string   "bjp_s_47",   limit: 60
    t.string   "bjp_s_48",   limit: 60
    t.string   "bjp_s_49",   limit: 60
    t.string   "bjp_s_50",   limit: 60
    t.string   "bjp_s_51",   limit: 60
    t.string   "bjp_s_52",   limit: 60
    t.string   "bjp_s_53",   limit: 60
    t.string   "bjp_s_54",   limit: 60
    t.string   "bjp_s_55",   limit: 60
    t.string   "bjp_s_56",   limit: 60
    t.string   "bjp_s_57",   limit: 60
    t.string   "bjp_s_58",   limit: 60
    t.string   "bjp_s_59",   limit: 60
    t.string   "bjp_s_60",   limit: 60
    t.string   "bjp_s_61",   limit: 60
    t.string   "bjp_s_62",   limit: 60
    t.string   "bjp_s_63",   limit: 60
    t.string   "bjp_s_64",   limit: 60
    t.string   "bjp_s_65",   limit: 60
    t.string   "bjp_s_66",   limit: 60
    t.string   "bjp_s_67",   limit: 60
    t.string   "bjp_s_68",   limit: 60
    t.string   "bjp_s_69",   limit: 60
    t.string   "bjp_s_70",   limit: 60
    t.string   "bjp_s_71",   limit: 60
    t.string   "bjp_s_72",   limit: 60
    t.string   "bjp_s_73",   limit: 60
    t.string   "bjp_s_74",   limit: 60
    t.string   "bjp_s_75",   limit: 60
    t.string   "bjp_s_76",   limit: 60
    t.string   "bjp_s_77",   limit: 60
    t.string   "bjp_s_78",   limit: 60
    t.string   "bjp_s_79",   limit: 60
    t.string   "bjp_s_80",   limit: 60
    t.string   "bjp_s_81",   limit: 60
    t.string   "bjp_s_82",   limit: 60
    t.string   "bjp_s_83",   limit: 60
    t.string   "bjp_s_84",   limit: 60
    t.string   "bjp_s_85",   limit: 60
    t.string   "bjp_s_89"
    t.string   "bjp_s_90"
    t.string   "bjp_s_91"
    t.string   "bjp_s_92"
    t.string   "bjp_s_93"
    t.string   "bjp_s_94"
    t.date     "bjp_d_95"
    t.string   "bjp_s_96"
    t.string   "bjp_s_97"
  end

  create_table "hzp_bc_dws", force: :cascade do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dwlxzdy"
  end

  create_table "hzp_ypbs", force: :cascade do |t|
    t.string   "dwname"
    t.string   "ypname"
    t.string   "ypno"
    t.string   "ypflei"
    t.string   "ypleib"
    t.string   "ypleibzdy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mytests", force: :cascade do |t|
    t.string   "name"
    t.string   "age"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: :cascade do |t|
    t.string   "name"
    t.text     "address"
    t.string   "email"
    t.string   "pay_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
