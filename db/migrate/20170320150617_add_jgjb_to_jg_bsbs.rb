class AddJgjbToJgBsbs < ActiveRecord::Migration
  def change
     add_column :jg_bsbs, :jgjb, :integer, default: 0 
  end
end
