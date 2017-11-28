class SpLog < ActiveRecord::Base
  belongs_to :sp_bsb  
  # attr_accessible :remark, :sp_bsb_id, :sp_i_state, :user_id
end
