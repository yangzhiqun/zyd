class ChangeShixianLength < ActiveRecord::Migration
  def change
    change_column :sp_bsbs, :sp_s_4, :string, limit: 50 
    change_column :sp_bsbs, :sp_s_5, :string, limit: 50 
    change_column :sp_bsbs, :sp_s_220, :string, limit: 50 
    change_column :sp_bsbs, :sp_s_221, :string, limit: 50 

    change_column :wtyp_czbs, :sp_s_220, :string, limit: 50 
    change_column :wtyp_czbs, :sp_s_221, :string, limit: 50 
    change_column :wtyp_czbs, :bsscqy_shi, :string, limit: 50 
    change_column :wtyp_czbs, :bsscqy_xian, :string, limit: 50 
    change_column :wtyp_czbs, :bcydw_shi, :string, limit: 50 
    change_column :wtyp_czbs, :bcydw_xian, :string, limit: 50 
    change_column :wtyp_czbs, :sp_s_4, :string, limit: 50 
    change_column :wtyp_czbs, :sp_s_5, :string, limit: 50 

    change_column :wtyp_czb_parts, :sp_s_220, :string, limit: 50 
    change_column :wtyp_czb_parts, :sp_s_221, :string, limit: 50 
    change_column :wtyp_czb_parts, :bsscqy_shi, :string, limit: 50 
    change_column :wtyp_czb_parts, :bsscqy_xian, :string, limit: 50 
    change_column :wtyp_czb_parts, :bcydw_shi, :string, limit: 50 
    change_column :wtyp_czb_parts, :bcydw_xian, :string, limit: 50 
    change_column :wtyp_czb_parts, :sp_s_4, :string, limit: 50 
    change_column :wtyp_czb_parts, :sp_s_5, :string, limit: 50 
  end
end
