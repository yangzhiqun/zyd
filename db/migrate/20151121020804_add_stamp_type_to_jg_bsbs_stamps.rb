class AddStampTypeToJgBsbsStamps < ActiveRecord::Migration
  def change
		add_column :jg_bsb_stamps, :name, :string
		add_column :jg_bsb_stamps, :stamp_type, :integer
  end
end
