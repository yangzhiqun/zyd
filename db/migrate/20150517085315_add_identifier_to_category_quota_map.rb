class AddIdentifierToCategoryQuotaMap < ActiveRecord::Migration
  def change
		add_column :a_categories_provinces, :identifier, :string
		add_column :a_category_jg_bsbs, :identifier, :string
  end
end
