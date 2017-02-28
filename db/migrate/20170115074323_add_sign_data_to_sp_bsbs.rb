class AddSignDataToSpBsbs < ActiveRecord::Migration
  def change
			add_column :sp_bsbs, :sign_date, :datetime unless column_exists?(:sp_bsbs, :sign_date)
  end
end
