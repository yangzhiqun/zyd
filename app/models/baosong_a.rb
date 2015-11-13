class BaosongA < ActiveRecord::Base
  # attr_accessible :name, :note, :rwlylx, :prov
  has_many :baosong_bs, dependent: :delete_all

  # 通过identifier获取
  def self.by_identifiers(identifiers)
    self.where(id: BaosongB.where(identifier: identifiers).map { |b| b.baosong_a_id })
  end
end
