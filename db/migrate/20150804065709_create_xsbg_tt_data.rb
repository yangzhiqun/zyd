class CreateXsbgTtData < ActiveRecord::Migration
  def change
    create_table :xsbg_tt_data do |t|
      t.integer :xsbg_tt_id
      t.integer :sp_bsb_id
			t.string  :CJBH

			t.string   "spdata_0"
			t.string   "spdata_1"
			t.string   "spdata_2"
			t.string   "spdata_3"
			t.string   "spdata_4"
			t.string   "spdata_5"
			t.string   "spdata_6"
			t.string   "spdata_7"
			t.string   "spdata_8"
			t.string   "spdata_9"
			t.string   "spdata_10"
			t.string   "spdata_11"
			t.string   "spdata_12"
			t.string   "spdata_13"
			t.string   "spdata_14"
			t.string   "spdata_15"
			t.string   "spdata_16"
			t.string   "spdata_17"
			t.string   "spdata_18"
			t.integer  "spdata_id",             :null => false

      t.timestamps
    end
  end
end
