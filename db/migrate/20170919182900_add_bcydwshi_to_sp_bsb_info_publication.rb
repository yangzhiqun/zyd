class AddBcydwshiToSpBsbInfoPublication < ActiveRecord::Migration
  def change
    add_column :sp_bsb_info_publications, :bcydwshi, :string unless column_exists? :sp_bsb_info_publications, :bcydwshi
  end
end
