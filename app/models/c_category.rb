class CCategory < ActiveRecord::Base
  acts_as_paranoid

  def rowspan
    DCategory.where('c_category_id = ?', self.id).count
    return @rowspan if @rowspan.present?
    @rowspan = DCategory.where('c_category_id = ?', self.id).count
  end
end
