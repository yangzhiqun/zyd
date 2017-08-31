class StandardACategory < ActiveRecord::Base
  has_many :standard_b_categories
  has_many :standard_c_categories, through: :standard_b_categories
  has_many :standard_d_categories, through: :standard_c_categories
  has_many :standard_check_items,  through: :standard_d_categories
end
