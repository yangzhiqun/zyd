class CreateSpBsbInfoPublications < ActiveRecord::Migration
  def change
    create_table :sp_bsb_info_publications do |t|
      t.string :cjbh
      t.integer :sjid
      t.string :bcscqymc
      t.string :bcscqydz
      t.string :bcydwmc
      t.string :bcydwdz
      t.string :bcydwdz
      t.string :bcydwsf
      t.string :spmc
      t.string :ggxh
      t.string :sb
      t.date :scrq
      t.string :bhgxm
      t.string :fl
      t.string :ggh
      t.date :ggrq
      t.string :rwly
      t.string :bz
      t.string :jyjg
      t.string :sfhg
      t.integer :userid
      t.string :user_s_province
      t.timestamps
      
    end
  end
end
