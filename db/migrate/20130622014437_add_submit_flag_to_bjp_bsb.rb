class AddSubmitFlagToBjpBsb < ActiveRecord::Migration
  def change
      add_column :bjp_bsbs, :submit_d_flag, :datetime
  end
end
