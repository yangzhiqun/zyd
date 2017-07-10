class ChangeColumnToCheckItems < ActiveRecord::Migration
  def change
    change_column :check_items, :BZFFJCXDW,:string, default: "/"
    change_column :check_items, :BZZXYXX,:string, default: "/"
    change_column :check_items, :BZZXYXXDW,:string, default: "/"
    #change_column :check_items, :JYYJJHB,:string, default: "/"
   # change_column :check_items, :BZ,:string, default: "/"
    change_column :check_items, :BZZDYXXDW, :string, default: "/"
  end
end
