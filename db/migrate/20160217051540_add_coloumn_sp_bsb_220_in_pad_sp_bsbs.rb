class AddColoumnSpBsb220InPadSpBsbs < ActiveRecord::Migration
  def change
      add_column :pad_sp_bsbs, :sp_s_220, :string, :limit => 10
      add_column :pad_sp_bsbs, :sp_s_221, :string, :limit => 10
      add_column :pad_sp_bsbs, :sp_s_222, :string, :limit => 20
  end
end
