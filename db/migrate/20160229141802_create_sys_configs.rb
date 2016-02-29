class CreateSysConfigs < ActiveRecord::Migration
  def change
    create_table :sys_configs do |t|
      t.string :key
      t.text :value

      t.timestamps null: false
    end
  end
end
