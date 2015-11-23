class AddSpS214ToTmpSpBsbs < ActiveRecord::Migration
  def change
		add_column :tmp_sp_bsbs, :sp_s_214, :string
		add_column :tmp_sp_bsbs, :sp_s_71, :string
		add_column :tmp_sp_bsbs, :fail_report_path, :string

		add_index :tmp_sp_bsbs, :sp_s_214
		add_index :tmp_sp_bsbs, :sp_s_71
  end
end
