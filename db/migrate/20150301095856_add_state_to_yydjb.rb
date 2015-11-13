class AddStateToYydjb < ActiveRecord::Migration
  def change
		add_column :sp_yydjbs, :current_state, :integer
  end
end
