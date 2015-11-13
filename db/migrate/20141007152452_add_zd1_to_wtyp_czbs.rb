class AddZd1ToWtypCzbs < ActiveRecord::Migration
  def change
      add_column :wtyp_czbs, :wtyp_deal_site_sc,:text
  end
end
