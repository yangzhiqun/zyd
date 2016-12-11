class AddCaOrgToJgBsbs < ActiveRecord::Migration
  def change
	add_column :jg_bsbs, :ca_org, :string
  end
end
