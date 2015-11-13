class CCategory < ActiveRecord::Base
  # attr_accessible :a_category_id, :b_category_id, :name, :note, :identifier

  def rowspan
    DCategory.count(:conditions => ["c_category_id = ?", self.id])
  end
end
