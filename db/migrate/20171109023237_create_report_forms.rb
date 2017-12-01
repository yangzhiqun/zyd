class CreateReportForms < ActiveRecord::Migration
  def change
    create_table :report_forms do |t|
      t.text :spbsb_field
      t.text :spdata_field
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
