class ModifyHccz < ActiveRecord::Migration
  def change
  rename_column :wtyp_czbs, :rwly, :bgsbh
  rename_column :wtyp_czbs, :bhgxmsx, :cydd
  rename_column :wtyp_czbs, :cyhj, :bcydwdz
  rename_column :wtyp_czbs, :bcydw_shi, :bsscqydz
  rename_column :wtyp_czbs, :bcydw_xian, :cyjs
  rename_column :wtyp_czbs, :bsscqy_shi, :jymd
  add_column :wtyp_czbs, :jyjgzt, :string
  add_column :wtyp_czbs, :qdhcczrq, :date
  add_column :wtyp_czbs, :czwbrq, :date
  add_column :wtyp_czbs, :fxpj_1, :string
  add_column :wtyp_czbs, :fxpj_2, :string
  add_column :wtyp_czbs, :fxpj_3, :string
  add_column :wtyp_czbs, :cpkzqk_1, :string
  add_column :wtyp_czbs, :cpkzqk_2, :string
  add_column :wtyp_czbs, :cpkzqk_3, :string
  add_column :wtyp_czbs, :cpkzqk_4, :string
  add_column :wtyp_czbs, :cpkzqk_5, :string
  add_column :wtyp_czbs, :cpkzqk_6, :string
  add_column :wtyp_czbs, :cpkzqk_7, :string
  add_column :wtyp_czbs, :cpkzqk_8, :string
  add_column :wtyp_czbs, :cpkzqk_9, :string
  add_column :wtyp_czbs, :cpkzqk_10, :string
  add_column :wtyp_czbs, :cpkzqk_11, :string
  add_column :wtyp_czbs, :cpkzqk_12, :string
  add_column :wtyp_czbs, :cpkzqk_13, :string
  add_column :wtyp_czbs, :cpkzqk_14, :string
  add_column :wtyp_czbs, :cpkzqk_15, :string
  add_column :wtyp_czbs, :cpkzqk_16, :string
  add_column :wtyp_czbs, :cpkzqk_17, :string
  add_column :wtyp_czbs, :cpkzqk_18, :string
  add_column :wtyp_czbs, :cpkzqk_19, :string
  add_column :wtyp_czbs, :pczgfc_1, :string
  add_column :wtyp_czbs, :pczgfc_2, :string
  add_column :wtyp_czbs, :pczgfc_3, :string
  add_column :wtyp_czbs, :pczgfc_4, :date
  add_column :wtyp_czbs, :pczgfc_5, :date
  add_column :wtyp_czbs, :pczgfc_6, :string
  add_column :wtyp_czbs, :pczgfc_7, :string
  add_column :wtyp_czbs, :pczgfc_8, :string
  add_column :wtyp_czbs, :xzcfqk_1, :text
  add_column :wtyp_czbs, :xzcfqk_2, :text
  add_column :wtyp_czbs, :xzcfqk_3, :text
  add_column :wtyp_czbs, :xzcfqk_4, :text
  add_column :wtyp_czbs, :xzcfqk_5, :text
  add_column :wtyp_czbs, :xzcfqk_6, :date
  add_column :wtyp_czbs, :xzcfqk_7, :text
  add_column :wtyp_czbs, :xzcfqk_8, :date
  add_column :wtyp_czbs, :xzcfqk_9, :text
  add_column :wtyp_czbs, :xzcfqk_10, :text
  add_column :wtyp_czbs, :xzcfqk_11, :text
  add_column :wtyp_czbs, :xzcfqk_12, :text
  add_column :wtyp_czbs, :xzcfqk_13, :text
  add_column :wtyp_czbs, :xzcfqk_14, :text
  add_column :wtyp_czbs, :xzcfqk_15, :text
  add_column :wtyp_czbs, :xzcfqk_16, :text
  add_column :wtyp_czbs, :xzcfqk_17, :text
  add_column :wtyp_czbs, :xzcfqk_18, :text
  add_column :wtyp_czbs, :xzcfqk_19, :text
  add_column :wtyp_czbs, :xzcfqk_20, :text
  add_column :wtyp_czbs, :xzcfqk_21, :date
  add_column :wtyp_czbs, :hccz_type, :text


  end

end
