class BaosongA < ActiveRecord::Base
  # attr_accessible :name, :note, :rwlylx, :prov
  has_many :baosong_bs, dependent: :delete_all
  has_many :baosong_a_jg_ids, dependent: :delete_all
  attr_accessor :jg_ids
  belongs_to :jg_id
  after_save :create_jg_ids
  #after_update :create_jg_ids
  # 通过identifier获取
  def self.by_identifiers(identifiers)
    self.where(id: BaosongB.where(identifier: identifiers).map { |b| b.baosong_a_id })
  end
  def create_jg_ids
    ids = self.jg_ids
    if ids.present?
      ids.delete('')
      ids = ids.map { |j| j.to_i }
      self.baosong_a_jg_ids.where('jg_bsb_id not in (?)', ids).destroy_all
      self.baosong_a_jg_ids.reload
      (ids - self.baosong_a_jg_ids.pluck(:id)).each do |i|
        BaosongAJgId.create(baosong_a_id: self.id, jg_bsb_id: i)
      end
    end
  end
end
