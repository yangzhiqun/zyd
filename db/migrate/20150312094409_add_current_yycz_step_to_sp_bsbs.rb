class AddCurrentYyczStepToSpBsbs < ActiveRecord::Migration
  def change
		add_column :sp_bsbs, :current_yycz_step, :integer, :default => -1
  end
end
