class AddJgEmailToJgBsbs < ActiveRecord::Migration
  def change
    add_column :jg_bsbs, :jg_email, :string
  end
end
