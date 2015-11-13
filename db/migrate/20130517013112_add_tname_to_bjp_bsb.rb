class AddTnameToBjpBsb < ActiveRecord::Migration
  def change
    add_column :bjp_bsbs, :tname, :string,:limit => 60
  end
end
