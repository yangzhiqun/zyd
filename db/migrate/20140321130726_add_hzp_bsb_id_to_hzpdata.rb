class AddHzpBsbIdToHzpdata < ActiveRecord::Migration
  def change
    add_column :hzpdata, :hzp_bsb_id, :string
  end
end
