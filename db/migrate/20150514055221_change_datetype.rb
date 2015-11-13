class ChangeDatetype < ActiveRecord::Migration
  def change
  change_column :check_items,:JYYJ,:text
	change_column :check_items,:PDYJ,:text
  end

end
