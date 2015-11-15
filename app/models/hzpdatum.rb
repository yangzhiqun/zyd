class Hzpdatum < ActiveRecord::Base
    #attr_accessible :hzpdata_0, :hzpdata_1, :hzpdata_2, :hzpdata_3, :hzpdata_4, :hzpdata_5, :hzpdata_6, :hzpdata_7, :hzpdata_8, :hzpdata_9, :hzp_bsb_id
    belongs_to :hzp_bsb
end
