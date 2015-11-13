class ChangeTypeOfGbsj < ActiveRecord::Migration
  def up
		change_column :sp_bsbs, :gbsj, :string
	end

  def down
  end
end
