class AddSpS89ToSpBsbs < ActiveRecord::Migration
  def change
    add_column :sp_bsbs, :sp_s_89 , :string
  end
end
