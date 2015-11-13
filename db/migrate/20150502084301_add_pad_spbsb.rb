class AddPadSpbsb < ActiveRecord::Migration
  def change
    change_column :pad_sp_bsbs, :sp_n_29, :string
    add_column :pad_sp_bsbs, :sp_xkz, :string
    add_column :pad_sp_bsbs, :sp_xkz_id, :string
  end
end
