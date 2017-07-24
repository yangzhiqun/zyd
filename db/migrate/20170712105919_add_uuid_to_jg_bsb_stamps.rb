class AddUuidToJgBsbStamps < ActiveRecord::Migration
  def change
    add_column :jg_bsb_stamps, :uuid, :string
  end
end
