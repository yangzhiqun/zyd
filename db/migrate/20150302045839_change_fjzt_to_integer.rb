class ChangeFjztToInteger < ActiveRecord::Migration
  def change
		change_column :sp_yydjbs, :fjzt, :integer, :default => -1
  end
end
