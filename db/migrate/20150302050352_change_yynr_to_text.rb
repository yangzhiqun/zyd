class ChangeYynrToText < ActiveRecord::Migration
  def change
		change_column :sp_yydjbs, :yynr, :text
  end
end
