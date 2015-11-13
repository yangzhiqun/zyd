class AddThyyToWtypCzbs < ActiveRecord::Migration
  def change
		add_column :wtyp_czbs, :thyy, :text
  end
end
