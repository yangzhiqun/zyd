class AddZdToWtypCzbs < ActiveRecord::Migration
  def change
      add_column :wtyp_czbs, :wtyp_deal_way_sc,:text
      add_column :wtyp_czbs, :wtyp_deal_detail_sc,:text
      add_column :wtyp_czbs, :wtyp_deal_fix1way,:string
      add_column :wtyp_czbs, :wtyp_deal_fix1way_sc,:string
      add_column :wtyp_czbs, :wtyp_deal_fix2way,:string
      add_column :wtyp_czbs, :wtyp_deal_fix2way_sc,:string
      add_column :wtyp_czbs, :wtyp_deal_fix3way,:string
      add_column :wtyp_czbs, :wtyp_deal_fix3way_sc,:string
      add_column :wtyp_czbs, :wtyp_result_fix1way,:string
      add_column :wtyp_czbs, :wtyp_result_fix1way_sc, :string
      add_column :wtyp_czbs, :wtyp_result_fix2way, :string
      add_column :wtyp_czbs, :wtyp_result_fix2way_sc, :string
      add_column :wtyp_czbs, :wtyp_result_fix3way, :string
      add_column :wtyp_czbs, :wtyp_result_fix3way_sc, :string
      add_column :wtyp_czbs, :wtyp_result_fix4way, :string
      add_column :wtyp_czbs, :wtyp_result_fix4way_sc, :string
      add_column :wtyp_czbs, :wtyp_result_fix5way, :string
      add_column :wtyp_czbs, :wtyp_result_fix5way_sc, :string
      add_column :wtyp_czbs, :wtyp_result_fix6way, :string
      add_column :wtyp_czbs, :wtyp_result_fix6way_sc, :string
      add_column :wtyp_czbs, :wtyp_result_fix7way, :string
      add_column :wtyp_czbs, :wtyp_result_fix7way_sc, :string
      add_column :wtyp_czbs, :wtyp_result_fix8way, :string
      add_column :wtyp_czbs, :wtyp_result_fix8way_sc, :string
  end
end
