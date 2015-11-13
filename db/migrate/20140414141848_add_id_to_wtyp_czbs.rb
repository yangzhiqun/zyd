class AddIdToWtypCzbs < ActiveRecord::Migration
  def change
    add_column :wtyp_czbs, :wtyp_sp_bsbs_id, :integer
    add_column :wtyp_czbs, :wtyp_no, :string
  end
end
