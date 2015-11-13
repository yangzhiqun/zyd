class CreateJgBsbs < ActiveRecord::Migration
  def change
    create_table :jg_bsbs do |t|
      t.string :jg_name
      t.string :jg_address
      t.string :jg_leader
      t.string :jg_higher_level
      t.string :jg_contacts
      t.string :jg_tel
      t.string :jg_certification
      t.string :jg_word_area
      t.integer :jg_sampling
      t.integer :jg_detection
      t.integer :jg_group
      t.string :jg_group_category
      t.integer :jg_administrion
      t.integer :jg_sp_permission
      t.integer :jg_bjp_permission
      t.integer :jg_hzp_permission
      t.integer :jg_enable

      t.timestamps
    end
  end
end
