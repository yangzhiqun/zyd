#encoding: utf-8
class ChangeYyczjgDefaultValue < ActiveRecord::Migration
  def change
		change_column :sp_yydjbs, :yyczjg, :string, :default => "异议处置中"
  end
end
