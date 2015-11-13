class DCategory < ActiveRecord::Base
  # attr_accessible :a_category_id, :b_category_id, :c_category_id, :name, :note, :identifier

  has_many :check_items
end
