class AddYyczZiduan < ActiveRecord::Migration
  def change
    add_column :sp_yydjbs, :gzscqyrq, :date
    add_column :sp_yydjbs, :gzbcydwrq, :date
  end
end
