class ChangeJgTelTextLonger < ActiveRecord::Migration
  def change
		change_column :jg_bsbs, :jg_tel, :string, limit: 128
  end
end
