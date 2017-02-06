class CCategory < ActiveRecord::Base
  acts_as_paranoid
  has_many :d_categories, dependent: :delete_all
  has_many :check_items, dependent: :delete_all

  def rowspan
    DCategory.where('c_category_id = ?', self.id).count
    return @rowspan if @rowspan.present?
    @rowspan = DCategory.where('c_category_id = ?', self.id).count
  end
end
