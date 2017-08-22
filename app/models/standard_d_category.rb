class StandardDCategory < ActiveRecord::Base
  belongs_to :standard_a_category
  belongs_to :standard_b_category
  belongs_to :standard_c_category
  has_many :standard_check_items, dependent: :delete_all
end
