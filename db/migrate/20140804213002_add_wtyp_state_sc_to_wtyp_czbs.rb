class AddWtypStateScToWtypCzbs < ActiveRecord::Migration
  def change
      add_column :wtyp_czbs, :wtyp_jg_sc, :string
      add_column :wtyp_czbs, :wtyp_contacts_sc, :string
      add_column :wtyp_czbs, :wtyp_tel_sc, :string
      add_column :wtyp_czbs, :wtyp_fax_sc, :string
      add_column :wtyp_czbs, :wtyp_email_sc, :string
      add_column :wtyp_czbs, :wtyp_verify_sc, :string
  end
end
