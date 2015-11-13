class AddPdfSignRulesToJgBsbs < ActiveRecord::Migration
  def change
		add_column :jg_bsbs, :pdf_sign_rules, :string
  end
end
