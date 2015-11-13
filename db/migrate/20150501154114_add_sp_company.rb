class AddSpCompany < ActiveRecord::Migration
  def change
  add_column :sp_company_infos, :sp_s_17, :string
  add_column :sp_company_infos, :sp_s_18, :string
  add_column :sp_company_infos, :sp_s_19, :string
  add_column :sp_company_infos, :sp_s_20, :string
  end
end
