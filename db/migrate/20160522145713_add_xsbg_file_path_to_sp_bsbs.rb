class AddXsbgFilePathToSpBsbs < ActiveRecord::Migration
  def change
    add_column :sp_bsbs, :xsbg_file_path, :string, limit: 256
  end
end
