class AddCodeToJgBsbs < ActiveRecord::Migration
  def change
		add_column :jg_bsbs, :code, :string
  end
end
