class StandardACategorie < ActiveRecord::Base
  has_many :standard_b_categories, dependent: :delete_all
  has_many :standard_c_categories, dependent: :delete_all
  has_many :standard_d_categories, dependent: :delete_all
  has_many :standard_check_items, dependent: :delete_all
end
