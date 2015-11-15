class Bjpdatum < ActiveRecord::Base
  #attr_accessible  :bjpdata_0, :bjpdata_1, :bjpdata_2, :bjpdata_3, :bjpdata_4, :bjpdata_5, :bjpdata_6, :bjpdata_7, :bjpdata_8, :bjpdata_9,:bjp_bsb_id 
    belongs_to :bjp_bsb
end
