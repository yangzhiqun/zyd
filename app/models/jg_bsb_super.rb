class JgBsbSuper < ActiveRecord::Base
  belongs_to :jg_bsb
  belongs_to :super_jg_bsb, class_name: JgBsb, foreign_key: :super_jg_bsb_id
end
