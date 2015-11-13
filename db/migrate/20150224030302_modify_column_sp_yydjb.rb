class ModifyColumnSpYydjb < ActiveRecord::Migration
  def change
add_column :sp_yydjbs, :cjbh, :string,:limit =>60
add_column :sp_yydjbs, :ypmc, :string,:limit =>60
add_column :sp_yydjbs, :ypgg, :string,:limit =>60
add_column :sp_yydjbs, :ypph, :string,:limit =>60
add_column :sp_yydjbs, :scrq, :datetime
add_column :sp_yydjbs, :spdl, :string,:limit =>60
add_column :sp_yydjbs, :spyl, :string,:limit =>60
add_column :sp_yydjbs, :spcyl, :string,:limit =>60
add_column :sp_yydjbs, :spxl, :string,:limit =>60
add_column :sp_yydjbs, :jyjl, :string,:limit =>60
add_column :sp_yydjbs, :yytcr, :string,:limit =>60
add_column :sp_yydjbs, :yytcsj, :datetime
add_column :sp_yydjbs, :yysdsj, :datetime
add_column :sp_yydjbs, :yyfl, :string,:limit =>60
add_column :sp_yydjbs, :yynr, :string,:limit =>60
add_column :sp_yydjbs, :yyczbm, :string,:limit =>60
add_column :sp_yydjbs, :yyczfzr, :string,:limit =>60
add_column :sp_yydjbs, :yyczqk, :string,:limit =>60
add_column :sp_yydjbs, :yyczzt, :string,:limit =>60
add_column :sp_yydjbs, :yyczjg, :string,:limit =>60
add_column :sp_yydjbs, :fjsqqk, :string,:limit =>60
add_column :sp_yydjbs, :fjzt, :string,:limit =>60
add_column :sp_yydjbs, :fjsqr, :string,:limit =>60
add_column :sp_yydjbs, :fjsqsj, :datetime
add_column :sp_yydjbs, :fjslrq, :datetime
add_column :sp_yydjbs, :fjwcsj, :datetime
add_column :sp_yydjbs, :fjxm, :string,:limit =>60
add_column :sp_yydjbs, :fjjg, :string,:limit =>60
add_column :sp_yydjbs, :fjjl, :string,:limit =>60
add_column :sp_yydjbs, :fjjgou, :string,:limit =>60
add_column :sp_yydjbs, :bljg, :string,:limit =>60
add_column :sp_yydjbs, :djbm, :string,:limit =>60
add_column :sp_yydjbs, :djr, :string,:limit =>60
add_column :sp_yydjbs, :djsj, :datetime
add_column :sp_yydjbs, :blbm, :string,:limit =>60
add_column :sp_yydjbs, :blr, :string,:limit =>60
add_column :sp_yydjbs, :blsj, :datetime
add_column :sp_yydjbs, :tbbm, :string,:limit =>60
add_column :sp_yydjbs, :tbr, :string,:limit =>60
add_column :sp_yydjbs, :tbsj, :datetime
add_column :sp_yydjbs, :shbm, :string,:limit =>60
add_column :sp_yydjbs, :shr, :string,:limit =>60
add_column :sp_yydjbs, :shsj, :datetime


  end
end
