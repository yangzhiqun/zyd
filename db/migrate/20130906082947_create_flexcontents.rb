class CreateFlexcontents < ActiveRecord::Migration
  def change
    create_table :flexcontents do |t|
      t.string :flex_field
      t.string :flex_name
      t.string :flex_id

      t.timestamps
    end
  end
end
