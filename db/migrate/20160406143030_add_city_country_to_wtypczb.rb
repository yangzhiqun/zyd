class AddCityCountryToWtypczb < ActiveRecord::Migration
  def change
		add_column :wtyp_czbs, :sp_s_4, :string, limit: 20 unless column_exists?(:wtyp_czbs, :sp_s_4)
		add_column :wtyp_czbs, :sp_s_5, :string, limit: 20 unless column_exists?(:wtyp_czbs, :sp_s_5)
		add_column :wtyp_czbs, :sp_s_220, :string, limit: 20 unless column_exists?(:wtyp_czbs, :sp_s_220)
		add_column :wtyp_czbs, :sp_s_221, :string, limit: 20 unless column_exists?(:wtyp_czbs, :sp_s_221)

		add_column :wtyp_czb_parts, :sp_s_4, :string, limit: 20 unless column_exists?(:wtyp_czb_parts, :sp_s_4)
		add_column :wtyp_czb_parts, :sp_s_5, :string, limit: 20 unless column_exists?(:wtyp_czb_parts, :sp_s_5)
		add_column :wtyp_czb_parts, :sp_s_220, :string, limit: 20 unless column_exists?(:wtyp_czb_parts, :sp_s_220)
		add_column :wtyp_czb_parts, :sp_s_221, :string, limit: 20 unless column_exists?(:wtyp_czb_parts, :sp_s_221)
  end
end
