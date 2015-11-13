class ModyfyApi < ActiveRecord::Migration
  def change
  add_column :users, :enable_api, :integer,:default => 0 unless column_exists?('users','enable_api') 
  end

end
