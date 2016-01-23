class CreateSmsLogs < ActiveRecord::Migration
  def change
    create_table :sms_logs do |t|
      t.string :sms_template_code
      t.string :sms_type
      t.string :mobile
      t.string :msg

      t.timestamps null: false
    end
  end
end
