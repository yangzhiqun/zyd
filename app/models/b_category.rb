class BCategory < ActiveRecord::Base
  acts_as_paranoid

  def rowspan
    DCategory.where('b_category_id = ?', self.id).count
  end
end
