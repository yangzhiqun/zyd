class AddYydjEnabledByAdminAtToSpBsbs < ActiveRecord::Migration
  def change
		add_column :sp_bsbs, :yydj_enabled_by_admin_at, :datetime
  end
end
