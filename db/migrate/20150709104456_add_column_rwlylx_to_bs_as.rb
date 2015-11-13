class AddColumnRwlylxToBsAs < ActiveRecord::Migration
  def change
		add_column :baosong_as, :rwlylx , :string
  end
end
