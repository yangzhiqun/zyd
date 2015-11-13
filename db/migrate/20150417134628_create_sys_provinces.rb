class CreateSysProvinces < ActiveRecord::Migration
  def change
    create_table :sys_provinces do |t|
      t.string :name
      t.string :note

      t.timestamps
    end
  end
end
