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

ActiveRecord::Schema.define(version: 20170919182900) do

  create_table "a_categories", force: :cascade do |t|
    t.integer  "bgfl_id",    limit: 4
    t.string   "name",       limit: 255
    t.string   "note",       limit: 255
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "identifier", limit: 255
    t.boolean  "enable",                 default: true
    t.datetime "deleted_at"
  end

  add_index "a_categories", ["deleted_at"], name: "index_a_categories_on_deleted_at", using: :btree

  create_table "api_exchange_pools", force: :cascade do |t|
    t.integer  "application_id",     limit: 4,                   null: false
    t.integer  "sp_bsb_id",          limit: 4,                   null: false
    t.boolean  "fetched",                        default: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "attributes_changed", limit: 255
    t.string   "sp_s_16",            limit: 255
  end

  add_index "api_exchange_pools", ["sp_s_16"], name: "index_api_exchange_pools_on_sp_s_16", using: :btree

  create_table "attachments", force: :cascade do |t|
    t.string   "filename",     limit: 255
    t.string   "path",         limit: 255
    t.string   "content_type", limit: 255
    t.string   "md5",          limit: 255
    t.integer  "user_id",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id",    limit: 4
    t.string   "auditable_type",  limit: 255
    t.integer  "associated_id",   limit: 4
    t.string   "associated_type", limit: 255
    t.integer  "user_id",         limit: 4
    t.string   "user_type",       limit: 255
    t.string   "username",        limit: 255
    t.string   "action",          limit: 255
    t.text     "audited_changes", limit: 65535
    t.integer  "version",         limit: 4,     default: 0
    t.string   "comment",         limit: 255
    t.string   "remote_address",  limit: 255
    t.string   "request_uuid",    limit: 255
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "b_categories", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "a_category_id", limit: 4
    t.string   "note",          limit: 255
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "identifier",    limit: 255
    t.boolean  "enable",                    default: true
    t.datetime "deleted_at"
  end

  add_index "b_categories", ["deleted_at"], name: "index_b_categories_on_deleted_at", using: :btree

  create_table "baosong_a_jg_ids", force: :cascade do |t|
    t.integer  "jg_bsb_id",    limit: 4
    t.integer  "baosong_a_id", limit: 4
    t.text     "note",         limit: 65535
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "baosong_as", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "note",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "prov",       limit: 255
    t.string   "rwlylx",     limit: 255
    t.datetime "deleted_at"
    t.string   "sheng",      limit: 10
    t.string   "shi",        limit: 10
    t.string   "xian",       limit: 10
  end

  add_index "baosong_as", ["deleted_at"], name: "index_baosong_as_on_deleted_at", using: :btree

  create_table "baosong_bs", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "note",         limit: 255
    t.integer  "baosong_a_id", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "identifier",   limit: 255
    t.string   "prov",         limit: 255
    t.datetime "deleted_at"
  end

  add_index "baosong_bs", ["deleted_at"], name: "index_baosong_bs_on_deleted_at", using: :btree

  create_table "baosong_mofify_logs", force: :cascade do |t|
    t.integer  "baosong_a_id", limit: 4
    t.integer  "baosong_b_id", limit: 4
    t.string   "identifier",   limit: 255
    t.text     "msg",          limit: 65535
    t.integer  "user_id",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.datetime "deleted_at"
  end

  add_index "c_categories", ["deleted_at"], name: "index_c_categories_on_deleted_at", using: :btree

  create_table "check_items", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.text     "JGDW",          limit: 65535
    t.text     "JYYJ",          limit: 65535
    t.text     "PDYJ",          limit: 65535
    t.text     "BZFFJCX",       limit: 65535
    t.text     "BZFFJCXDW",     limit: 65535
    t.text     "BZZXYXX",       limit: 65535
    t.text     "BZZXYXXDW",     limit: 65535
    t.text     "BZZDYXX",       limit: 65535
    t.text     "BZZDYXXDW",     limit: 65535
    t.integer  "d_category_id", limit: 4
    t.integer  "a_category_id", limit: 4
    t.integer  "b_category_id", limit: 4
    t.integer  "c_category_id", limit: 4
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "identifier",    limit: 255
    t.boolean  "enable",                      default: true
    t.datetime "deleted_at"
    t.text     "JYYJJHB",       limit: 65535
    t.text     "BZ",            limit: 65535
  end

  add_index "check_items", ["deleted_at"], name: "index_check_items_on_deleted_at", using: :btree

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
    t.datetime "deleted_at"
  end

  add_index "d_categories", ["deleted_at"], name: "index_d_categories_on_deleted_at", using: :btree

  create_table "flexcontents", force: :cascade do |t|
    t.string   "flex_field",   limit: 255
    t.string   "flex_name",    limit: 255
    t.string   "flex_id",      limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "flex_sortid",  limit: 4
    t.integer  "flex_groupid", limit: 4
  end

  create_table "jg_bsb_names", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "jg_bsb_id",       limit: 4
    t.string   "note",            limit: 255
    t.integer  "creator_user_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "jg_bsb_names", ["name"], name: "name", unique: true, using: :btree

  create_table "jg_bsb_stamps", force: :cascade do |t|
    t.integer  "jg_bsb_id",  limit: 4
    t.string   "stamp_no",   limit: 255
    t.string   "note",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_path", limit: 255
    t.string   "name",       limit: 255
    t.string   "stamp_type", limit: 10
    t.string   "uuid",       limit: 255
  end

  create_table "jg_bsb_supers", force: :cascade do |t|
    t.integer  "jg_bsb_id",       limit: 4
    t.integer  "super_jg_bsb_id", limit: 4
    t.text     "note",            limit: 65535
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "jg_bsbs", force: :cascade do |t|
    t.string   "jg_name",           limit: 255
    t.string   "jg_address",        limit: 255
    t.string   "jg_leader",         limit: 255
    t.string   "jg_higher_level",   limit: 255
    t.string   "jg_contacts",       limit: 255
    t.string   "jg_tel",            limit: 128
    t.string   "jg_certification",  limit: 255
    t.text     "jg_word_area",      limit: 65535
    t.integer  "jg_sampling",       limit: 4
    t.integer  "jg_detection",      limit: 4
    t.integer  "jg_group",          limit: 4
    t.string   "jg_group_category", limit: 255
    t.integer  "jg_administrion",   limit: 4
    t.integer  "jg_sp_permission",  limit: 4
    t.integer  "jg_bjp_permission", limit: 4
    t.integer  "jg_hzp_permission", limit: 4
    t.integer  "jg_enable",         limit: 4
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "jg_province",       limit: 255
    t.string   "jg_email",          limit: 255
    t.string   "code",              limit: 255
    t.string   "api_ip_address",    limit: 255
    t.string   "gpsname",           limit: 255
    t.string   "gpspassword",       limit: 255
    t.string   "attachment_path",   limit: 255
    t.string   "pdf_sign_rules",    limit: 255
    t.integer  "status",            limit: 4,     default: 0
    t.integer  "sys_province_id",   limit: 4
    t.string   "city",              limit: 50
    t.string   "country",           limit: 50
    t.string   "zipcode",           limit: 255
    t.string   "fax",               limit: 255
    t.integer  "jg_type",           limit: 4
    t.string   "jg_code",           limit: 255
    t.string   "ca_org",            limit: 255
    t.integer  "jgjb",              limit: 4,     default: 0
    t.string   "uuid",              limit: 255
  end

  create_table "login_logs", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "action",     limit: 255
    t.string   "ip",         limit: 255
    t.string   "os",         limit: 255
    t.string   "browser",    limit: 255
    t.string   "brover",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "sessionid",  limit: 255
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

  create_table "pad_ca_signs", force: :cascade do |t|
    t.string   "sp_s_16",       limit: 255
    t.integer  "pad_sp_bsb_id", limit: 4
    t.text     "user_cert",     limit: 65535
    t.text     "orig_data",     limit: 65535
    t.text     "signed_data",   limit: 65535
    t.integer  "user_id",       limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
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
    t.integer  "sp_s_37_user_id",   limit: 4
    t.integer  "user_id",           limit: 4
    t.string   "uid",               limit: 20
    t.string   "sp_s_220",          limit: 10
    t.string   "sp_s_221",          limit: 10
    t.string   "sp_s_222",          limit: 20
    t.datetime "deleted_at"
    t.text     "sp_s_city",         limit: 65535
    t.text     "sp_s_dwwz",         limit: 65535
    t.string   "sp_s_wcmc",         limit: 255
    t.string   "sp_s_wcyyzzh",      limit: 255
    t.string   "sp_s_wcicp",        limit: 255
    t.string   "sp_s_wcsheng",      limit: 255
    t.string   "sp_s_wcshi",        limit: 255
    t.string   "sp_s_wcxian",       limit: 255
    t.string   "sp_s_wcdz",         limit: 255
    t.string   "sp_s_wcwz",         limit: 255
    t.string   "sp_s_wclxr",        limit: 255
    t.string   "sp_s_wctel",        limit: 255
    t.string   "sp_s_wcbh",         limit: 255
  end

  add_index "pad_sp_bsbs", ["deleted_at"], name: "index_pad_sp_bsbs_on_deleted_at", using: :btree
  add_index "pad_sp_bsbs", ["sp_s_1"], name: "index_pad_sp_bsbs_on_sp_s_1", using: :btree

  create_table "pad_sp_logs", force: :cascade do |t|
    t.text     "remark",        limit: 65535
    t.integer  "pad_sp_bsb_id", limit: 4
    t.text     "sp_s_16",       limit: 65535
    t.integer  "sp_i_state",    limit: 4
    t.integer  "user_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "cfda_published_at"
    t.string   "WH",                limit: 256
    t.string   "url",               limit: 2048
    t.string   "pub_method",        limit: 20,   default: "手工录入"
    t.integer  "sp_bsb_id",         limit: 4
  end

  create_table "published_wtyp_czbs", force: :cascade do |t|
    t.integer  "user_id",           limit: 4
    t.integer  "sp_bsb_id",         limit: 4
    t.string   "cjbh",              limit: 255
    t.date     "cfda_published_at"
    t.string   "WH",                limit: 255
    t.string   "url",               limit: 255
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "wtyp_czb_type",     limit: 4
    t.string   "pub_method",        limit: 20,  default: "手工录入"
    t.integer  "wtyp_czb_part_id",  limit: 4
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
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "sms_logs", force: :cascade do |t|
    t.string   "sms_template_code", limit: 255
    t.string   "sms_type",          limit: 255
    t.string   "mobile",            limit: 255
    t.string   "msg",               limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.datetime "used_at"
  end

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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sp_bsb_info_publications", force: :cascade do |t|
    t.string   "cjbh",            limit: 255
    t.integer  "sjid",            limit: 4
    t.string   "bcscqymc",        limit: 255
    t.string   "bcscqydz",        limit: 255
    t.string   "bcydwmc",         limit: 255
    t.string   "bcydwdz",         limit: 255
    t.string   "bcydwsf",         limit: 255
    t.string   "spmc",            limit: 255
    t.string   "ggxh",            limit: 255
    t.string   "sb",              limit: 255
    t.date     "scrq"
    t.string   "bhgxm",           limit: 255
    t.string   "fl",              limit: 255
    t.string   "ggh",             limit: 255
    t.date     "ggrq"
    t.string   "rwly",            limit: 255
    t.string   "bz",              limit: 255
    t.string   "jyjg",            limit: 255
    t.string   "sfhg",            limit: 255
    t.integer  "userid",          limit: 4
    t.string   "user_s_province", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bcydwshi",        limit: 255
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
    t.string   "sp_s_4",                   limit: 50
    t.string   "sp_s_5",                   limit: 50
    t.string   "sp_s_6",                   limit: 60
    t.text     "sp_s_7",                   limit: 65535
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
    t.boolean  "via_api",                                               default: false
    t.integer  "application_id",           limit: 4
    t.string   "report_path",              limit: 255
    t.string   "cyd_file_path",            limit: 255
    t.string   "cyjygzs_file_path",        limit: 255
    t.datetime "yydj_enabled_by_admin_at"
    t.datetime "synced_at"
    t.string   "czb_reverted_reason",      limit: 255
    t.string   "sp_s_220",                 limit: 50
    t.string   "sp_s_221",                 limit: 50
    t.string   "sp_s_222",                 limit: 60
    t.integer  "user_id",                  limit: 4
    t.string   "uid",                      limit: 20
    t.integer  "sp_s_37_user_id",          limit: 4
    t.datetime "deleted_at"
    t.string   "xsbg_file_path",           limit: 256
    t.integer  "ca_key_status",            limit: 4,                    default: 0
    t.text     "sp_s_city",                limit: 65535
    t.text     "inspection_basis",         limit: 65535
    t.text     "decision_basis",           limit: 65535
    t.datetime "sign_date"
    t.string   "sp_s_89",                  limit: 255
    t.text     "FX_jyyj_custom",           limit: 65535
    t.string   "JDCJ_report_path",         limit: 200
    t.string   "FXJC_report_path",         limit: 200
    t.string   "JDCJ_pdf_rules",           limit: 200
    t.string   "FXJC_pdf_rules",           limit: 200
    t.integer  "wochacha_task_id",         limit: 4
    t.string   "sp_s_sfjk",                limit: 32
    t.string   "sp_s_ycg",                 limit: 32
    t.string   "sp_s_sfwtsc",              limit: 32
    t.string   "sp_s_wtsheng",             limit: 32
    t.string   "sp_s_wtshi",               limit: 32
    t.string   "sp_s_wtxian",              limit: 32
    t.string   "sp_s_qymc",                limit: 255
    t.string   "sp_s_qydz",                limit: 255
    t.string   "sp_s_qs",                  limit: 32
    t.string   "sp_s_lxr",                 limit: 32
    t.string   "sp_s_tel",                 limit: 32
    t.text     "sp_s_pic",                 limit: 65535
    t.text     "sp_s_sign",                limit: 65535
    t.string   "health_code",              limit: 255
    t.text     "health_func_cat",          limit: 65535
    t.string   "barcode",                  limit: 13
    t.string   "rainbowcode",              limit: 12
    t.string   "rainbowcode_url",          limit: 255
    t.text     "sp_s_dwwz",                limit: 65535
    t.string   "sp_s_wcmc",                limit: 255
    t.string   "sp_s_wcyyzzh",             limit: 255
    t.string   "sp_s_wcicp",               limit: 255
    t.string   "sp_s_wcsheng",             limit: 255
    t.string   "sp_s_wcshi",               limit: 255
    t.string   "sp_s_wcxian",              limit: 255
    t.string   "sp_s_wcdz",                limit: 255
    t.string   "sp_s_wcwz",                limit: 255
    t.string   "sp_s_wclxr",               limit: 255
    t.string   "sp_s_wctel",               limit: 255
    t.string   "sp_s_wcbh",                limit: 255
    t.string   "sp_proid",                 limit: 255
  end

  add_index "sp_bsbs", ["application_id"], name: "index_sp_bsbs_on_application_id", using: :btree
  add_index "sp_bsbs", ["deleted_at"], name: "index_sp_bsbs_on_deleted_at", using: :btree
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
  add_index "sp_bsbs", ["uid"], name: "index_sp_bsbs_on_uid", using: :btree
  add_index "sp_bsbs", ["updated_at"], name: "update_desc", using: :btree
  add_index "sp_bsbs", ["user_id"], name: "index_sp_bsbs_on_user_id", using: :btree
  add_index "sp_bsbs", ["via_api"], name: "index_sp_bsbs_on_via_api", using: :btree

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
    t.integer  "sp_bsb_id",     limit: 4
    t.integer  "sp_i_state",    limit: 4
    t.string   "remark",        limit: 255
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "user_id",       limit: 4
    t.integer  "ca_key_status", limit: 4,   default: 0
    t.datetime "deleted_at"
  end

  add_index "sp_logs", ["deleted_at"], name: "index_sp_logs_on_deleted_at", using: :btree

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
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "spdl",       limit: 255
    t.string   "spyl",       limit: 255
    t.string   "spcyl",      limit: 255
    t.string   "spxl",       limit: 255
    t.string   "sp_s_3",     limit: 255
    t.string   "sp_s_4",     limit: 255
    t.string   "sp_s_5",     limit: 255
    t.integer  "qylx",       limit: 4,   default: 0
    t.string   "jieduan",    limit: 20
    t.boolean  "benji_only",             default: false
    t.string   "sp_proid",   limit: 255
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
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "djr_user_id",     limit: 4
    t.integer  "blr_user_id",     limit: 4
    t.integer  "tbr_user_id",     limit: 4
    t.integer  "shr_user_id",     limit: 4
    t.string   "bcydws",          limit: 255
    t.string   "bsscqys",         limit: 255
  end

  create_table "spdata", force: :cascade do |t|
    t.string   "spdata_0",      limit: 255
    t.string   "spdata_1",      limit: 255
    t.string   "spdata_2",      limit: 255
    t.string   "spdata_3",      limit: 255
    t.string   "spdata_4",      limit: 255
    t.string   "spdata_5",      limit: 255
    t.string   "spdata_6",      limit: 255
    t.string   "spdata_7",      limit: 255
    t.string   "spdata_8",      limit: 255
    t.string   "spdata_9",      limit: 255
    t.integer  "sp_bsb_id",     limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "spdata_10",     limit: 255
    t.string   "spdata_11",     limit: 255
    t.string   "spdata_12",     limit: 255
    t.string   "spdata_13",     limit: 255
    t.string   "spdata_14",     limit: 255
    t.string   "spdata_15",     limit: 255
    t.string   "spdata_16",     limit: 255
    t.string   "spdata_17",     limit: 255
    t.string   "spdata_18",     limit: 255
    t.text     "spdata_19",     limit: 65535
    t.text     "spdata_20",     limit: 65535
    t.integer  "check_item_id", limit: 4
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

  create_table "standard_a_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "note",       limit: 255
    t.string   "identifier", limit: 255
    t.boolean  "enable"
    t.datetime "deleted_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "standard_b_categories", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.integer  "standard_a_category_id", limit: 4
    t.string   "note",                   limit: 255
    t.string   "identifier",             limit: 255
    t.boolean  "enable"
    t.datetime "deleted_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "standard_c_categories", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.integer  "standard_a_category_id", limit: 4
    t.integer  "standard_b_category_id", limit: 4
    t.string   "note",                   limit: 255
    t.string   "identifier",             limit: 255
    t.boolean  "enable"
    t.datetime "deleted_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "standard_check_items", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "JGDW",                   limit: 255
    t.string   "JYYJ",                   limit: 255
    t.string   "PDYJ",                   limit: 255
    t.string   "BZFFJCX",                limit: 255
    t.string   "BZFFJCXDW",              limit: 255
    t.string   "BZZXYXX",                limit: 255
    t.string   "BZZXYXXDW",              limit: 255
    t.string   "BZZDYXX",                limit: 255
    t.string   "BZZDYXXDW",              limit: 255
    t.integer  "standard_a_category_id", limit: 4
    t.integer  "standard_b_category_id", limit: 4
    t.integer  "standard_c_category_id", limit: 4
    t.integer  "standard_d_category_id", limit: 4
    t.string   "identifier",             limit: 255
    t.boolean  "enable"
    t.datetime "deleted_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "standard_d_categories", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.integer  "standard_a_category_id", limit: 4
    t.integer  "standard_b_category_id", limit: 4
    t.integer  "standard_c_category_id", limit: 4
    t.string   "note",                   limit: 255
    t.string   "identifier",             limit: 255
    t.boolean  "enable"
    t.datetime "deleted_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "static_queues", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "user_id",     limit: 4
    t.datetime "finished_at"
    t.text     "msg",         limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "sys_configs", force: :cascade do |t|
    t.string   "key",        limit: 255
    t.text     "value",      limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "sys_provinces", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "level",      limit: 20
    t.string   "note",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "code",       limit: 255
    t.string   "fullname",   limit: 255
  end

  add_index "sys_provinces", ["level"], name: "level_s", using: :btree
  add_index "sys_provinces", ["name"], name: "name_s", using: :btree

  create_table "task_jg_bsbs", force: :cascade do |t|
    t.integer  "a_category_id",   limit: 4
    t.integer  "jg_bsb_id",       limit: 4
    t.string   "note",            limit: 255
    t.integer  "quota",           limit: 4
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "sys_province_id", limit: 4
    t.integer  "b_category_id",   limit: 4
    t.integer  "c_category_id",   limit: 4
    t.integer  "d_category_id",   limit: 4
    t.string   "identifier",      limit: 255
    t.string   "a_category_name", limit: 255
    t.string   "b_category_name", limit: 255
    t.string   "c_category_name", limit: 255
    t.string   "d_category_name", limit: 255
    t.integer  "test_jg_bsb_id",  limit: 4
    t.boolean  "is_national",                 default: false
    t.integer  "city_id",         limit: 4,   default: 0
    t.integer  "country_id",      limit: 4,   default: 0
  end

  create_table "task_provinces", force: :cascade do |t|
    t.integer  "sys_province_id", limit: 4
    t.integer  "a_category_id",   limit: 4
    t.integer  "quota",           limit: 4
    t.string   "year",            limit: 255
    t.string   "note",            limit: 255
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "b_category_id",   limit: 4
    t.integer  "c_category_id",   limit: 4
    t.integer  "d_category_id",   limit: 4
    t.string   "identifier",      limit: 255
    t.string   "a_category_name", limit: 255
    t.string   "b_category_name", limit: 255
    t.string   "c_category_name", limit: 255
    t.string   "d_category_name", limit: 255
    t.integer  "status",          limit: 4,   default: 0
  end

  create_table "tmp_sp_bsbs", force: :cascade do |t|
    t.integer  "sp_i_state",        limit: 4
    t.string   "sp_s_16",           limit: 255
    t.string   "sp_s_3",            limit: 255
    t.string   "sp_s_202",          limit: 255
    t.string   "sp_s_14",           limit: 255
    t.string   "sp_s_43",           limit: 255
    t.string   "sp_s_2_1",          limit: 255
    t.string   "sp_s_35",           limit: 255
    t.string   "sp_s_64",           limit: 255
    t.string   "sp_s_1",            limit: 255
    t.string   "sp_s_17",           limit: 255
    t.string   "sp_s_20",           limit: 255
    t.string   "sp_s_85",           limit: 255
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "sp_s_214",          limit: 255
    t.string   "sp_s_71",           limit: 255
    t.string   "fail_report_path",  limit: 255
    t.string   "tname",             limit: 255
    t.string   "sp_s_18",           limit: 255
    t.string   "sp_s_70",           limit: 255
    t.string   "sp_s_215",          limit: 255
    t.string   "sp_s_68",           limit: 255
    t.string   "sp_s_13",           limit: 255
    t.string   "sp_s_27",           limit: 255
    t.boolean  "czb_reverted_flag"
    t.integer  "user_id",           limit: 4
    t.string   "uid",               limit: 20
    t.text     "sp_s_reason",       limit: 65535
    t.string   "sp_s_2",            limit: 255
    t.datetime "deleted_at"
    t.date     "sp_d_38"
    t.date     "sp_d_28"
  end

  add_index "tmp_sp_bsbs", ["sp_i_state"], name: "index_tmp_sp_bsbs_on_sp_i_state", using: :btree
  add_index "tmp_sp_bsbs", ["sp_s_1"], name: "index_tmp_sp_bsbs_on_sp_s_1", using: :btree
  add_index "tmp_sp_bsbs", ["sp_s_13", "sp_i_state", "created_at"], name: "13_state_created_at", using: :btree
  add_index "tmp_sp_bsbs", ["sp_s_13", "sp_s_14", "sp_s_27", "sp_i_state", "created_at"], name: "14_27_state_created_at", using: :btree
  add_index "tmp_sp_bsbs", ["sp_s_14"], name: "index_tmp_sp_bsbs_on_sp_s_14", using: :btree
  add_index "tmp_sp_bsbs", ["sp_s_16"], name: "index_tmp_sp_bsbs_on_sp_s_16", using: :btree
  add_index "tmp_sp_bsbs", ["sp_s_17"], name: "index_tmp_sp_bsbs_on_sp_s_17", using: :btree
  add_index "tmp_sp_bsbs", ["sp_s_20"], name: "index_tmp_sp_bsbs_on_sp_s_20", using: :btree
  add_index "tmp_sp_bsbs", ["sp_s_202"], name: "index_tmp_sp_bsbs_on_sp_s_202", using: :btree
  add_index "tmp_sp_bsbs", ["sp_s_214"], name: "index_tmp_sp_bsbs_on_sp_s_214", using: :btree
  add_index "tmp_sp_bsbs", ["sp_s_215", "sp_s_68", "created_at", "sp_i_state"], name: "215_68_created_at_state", using: :btree
  add_index "tmp_sp_bsbs", ["sp_s_2_1"], name: "index_tmp_sp_bsbs_on_sp_s_2_1", using: :btree
  add_index "tmp_sp_bsbs", ["sp_s_3"], name: "index_tmp_sp_bsbs_on_sp_s_3", using: :btree
  add_index "tmp_sp_bsbs", ["sp_s_35"], name: "index_tmp_sp_bsbs_on_sp_s_35", using: :btree
  add_index "tmp_sp_bsbs", ["sp_s_43"], name: "index_tmp_sp_bsbs_on_sp_s_43", using: :btree
  add_index "tmp_sp_bsbs", ["sp_s_64"], name: "index_tmp_sp_bsbs_on_sp_s_64", using: :btree
  add_index "tmp_sp_bsbs", ["sp_s_71"], name: "index_tmp_sp_bsbs_on_sp_s_71", using: :btree
  add_index "tmp_sp_bsbs", ["sp_s_85"], name: "index_tmp_sp_bsbs_on_sp_s_85", using: :btree
  add_index "tmp_sp_bsbs", ["updated_at", "sp_i_state"], name: "index_tmp_sp_bsbs_on_updated_at_and_sp_i_state", using: :btree
  add_index "tmp_sp_bsbs", ["updated_at"], name: "index_tmp_sp_bsbs_on_updated_at", using: :btree

  create_table "user_audit_logs", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "operator_id", limit: 4
    t.integer  "action",      limit: 4
    t.string   "msg",         limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
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
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.string   "tname",                  limit: 30
    t.string   "tel",                    limit: 255
    t.string   "eaddress",               limit: 255
    t.string   "company",                limit: 255
    t.string   "user_s_province",        limit: 32
    t.integer  "user_d_authority",       limit: 4,     default: 0
    t.integer  "user_d_authority_1",     limit: 4
    t.string   "user_jcjg",              limit: 255
    t.string   "user_jcjg_lxr",          limit: 255
    t.string   "user_jcjg_tel",          limit: 255
    t.string   "user_jcjg_mail",         limit: 255
    t.string   "user_cyjg",              limit: 255
    t.string   "user_cyjg_lxr",          limit: 255
    t.string   "user_cyjg_tel",          limit: 255
    t.string   "user_cyjg_mail",         limit: 255
    t.integer  "user_i_js",              limit: 4,     default: 0
    t.integer  "user_i_switch",          limit: 4,     default: 0
    t.integer  "user_i_sp",              limit: 4,     default: 0
    t.integer  "user_i_bjp",             limit: 4
    t.integer  "user_i_hzp",             limit: 4
    t.integer  "user_d_authority_2",     limit: 4,     default: 0
    t.integer  "user_d_authority_3",     limit: 4,     default: 0
    t.integer  "user_d_authority_4",     limit: 4,     default: 0
    t.integer  "user_d_authority_5",     limit: 4,     default: 0
    t.string   "user_s_dl",              limit: 255
    t.integer  "user_i_spys",            limit: 4,     default: 0
    t.integer  "user_i_spss",            limit: 4,     default: 0
    t.integer  "yycz_permission",        limit: 4,     default: 0
    t.integer  "hcz_permission",         limit: 4,     default: 0
    t.integer  "enable_api",             limit: 4,     default: 0
    t.integer  "pad_permission",         limit: 4,     default: 0
    t.string   "device_uuid",            limit: 40
    t.string   "car_sys_id",             limit: 255
    t.string   "user_s_city",            limit: 255
    t.string   "user_s_lcity",           limit: 255
    t.integer  "publication_permission", limit: 4,     default: 0
    t.string   "email",                  limit: 255,   default: "",    null: false
    t.string   "encrypted_password",     limit: 255,   default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "id_card",                limit: 255
    t.text     "user_sign",              limit: 65535
    t.integer  "jg_bsb_id",              limit: 4
    t.integer  "sign_in_count",          limit: 4,     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "uid",                    limit: 255,                   null: false
    t.string   "mobile",                 limit: 255
    t.string   "function_type",          limit: 128,   default: "-1"
    t.string   "prov_city",              limit: 50
    t.string   "prov_country",           limit: 50
    t.datetime "enabled_at"
    t.boolean  "is_account_manager",                   default: false
    t.datetime "apply_refused_at"
    t.integer  "state",                  limit: 4,     default: 0
    t.integer  "jg_type",                limit: 4,     default: 0
    t.integer  "hccz_level",             limit: 4,     default: 0
    t.integer  "hccz_type",              limit: 4,     default: 0
    t.string   "ca_uuid",                limit: 50
    t.integer  "ca_user_status",         limit: 4
    t.string   "user_code",              limit: 255
    t.integer  "jbxx_sh",                limit: 4,     default: 0
    t.integer  "admin_level",            limit: 4,     default: 0
    t.string   "unique_session_id",      limit: 20
    t.string   "ca_login",               limit: 50
  end

  add_index "users", ["name"], name: "index_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "welcome_notices", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.integer  "red",             limit: 4
    t.integer  "top",             limit: 4
    t.string   "attachment_path", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "bsscqy_xian",         limit: 50
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
    t.string   "cpkzqk_1",            limit: 100
    t.string   "cpkzqk_2",            limit: 100
    t.string   "cpkzqk_3",            limit: 100
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
    t.text     "xzcfqk_1",            limit: 255
    t.text     "xzcfqk_2",            limit: 255
    t.text     "xzcfqk_3",            limit: 255
    t.text     "xzcfqk_4",            limit: 255
    t.text     "xzcfqk_5",            limit: 255
    t.date     "xzcfqk_6"
    t.text     "xzcfqk_7",            limit: 255
    t.date     "xzcfqk_8"
    t.text     "xzcfqk_9",            limit: 255
    t.text     "xzcfqk_10",           limit: 255
    t.text     "xzcfqk_11",           limit: 255
    t.text     "xzcfqk_12",           limit: 255
    t.text     "xzcfqk_13",           limit: 255
    t.text     "xzcfqk_14",           limit: 255
    t.text     "xzcfqk_15",           limit: 255
    t.text     "xzcfqk_16",           limit: 255
    t.text     "xzcfqk_17",           limit: 255
    t.text     "xzcfqk_18",           limit: 255
    t.text     "xzcfqk_19",           limit: 255
    t.text     "xzcfqk_20",           limit: 255
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
    t.integer  "blr_user_id",         limit: 4
    t.integer  "tbr_user_id",         limit: 4
    t.integer  "shr_user_id",         limit: 4
    t.string   "sp_s_4",              limit: 50
    t.string   "sp_s_5",              limit: 50
    t.string   "sp_s_220",            limit: 50
    t.string   "sp_s_221",            limit: 50
    t.string   "SPDL",                limit: 255
    t.string   "SPYL",                limit: 255
    t.string   "SPCYL",               limit: 255
    t.string   "SPXL",                limit: 255
    t.string   "xc_attachment_path",  limit: 100
    t.string   "pc_attachment_path",  limit: 100
    t.string   "xz_attachment_path",  limit: 100
    t.date     "qdqk_sdrq"
    t.string   "qdqk_sfjs",           limit: 60
    t.text     "cpkzqk_wzhyy",        limit: 65535
    t.string   "cpkzqk_sfdw",         limit: 60
    t.string   "cpkzqk_sfhl",         limit: 60
    t.string   "yypc_zsylly",         limit: 60
    t.text     "yypc_bhgscz",         limit: 65535
    t.text     "yypc_wzcyy",          limit: 65535
    t.string   "yypc_sfhl",           limit: 60
    t.text     "xzcf_rdyj",           limit: 65535
    t.string   "xzcf_yjsfsd",         limit: 60
    t.string   "xzcf_cssfsd",         limit: 60
    t.text     "xzcf_wlayy",          limit: 65535
    t.text     "xzcf_wcfyy",          limit: 65535
    t.string   "xzcf_blasfhl",        limit: 60
    t.string   "zgfc_sftjbg",         limit: 60
    t.string   "zgfc_jgbmyj",         limit: 60
    t.string   "zgfc_zgsfhl",         limit: 60
    t.string   "tbys_tbqtbm",         limit: 60
    t.string   "tbys_xzbmmc",         limit: 255
    t.string   "tbys_sfjgmc",         limit: 255
    t.string   "tbys_sfla",           limit: 60
    t.string   "tbys_sftbys",         limit: 60
    t.string   "bcydw_shi",           limit: 50
    t.string   "bcydw_xian",          limit: 50
    t.string   "bsscqy_shi",          limit: 50
    t.string   "cpkzqk_kc",           limit: 255
    t.string   "cpkzqk_zj",           limit: 255
    t.date     "zgfc_fcrq"
    t.string   "tbys_sfsfys",         limit: 60
    t.string   "tbr_dh",              limit: 255
    t.string   "tbr_cz",              limit: 255
    t.string   "shr_dh",              limit: 255
    t.string   "shr_cz",              limit: 255
    t.string   "cpkzqk_kcdw",         limit: 60
    t.integer  "yypc_yylbsc",         limit: 4
    t.integer  "yypc_yylbys",         limit: 4
    t.integer  "yypc_yylbxs",         limit: 4
    t.integer  "wtyp_dbtype",         limit: 4
    t.string   "qd_attachment_path",  limit: 100
    t.boolean  "part_submit_flag5",                 default: false
    t.boolean  "part_submit_flag6",                 default: false
    t.boolean  "part_submit_flag7",                 default: false
    t.string   "wc_sheng",            limit: 60
    t.string   "wc_shi",              limit: 60
    t.string   "wc_xian",             limit: 60
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
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
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
    t.string   "bsscqy_xian",            limit: 50
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
    t.string   "sp_s_4",                 limit: 50
    t.string   "sp_s_5",                 limit: 50
    t.string   "sp_s_220",               limit: 50
    t.string   "sp_s_221",               limit: 50
    t.string   "SPDL",                   limit: 255
    t.string   "SPYL",                   limit: 255
    t.string   "SPCYL",                  limit: 255
    t.string   "SPXL",                   limit: 255
    t.string   "bcydw_shi",              limit: 50
    t.string   "bcydw_xian",             limit: 50
    t.string   "bsscqy_shi",             limit: 50
    t.boolean  "part_submit_flag5",                    default: false
    t.boolean  "part_submit_flag6",                    default: false
    t.boolean  "part_submit_flag7",                    default: false
    t.string   "wc_sheng",               limit: 255
    t.string   "wc_shi",                 limit: 255
    t.string   "wc_xian",                limit: 255
  end

  add_index "wtyp_czbs", ["bsscqymc"], name: "index_wtyp_czbs_on_bsscqymc", using: :btree
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "xsbg_tts", force: :cascade do |t|
    t.string   "GJMC",       limit: 255
    t.string   "CJBH",       limit: 255
    t.integer  "sp_bsb_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_trigger("sp_bsbs_after_delete_row_tr", :generated => true, :compatibility => 1).
      on("sp_bsbs").
      after(:delete) do
    "DELETE FROM tmp_sp_bsbs where id=OLD.id;"
  end

  create_trigger("sp_bsbs_after_insert_row_tr", :generated => true, :compatibility => 1).
      on("sp_bsbs").
      after(:insert) do
    "INSERT INTO tmp_sp_bsbs(sp_s_reason, id, sp_i_state, sp_s_16, sp_s_3, sp_s_202, sp_s_14, sp_s_43, sp_s_2_1, sp_s_35, sp_s_64, sp_s_1, sp_s_17, sp_s_20, sp_s_85, created_at, updated_at, sp_s_214, sp_s_71, fail_report_path, tname, user_id, uid, sp_s_18, sp_s_70, sp_s_215, sp_s_68, sp_s_13, sp_s_27, czb_reverted_flag) values(NEW.sp_s_reason, NEW.id, NEW.sp_i_state, NEW.sp_s_16, NEW.sp_s_3, NEW.sp_s_202, NEW.sp_s_14, NEW.sp_s_43, NEW.sp_s_2_1, NEW.sp_s_35, NEW.sp_s_64, NEW.sp_s_1, NEW.sp_s_17, NEW.sp_s_20, NEW.sp_s_85, NEW.created_at, NEW.updated_at, NEW.sp_s_214, NEW.sp_s_71, NEW.fail_report_path, NEW.tname, NEW.user_id, NEW.uid, NEW.sp_s_18, NEW.sp_s_70, NEW.sp_s_215, NEW.sp_s_68, NEW.sp_s_13, NEW.sp_s_27, NEW.czb_reverted_flag);"
  end

  create_trigger("sp_bsbs_after_update_of_updated_at_sp_i_state_row_tr", :generated => true, :compatibility => 1).
      on("sp_bsbs").
      after(:update).
      of(:updated_at, :sp_i_state) do
    "UPDATE tmp_sp_bsbs SET sp_s_reason=NEW.sp_s_reason, sp_i_state=NEW.sp_i_state, sp_s_16=NEW.sp_s_16, sp_s_3=NEW.sp_s_3, sp_s_202=NEW.sp_s_202, sp_s_14=NEW.sp_s_14, sp_s_43=NEW.sp_s_43, sp_s_2_1=NEW.sp_s_2_1, sp_s_35=NEW.sp_s_35, sp_s_64=NEW.sp_s_64, sp_s_1=NEW.sp_s_1, sp_s_17=NEW.sp_s_17, sp_s_20=NEW.sp_s_20, sp_s_85=NEW.sp_s_85, created_at=NEW.created_at, updated_at=NEW.updated_at, sp_s_214=NEW.sp_s_214, sp_s_71=NEW.sp_s_71, fail_report_path=NEW.fail_report_path, tname=NEW.tname, user_id=NEW.user_id, uid=NEW.uid, sp_s_18=NEW.sp_s_18, sp_s_70=NEW.sp_s_70, sp_s_215=NEW.sp_s_215, sp_s_68=NEW.sp_s_68, sp_s_13=NEW.sp_s_13, sp_s_27=NEW.sp_s_27, czb_reverted_flag=NEW.czb_reverted_flag where id=NEW.id;"
  end

end
