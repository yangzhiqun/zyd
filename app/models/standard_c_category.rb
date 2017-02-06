class StandardCCategory < ActiveRecord::Base
  belongs_to :standard_a_category
  belongs_to :standard_b_category
  has_many :standard_d_categories
  has_many :standard_check_items, through: :standard_d_categories 
end
