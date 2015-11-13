class AddUserIdToCompanyStandards < ActiveRecord::Migration
  def change
		add_column :company_standards, :user_id, :integer
  end
end
