class AddCaKeyStateToSpBsbs < ActiveRecord::Migration
  def change
    add_column :sp_bsbs, :ca_key_status, :integer, default: 0
  end
end
