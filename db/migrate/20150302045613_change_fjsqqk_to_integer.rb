class ChangeFjsqqkToInteger < ActiveRecord::Migration
  def change
		change_column :sp_yydjbs, :fjsqqk, :integer, :default => 0
  end
end
