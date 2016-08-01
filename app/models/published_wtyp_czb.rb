class PublishedWtypCzb < ActiveRecord::Base
  validates_uniqueness_of :cjbh, scope: :wtyp_czb_type, message: '已发过该信息'

  validate do |czb|
    unless PublishedSpBsb.exists?(cjbh: czb.cjbh)
      errors.add(:base, '该样品的基本信息尚未发布')
    end
  end

	has_one :wtyp_czb_part, primary_key: :cjbh, foreign_key: :cjbh
end
