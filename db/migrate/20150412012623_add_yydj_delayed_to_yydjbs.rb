class AddYydjDelayedToYydjbs < ActiveRecord::Migration
  def change
		add_column :sp_yydjbs, :dj_delayed, :boolean, :default => false
  end
end
