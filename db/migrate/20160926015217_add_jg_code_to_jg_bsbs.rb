class AddJgCodeToJgBsbs < ActiveRecord::Migration
  def change
    add_column :jg_bsbs, :jg_code, :string
  end
end
