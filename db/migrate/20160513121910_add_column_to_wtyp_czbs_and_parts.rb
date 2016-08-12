class AddColumnToWtypCzbsAndParts < ActiveRecord::Migration
  def change
    add_column :wtyp_czbs, :wtyp_4, :string, limit: 60
    add_column :wtyp_czbs, :wtyp_5, :string, limit: 60
    add_column :wtyp_czb_parts, :wtyp_4, :string, limit: 60
    add_column :wtyp_czb_parts, :wtyp_5, :string, limit: 60
    add_column :wtyp_czb_parts, :qdqk_sdrq, :date
    add_column :wtyp_czb_parts, :qdqk_sfjs, :string, limit: 60
    add_column :wtyp_czb_parts, :cpkzqk_wzhyy, :string, limit: 60
    add_column :wtyp_czb_parts, :cpkzqk_sfdw, :string, limit: 60
    add_column :wtyp_czb_parts, :cpkzqk_sfhl, :string, limit: 60
    add_column :wtyp_czb_parts, :yypc_zsylly, :string, limit: 60
    add_column :wtyp_czb_parts, :yypc_bhgscz, :string, limit: 60
    add_column :wtyp_czb_parts, :yypc_wzcyy, :string, limit: 60
    add_column :wtyp_czb_parts, :yypc_sfhl, :string, limit: 60
    add_column :wtyp_czb_parts, :xzcf_rdyj, :string, limit: 60
    add_column :wtyp_czb_parts, :xzcf_yjsfsd, :string, limit: 60
    add_column :wtyp_czb_parts, :xzcf_cssfsd, :string, limit: 60
    add_column :wtyp_czb_parts, :xzcf_wlayy, :string, limit: 60
    add_column :wtyp_czb_parts, :xzcf_wcfyy, :string, limit: 60
    add_column :wtyp_czb_parts, :xzcf_blasfhl, :string, limit: 60
    add_column :wtyp_czb_parts, :zgfc_sftjbg, :string, limit: 60
    add_column :wtyp_czb_parts, :zgfc_jgbmyj, :string, limit: 60
    add_column :wtyp_czb_parts, :zgfc_zgsfhl, :string, limit: 60
    add_column :wtyp_czb_parts, :tbys_tbqtbm, :string, limit: 60
    add_column :wtyp_czb_parts, :tbys_xzbmmc, :string, limit: 60
    add_column :wtyp_czb_parts, :tbys_sfjgmc, :string, limit: 60
    add_column :wtyp_czb_parts, :tbys_sfla, :string, limit: 60
    add_column :wtyp_czb_parts, :tbys_sftbys, :string, limit: 60
  end
end
