class AddBjpBsbD21ToBjpBsb < ActiveRecord::Migration
  def change
    add_column :bjp_bsbs, :bjp_d_21, :date
  end
end
