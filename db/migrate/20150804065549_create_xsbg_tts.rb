class CreateXsbgTts < ActiveRecord::Migration
  def change
    create_table :xsbg_tts do |t|
      t.string :GJMC
      t.string :CJBH
      t.integer :sp_bsb_id

      t.timestamps
    end
  end
end
