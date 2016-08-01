class AddYypcWtyyToWtypCzbParts < ActiveRecord::Migration
  def change
    add_column :wtyp_czb_parts, :yypc_yylbsc, :integer , limit: 11
    add_column :wtyp_czb_parts, :yypc_yylbys, :integer , limit: 11
    add_column :wtyp_czb_parts, :yypc_yylbxs, :integer , limit: 11
    add_column :wtyp_czb_parts, :wtyp_dbtype, :integer , limit: 11
  end
end
