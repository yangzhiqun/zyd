class AddPdfRulesToSpBsbs < ActiveRecord::Migration
  def change
	add_column :sp_bsbs, :JDCJ_pdf_rules, :string, limit: 200
        add_column :sp_bsbs, :FXJC_pdf_rules, :string, limit: 200
  end
end
