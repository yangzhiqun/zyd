class AddZipcodeFaxTypeToJgBsbs < ActiveRecord::Migration
  def change
		add_column :jg_bsbs, :zipcode, :string, length: 15
		add_column :jg_bsbs, :fax, :string, length: 30
		add_column :jg_bsbs, :jg_type, :integer
  end
end
