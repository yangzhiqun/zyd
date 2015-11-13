class AddApiIpAddressToJgBsbs < ActiveRecord::Migration
  def change
		add_column :jg_bsbs, :api_ip_address, :string
  end
end
