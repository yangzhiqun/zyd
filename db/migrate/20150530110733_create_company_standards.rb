class CreateCompanyStandards < ActiveRecord::Migration
  def change
    create_table :company_standards do |t|
      t.string :name
      t.string :number
      t.string :author_company
      t.date :valid_at
      t.integer :attachment_id

      t.timestamps
    end
  end
end
