class AddStateToBjpBsbs < ActiveRecord::Migration
  def change
      add_column :bjp_bsbs, :bjp_i_state, :integer
  end
end
