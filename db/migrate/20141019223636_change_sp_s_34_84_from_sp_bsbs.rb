class ChangeSpS3484FromSpBsbs < ActiveRecord::Migration
  def up
      change_column :sp_bsbs, :sp_s_34, :string
      change_column :sp_bsbs, :sp_s_84, :string
      change_column :sp_bsbs, :sp_s_65, :string
  end

  def down
  end
end
