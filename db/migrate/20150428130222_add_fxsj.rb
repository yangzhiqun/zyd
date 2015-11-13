class AddFxsj < ActiveRecord::Migration
  def change
  add_column :wtyp_czb_parts, :fxpj_4, :date
  end

end
