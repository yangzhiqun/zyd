class AddIdentifierToBaosongB < ActiveRecord::Migration
  def change
		add_column :baosong_bs, :identifier, :string unless column_exists?(:baosong_bs, :identifier)
  end
end
