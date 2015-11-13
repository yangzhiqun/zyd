class AddSpBsbColumnsToSpBsbPublications < ActiveRecord::Migration
    def change
    	add_column :sp_bsb_publications, "sp_s_1",:string, :default => ""
      add_column :sp_bsb_publications, "sp_s_2",:string, :default => ""
      add_column :sp_bsb_publications, "sp_s_3",:string, :default => ""
      add_column :sp_bsb_publications, "sp_s_4",:string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_5",:string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_6",:string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_7",:string
      add_column :sp_bsb_publications, "sp_s_8",:string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_9",:string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_10", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_11", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_12", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_13", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_14", :string, :default => ""
      add_column :sp_bsb_publications, "sp_n_15", :decimal, :precision => 10, :scale => 2
      add_column :sp_bsb_publications, "sp_s_16",:string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_17",:string, :default => ""
      add_column :sp_bsb_publications, "sp_s_18",:string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_19",:string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_20",:string, :default => ""
      add_column :sp_bsb_publications, "sp_s_21",:string, :limit => 60
      add_column :sp_bsb_publications, "sp_d_22", :date
      add_column :sp_bsb_publications, "sp_s_23",:string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_24",:string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_25",:string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_26",:string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_27",:string, :limit => 60
      add_column :sp_bsb_publications, "sp_d_28", :date
      add_column :sp_bsb_publications, "sp_n_29", :string
      add_column :sp_bsb_publications, "sp_s_30", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_n_31", :decimal, :precision => 10, :scale => 0
      add_column :sp_bsb_publications, "sp_n_32", :decimal, :precision => 10, :scale => 0
      add_column :sp_bsb_publications, "sp_s_33",:string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_34", :string
      add_column :sp_bsb_publications, "sp_s_35", :string, :default => ""
      add_column :sp_bsb_publications, "sp_s_36", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_37", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_d_38", :date
      add_column :sp_bsb_publications, "sp_s_39", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_40", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_41", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_42", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_43", :string, :default => ""
      add_column :sp_bsb_publications, "sp_s_44", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_45", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_d_46", :date
      add_column :sp_bsb_publications, "sp_d_47", :date
      add_column :sp_bsb_publications, "sp_s_48", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_49", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_50", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_51", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_52", :text
      add_column :sp_bsb_publications, "sp_s_53", :text
      add_column :sp_bsb_publications, "sp_s_54", :text
      add_column :sp_bsb_publications, "sp_s_55", :text
      add_column :sp_bsb_publications, "sp_s_56", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_57", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_58", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_59", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_60", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_61", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_62", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_63", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_64", :string, :default => ""
      add_column :sp_bsb_publications, "sp_s_65", :string
      add_column :sp_bsb_publications, "sp_s_66", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_67", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_68", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_69", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_70", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_71", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_72", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_73", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_74", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_75", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_76", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_77", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_78", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_79", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_80", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_81", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_82", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_83", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_84", :string
      add_column :sp_bsb_publications, "sp_s_85", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_d_86", :date
      add_column :sp_bsb_publications, "sp_s_87", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_88", :string, :limit => 60
      add_column :sp_bsb_publications, "tname", :string, :limit => 60
      add_column :sp_bsb_publications, "submit_d_flag", :datetime
      add_column :sp_bsb_publications, "sp_n_jcxcount", :decimal, :precision => 10, :scale => 0
      add_column :sp_bsb_publications, "sp_s_bsfl", :string, :limit => 60
      add_column :sp_bsb_publications, "sp_s_2_1", :string, :default => ""
      add_column :sp_bsb_publications, "sp_i_state", :integer
      add_column :sp_bsb_publications, "sp_i_jgback", :integer
      add_column :sp_bsb_publications, "sp_s_reason", :text
      add_column :sp_bsb_publications, "sp_i_backtimes", :integer
      add_column :sp_bsb_publications, "sp_s_201", :string
      add_column :sp_bsb_publications, "sp_s_202", :string
      add_column :sp_bsb_publications, "sp_s_203", :string
      add_column :sp_bsb_publications, "sp_s_204", :string
      add_column :sp_bsb_publications, "sp_s_205", :string
      add_column :sp_bsb_publications, "sp_s_206", :string
      add_column :sp_bsb_publications, "sp_s_207", :string
      add_column :sp_bsb_publications, "sp_s_208", :string
      add_column :sp_bsb_publications, "sp_s_209", :string
      add_column :sp_bsb_publications, "sp_s_210", :string
      add_column :sp_bsb_publications, "sp_s_211", :string
      add_column :sp_bsb_publications, "sp_s_212", :string
      add_column :sp_bsb_publications, "sp_s_213", :string
      add_column :sp_bsb_publications, "sp_s_214", :string
      add_column :sp_bsb_publications, "sp_s_215", :string
      add_column :sp_bsb_publications, "sp_t_procedure", :text
      add_column :sp_bsb_publications, "fail_report_path", :string
      add_column :sp_bsb_publications, "is_yydj", :boolean, :default => false
      add_column :sp_bsb_publications, "current_yycz_step", :integer, :default => -1
      add_column :sp_bsb_publications, "bgfl", :string, :default => ""
      add_column :sp_bsb_publications, "sp_xkz", :string
      add_column :sp_bsb_publications, "sp_xkz_id", :string
      add_column :sp_bsb_publications, "fail_report_at", :datetime
      add_column :sp_bsb_publications, "czb_reverted_flag", :boolean, :default => false
      add_column :sp_bsb_publications, "synced", :boolean, :default => false
      add_column :sp_bsb_publications, "gbsj", :string, :default => "0"
    end
end
