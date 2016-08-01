class Change60To255OnWtypCzbParts < ActiveRecord::Migration
  def change
    change_column :wtyp_czb_parts, :cpkzqk_wzhyy, :text
    change_column :wtyp_czb_parts, :yypc_bhgscz, :text
    change_column :wtyp_czb_parts, :yypc_wzcyy, :text
    change_column :wtyp_czb_parts, :xzcf_rdyj, :text
    change_column :wtyp_czb_parts, :xzcf_wlayy, :text
    change_column :wtyp_czb_parts, :xzcf_wcfyy, :text
    change_column :wtyp_czb_parts, :tbys_xzbmmc, :string
    change_column :wtyp_czb_parts, :tbys_sfjgmc, :string
    change_column :wtyp_czb_parts, :cpkzqk_kc, :string
    change_column :wtyp_czb_parts, :cpkzqk_zj, :string
    change_column :wtyp_czb_parts, :tbr_dh, :string
    change_column :wtyp_czb_parts, :tbr_cz, :string
    change_column :wtyp_czb_parts, :shr_dh, :string
    change_column :wtyp_czb_parts, :shr_cz, :string
  end
end
