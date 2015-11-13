class AddColumnToWtyp < ActiveRecord::Migration
  def change
add_column :wtyp_czbs, :rwly, :string,:limit =>60
add_column :wtyp_czbs, :bhgxmsx, :string,:limit =>60
add_column :wtyp_czbs, :bgfl, :string,:limit =>60
add_column :wtyp_czbs, :cyhj, :string,:limit =>60
add_column :wtyp_czbs, :bcydw_sheng, :string,:limit =>60
add_column :wtyp_czbs, :bcydw_shi, :string,:limit =>60
add_column :wtyp_czbs, :bcydw_xian, :string,:limit =>60
add_column :wtyp_czbs, :bsscqy_sheng, :string,:limit =>60
add_column :wtyp_czbs, :bsscqy_shi, :string,:limit =>60
add_column :wtyp_czbs, :bsscqy_xian, :string,:limit =>60
add_column :wtyp_czbs, :yyzt, :string,:limit =>60
add_column :wtyp_czbs, :yyfl, :string,:limit =>60
add_column :wtyp_czbs, :yyczjg, :string,:limit =>60
add_column :wtyp_czbs, :fjzt, :string,:limit =>60
add_column :wtyp_czbs, :fjsqr, :string,:limit =>60
add_column :wtyp_czbs, :fjsqsj, :datetime
add_column :wtyp_czbs, :fjslrq, :datetime
add_column :wtyp_czbs, :fjwcsj, :datetime
add_column :wtyp_czbs, :fjxm, :string,:limit =>60
add_column :wtyp_czbs, :fjjg, :string,:limit =>60
add_column :wtyp_czbs, :fjjl, :string,:limit =>60
add_column :wtyp_czbs, :fjjgou, :string,:limit =>60
add_column :wtyp_czbs, :czbm, :string,:limit =>60
add_column :wtyp_czbs, :czfzr, :string,:limit =>60
add_column :wtyp_czbs, :hcczzt, :string,:limit =>60
add_column :wtyp_czbs, :blzt, :string,:limit =>60
add_column :wtyp_czbs, :bljg, :string,:limit =>60
add_column :wtyp_czbs, :blbm, :string,:limit =>60
add_column :wtyp_czbs, :blr, :string,:limit =>60
add_column :wtyp_czbs, :blsj, :datetime
add_column :wtyp_czbs, :tbbm, :string,:limit =>60
add_column :wtyp_czbs, :tbr, :string,:limit =>60
add_column :wtyp_czbs, :tbsj, :datetime
add_column :wtyp_czbs, :shbm, :string,:limit =>60
add_column :wtyp_czbs, :shr, :string,:limit =>60
add_column :wtyp_czbs, :shsj, :datetime
    
  end
end
