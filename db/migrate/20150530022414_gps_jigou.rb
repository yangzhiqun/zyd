class GpsJigou < ActiveRecord::Migration
  def change
  add_column :jg_bsbs, :gpsname, :string
  add_column :jg_bsbs, :gpspassword, :string
  end
end
