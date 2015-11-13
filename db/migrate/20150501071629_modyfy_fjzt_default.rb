#encoding: utf-8
class ModyfyFjztDefault < ActiveRecord::Migration
  def change
  change_column :sp_yydjbs, :fjzt, :string, :default => "初检结论" 
  end
end
