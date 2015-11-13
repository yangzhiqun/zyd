class CreateWtypCzbParts < ActiveRecord::Migration
  def change
    create_table :wtyp_czb_parts do |t|
      t.integer  :wtyp_czb_id
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
			t.integer  "sp_bsbs_id"
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
			t.string   "bgsbh",                  :limit => 60
			t.string   "cydd",                   :limit => 60
			t.string   "bgfl",                   :limit => 60
			t.string   "bcydwdz",                :limit => 60
			t.string   "bcydw_sheng",            :limit => 60
			t.string   "bsscqydz",               :limit => 60
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
			t.integer  "current_state", :default => -1
			t.integer  "czb_type", :default => -1
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
			t.string   "yytcr",                  :limit => 60
			t.datetime "yytcsj"
			t.datetime "yysdsj"
			t.string   "yynr",                   :limit => 60
			t.string   "djbm",                   :limit => 60
			t.string   "djr",                    :limit => 60
			t.datetime "djsj"
			t.string   "fjsqzk",                 :limit => 60
			t.string   "yyczqk",                 :limit => 60
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
			t.string   "pczgfc_2"
			t.string   "pczgfc_3"
			t.date     "pczgfc_4"
			t.date     "pczgfc_5"
			t.string   "pczgfc_6"
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
			t.integer  "hccz_type",                            :default => -1
			t.text     "pczgfc_9"
			t.boolean  "part_submit_flag1",                    :default => false
			t.boolean  "part_submit_flag2",                    :default => false
			t.boolean  "part_submit_flag3",                    :default => false
			t.boolean  "part_submit_flag4",                    :default => false
			t.integer  "wtyp_czb_type",                        :default => 0

      t.timestamps
    end
  end
end
