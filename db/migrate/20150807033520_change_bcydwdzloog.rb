class ChangeBcydwdzloog < ActiveRecord::Migration
  def change
    change_column :wtyp_czbs, :bcydwdz, :string, :limit => 150
    change_column :wtyp_czbs, :bsscqydz, :string, :limit => 150
    change_column :wtyp_czb_parts, :bcydwdz, :string, :limit => 150
    change_column :wtyp_czb_parts, :bcydwdz, :string, :limit => 150
  end
end
