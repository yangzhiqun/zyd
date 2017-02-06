class StandardCheckItem < ActiveRecord::Base
  belongs_to :standard_a_category
  belongs_to :standard_b_category
  belongs_to :standard_c_category
  belongs_to :standard_d_category
end
