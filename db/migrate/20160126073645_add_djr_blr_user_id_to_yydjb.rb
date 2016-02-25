class AddDjrBlrUserIdToYydjb < ActiveRecord::Migration
  def change
    add_column :sp_yydjbs, :djr_user_id, :integer
    add_column :sp_yydjbs, :blr_user_id, :integer
    add_column :sp_yydjbs, :tbr_user_id, :integer
    add_column :sp_yydjbs, :shr_user_id, :integer
  end
end
