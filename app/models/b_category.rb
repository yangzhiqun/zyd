class BCategory < ActiveRecord::Base
  acts_as_paranoid
  has_many :c_categories, dependent: :delete_all
  has_many :d_categories, dependent: :delete_all
  has_many :check_items, dependent: :delete_all

  def rowspan
    return @rowspan if @rowspan.present?
    @rowspan = DCategory.where('b_category_id = ?', self.id).count
  end
end
