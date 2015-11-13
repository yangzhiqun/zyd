class ChangeSourceToText < ActiveRecord::Migration
  def change
		change_column :sp_bsb_certs, :user_cert, :text
  end
end
