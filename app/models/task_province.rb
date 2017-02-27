class TaskProvince < ActiveRecord::Base
  #attr_accessible :identifier, :a_category_id, :note, :sys_province_id, :quota, :year

  belongs_to :a_category
  belongs_to :sys_province
  belongs_to :baosong_b

  def task_executed_count
    PadSpBsb.where(:sp_s_3 => self.sys_province.name).count
  end
end
