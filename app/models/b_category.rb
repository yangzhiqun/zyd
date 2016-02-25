class BCategory < ActiveRecord::Base
  acts_as_paranoid

  def rowspan
    return @rowspan if @rowspan.present?
    @rowspan = DCategory.where('b_category_id = ?', self.id).count
  end
end
