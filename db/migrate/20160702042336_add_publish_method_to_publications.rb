class AddPublishMethodToPublications < ActiveRecord::Migration
  def change
		add_column :published_sp_bsbs, :pub_method, :string, limit: 20, default: '手工录入'
		add_column :published_wtyp_czbs, :pub_method, :string, limit: 20, default: '手工录入'
  end
end
