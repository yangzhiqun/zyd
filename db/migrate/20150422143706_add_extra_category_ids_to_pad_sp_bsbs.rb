class AddExtraCategoryIdsToPadSpBsbs < ActiveRecord::Migration
  def change
		add_column :pad_sp_bsbs, :b_category_id, :integer
		add_column :pad_sp_bsbs, :c_category_id, :integer
		add_column :pad_sp_bsbs, :d_category_id, :integer

  end
end
