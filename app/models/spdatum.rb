class Spdatum < ActiveRecord::Base
	attr_accessible :spdata_0, :spdata_1, :spdata_2, :spdata_3, :spdata_4, :spdata_5, :spdata_6, :spdata_7, :spdata_8, :spdata_9, :sp_bsb_id,:spdata_10, :spdata_11, :spdata_12, :spdata_13, :spdata_14, :spdata_15, :spdata_16, :spdata_17,:spdata_18
  belongs_to :sp_bsb
  CA_FIELDS = [:spdata_0, :spdata_1, :spdata_2, :spdata_3, :spdata_4, :spdata_5, :spdata_6, :spdata_7, :spdata_8, :spdata_9, :spdata_10, :spdata_11, :spdata_12, :spdata_13, :spdata_14, :spdata_15, :spdadta_16, :spdata_17, :spdata_18]
end
