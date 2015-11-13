class CreateWtypCzbs < ActiveRecord::Migration
  def change
    create_table :wtyp_czbs do |t|
      t.string :wtyp_jg
      t.string :wtyp_contacts
      t.string :wtyp_tel
      t.string :wtyp_fax
      t.string :wtyp_email
      t.string :wtyp_verify
      t.string :wtyp_state
      t.date :wtyp_date
      t.text :wtyp_deal_way
      t.text :wtyp_deal_detail
      t.string :wtyp_deal_jg
      t.text :wtyp_remark

      t.timestamps
    end
  end
end
