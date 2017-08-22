class StandardBCategory < ActiveRecord::Base
  belongs_to :standard_a_category
  has_many :standard_c_categories
  has_many :standard_d_categories, through: :standard_c_categories 
  has_many :standard_check_items,  through: :standard_d_categories
end
