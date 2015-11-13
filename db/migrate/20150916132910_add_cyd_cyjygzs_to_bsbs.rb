class AddCydCyjygzsToBsbs < ActiveRecord::Migration
  def change
		add_column :pad_sp_bsbs, :cyd_file_path, :string
		add_column :pad_sp_bsbs, :cyjygzs_file_path, :string

		add_column :sp_bsbs, :cyd_file_path, :string
		add_column :sp_bsbs, :cyjygzs_file_path, :string
  end
end
