class AddWtypDealSegmentToWtypCzbs < ActiveRecord::Migration
  def change
      add_column :wtyp_czbs, :wtyp_deal_segment, :string
      add_column :wtyp_czbs, :wtyp_deal_segment_sc, :string
      add_column :wtyp_czbs, :wtyp_deal_affirm, :string
      add_column :wtyp_czbs, :wtyp_deal_affirm_sc, :string
      add_column :wtyp_czbs, :wtyp_deal_site, :text
      add_column :wtyp_czbs, :wtyp_deal_result, :text
  end
end
