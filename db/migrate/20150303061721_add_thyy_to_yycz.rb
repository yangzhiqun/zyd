class AddThyyToYycz < ActiveRecord::Migration
  def change
		add_column :sp_yydjbs, :thyy, :text
  end
end
