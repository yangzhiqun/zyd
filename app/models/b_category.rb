class BCategory < ActiveRecord::Base
  # attr_accessible :a_category_id, :name, :note, :identifier

  def rowspan
    DCategory.where('b_category_id = ?', self.id).count
  end
end
