class AddColumnToHczSpdada < ActiveRecord::Migration
  def change
 add_column :wtyp_czbs, :cjbh, :string, :limit =>60
add_column :wtyp_czbs, :ypmc, :string, :limit =>60
add_column :wtyp_czbs, :ypgg, :string, :limit =>60
add_column :wtyp_czbs, :ypph, :string, :limit =>60
add_column :wtyp_czbs, :jyjl, :string, :limit =>60
add_column :wtyp_czbs, :bcydwmc, :string, :limit =>60
add_column :wtyp_czbs, :cydwmc, :string, :limit =>60
add_column :wtyp_czbs, :cydwsf, :string, :limit =>60
add_column :wtyp_czbs, :bsscqymc, :string, :limit =>60
add_column :wtyp_czbs, :scrq, :datetime
add_column :wtyp_czbs, :yytcr, :string, :limit =>60
add_column :wtyp_czbs, :yytcsj, :datetime
add_column :wtyp_czbs, :yysdsj, :datetime
add_column :wtyp_czbs, :yynr, :string, :limit =>60
add_column :wtyp_czbs, :djbm, :string, :limit =>60
add_column :wtyp_czbs, :djr, :string, :limit =>60
add_column :wtyp_czbs, :djsj, :datetime
add_column :wtyp_czbs, :fjsqzk, :string, :limit =>60
add_column :wtyp_czbs, :yyczqk, :string, :limit =>60


 end
end
