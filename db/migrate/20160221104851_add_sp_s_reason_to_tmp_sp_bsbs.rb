class AddSpSReasonToTmpSpBsbs < ActiveRecord::Migration
  def change
    add_column :tmp_sp_bsbs, :sp_s_reason, :text, limit: 65535
  end
end
