class DCategory < ActiveRecord::Base
  acts_as_paranoid

  has_many :check_items
end
