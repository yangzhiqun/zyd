class AddProvToBaosongbiao < ActiveRecord::Migration
  def change
		add_column :baosong_as, :prov, :string unless column_exists?(:baosong_as, :prov)
		add_column :baosong_bs, :prov, :string unless column_exists?(:baosong_bs, :prov)
  end
end
