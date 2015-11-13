class AddGroupidToFlexcontent < ActiveRecord::Migration
  def change
      add_column :flexcontents,:flex_groupid,:integer
  end
end
