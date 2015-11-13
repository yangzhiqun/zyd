class ACategory < ActiveRecord::Base
  # attr_accessible :bgfl_id, :name, :note, :identifier

  has_many :b_categories, dependent: :delete_all
  has_many :c_categories, dependent: :delete_all
  has_many :d_categories, dependent: :delete_all
  has_many :check_items, dependent: :delete_all

  def rowspan
    DCategory.count(:conditions => ["a_category_id = ?", self.id])
  end
end
