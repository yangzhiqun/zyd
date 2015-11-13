class AddWtypStateLtToWtypCzbs < ActiveRecord::Migration
  def change
      add_column :wtyp_czbs, :wtyp_state_sc, :string
      add_column :wtyp_czbs, :wtyp_date_sc, :date
      add_column :wtyp_czbs, :wtyp_fjstate, :string
  end
end
