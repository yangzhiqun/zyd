class AddUuidToJgBsb < ActiveRecord::Migration
  def change
    add_column :jg_bsbs, :uuid, :string
  end
end
