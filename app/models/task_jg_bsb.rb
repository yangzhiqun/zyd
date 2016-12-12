#encoding: utf-8
class TaskJgBsb < ActiveRecord::Base
  # attr_accessible :identifier, :sys_province_id, :a_category_id, :b_category_id, :c_category_id, :d_category_id, :jg_bsb_id, :note, :quota

  validate :check_quota_amount

  belongs_to :jg_bsb

  def a_category
    ACategory.find(self.a_category_id)
  end

  # 按机构获取已下达任务的数量
  def assigned_count_by_jg
    PadSpBsb.where('jg_bsb_id = ? and a_category_id = ?', self.jg_bsb_id, self.a_category_id).count
  end

  # 按机构获取已完成任务的数量
  def finished_count_by_jg
    PadSpBsb.where('jg_bsb_id = ? AND a_category_id = ? AND sp_i_state = 9', self.jg_bsb_id, self.a_category_id).count
  end

  private
  def check_quota_amount
    #//// 检查配额是否超限
    if self.sys_province_id != -1
      prov_quota = TaskProvince.where(sys_province_id: self.sys_province_id,identifier: self.identifier, a_category_id: self.a_category_id,b_category_id: self.b_category_id,c_category_id: self.c_category_id,d_category_id: self.d_category_id).sum('quota')
      current_prov_amount = TaskJgBsb.where(identifier: self.identifier, a_category_id: self.a_category_id, sys_province_id: self.sys_province_id,b_category_id: self.b_category_id,c_category_id: self.c_category_id,d_category_id: self.d_category_id,).sum('quota')
      if current_prov_amount + self.quota > prov_quota
        errors.add(:quota, "配额超限，仅剩：#{prov_quota - current_prov_amount}批")
        return false
      end
    end
  end
end
