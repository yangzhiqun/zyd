class AddAttachmentPathToCompanyStandards < ActiveRecord::Migration
  def change
		add_column :company_standards, :attachment_path, :string
  end
end
