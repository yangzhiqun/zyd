class ChangeJgWordAreaTextLonger < ActiveRecord::Migration
  def change
		change_column :jg_bsbs, :jg_word_area, :text, length: 65536
  end
end
