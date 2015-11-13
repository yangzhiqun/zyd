class AddSfToJgBsbs < ActiveRecord::Migration
  def change
    add_column :jg_bsbs, :jg_province, :string
  end
end
