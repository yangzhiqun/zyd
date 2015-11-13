class AddSortIdToflexcontents < ActiveRecord::Migration
  def up
      add_column :flexcontents,:flex_sortid,:integer
  end

  def down
  end
end
