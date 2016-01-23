class AddSysProvinceIdToJgBsbs < ActiveRecord::Migration
  def change
    add_column :jg_bsbs, :sys_province_id, :integer
  end
end
