class CreateBjpBsbs < ActiveRecord::Migration
  def change
    create_table :bjp_bsbs do |t|
      t.string :bjp_s_1
      t.string :bjp_s_2

      t.timestamps
    end
  end
end
