class SpPublication < ActiveRecord::Base
  attr_accessible :name, :user_id, :worker_state, :pub_type
end
