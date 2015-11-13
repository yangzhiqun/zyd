class AddImagePathToJgBsbStamps < ActiveRecord::Migration
  def change
    add_column :jg_bsb_stamps, :image_path, :string, length: 512
  end
end
