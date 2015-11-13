class CreateSpBsbs < ActiveRecord::Migration
  def change
    create_table :sp_bsbs do |t|
        t.string :sp_s_1,:limit => 60

      t.timestamps
    end
  end
end
