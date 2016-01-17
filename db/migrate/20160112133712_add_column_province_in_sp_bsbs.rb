class AddColumnProvinceInSpBsbs < ActiveRecord::Migration
  def change
		add_column :sp_bsbs, :sp_s_220, :string, limit: 10
		add_column :sp_bsbs, :sp_s_221, :string, limit: 10
  end
end
