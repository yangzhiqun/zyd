class BaosongAJgId < ActiveRecord::Base
  #belongs_to :jg_bsb
  belongs_to :jg_bsb, class_name: JgBsb, foreign_key: :jg_bsb_id
  belongs_to :baosong_a
end
