class AddFxJyyjCustomToSpBsbs < ActiveRecord::Migration
  def change
     add_column :sp_bsbs, :FX_jyyj_custom, :text
  end
end
