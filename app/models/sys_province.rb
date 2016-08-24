#encoding: utf-8
class SysProvince < ActiveRecord::Base
  # attr_accessible :name, :note, :code, :level

  scope :level1, -> {
    prov = SysProvince.where("level like '_' or level like '__'").find_by_name(SysConfig.get(SysConfig::Key::PROV))
    where('level LIKE ? or level LIKE ?', "#{prov.level}._", "#{prov.level}.__")
  }
  scope :level2, -> {
    prov = SysProvince.where("level like '_' or level like '__'").find_by_name(SysConfig.get(SysConfig::Key::PROV))
    where('level LIKE ? or level LIKE ? or level LIKE ? or level LIKE ?', "#{prov.level}._._", "#{prov.level}.__._", "#{prov.level}.__.__", "#{prov.level}._.__")
  }
   scope :level1_old, -> { where("level LIKE '_' or level LIKE '__'") }

  validates_uniqueness_of :code, :message => '已存在该编号', allow_nil: true
  validates_uniqueness_of :level, :message => '已存在该省份'
  validates_presence_of :name, message: '请提供名称'

  has_many :task_provinces

  def self.all_to_json
    @result = {}

    @level1 = SysProvince.select("name, level").where("level LIKE '_' OR level LIKE '__'")
    @level1.each do |lvl1|
      @result[lvl1.name] = {} if @result[lvl1.name].blank?

      @level2 = SysProvince.select("name, level").where("level LIKE ? OR level LIKE ?", "#{lvl1.level}._", "#{lvl1.level}.__")
      @level2.each do |lvl2|
        @result[lvl1.name][lvl2.name] = [] if @result[lvl1.name][lvl2.name].blank?
        @level3 = SysProvince.select("name, level").where("level LIKE ? OR level LIKE ?", "#{lvl2.level}._", "#{lvl2.level}.__")

        @level3.each do |lvl3|
          @result[lvl1.name][lvl2.name].push(lvl3.name)
        end
      end
    end
    @result
  end

  def generate_level(parent_level)
    if parent_level.blank?
      self.level = ((15..10000).to_a - SysProvince.level1_old.map { |prov| prov.level.split('.').last.to_i }.uniq).first.to_s
    else
      self.level = parent_level + '.' + ((15..10000).to_a - SysProvince.where('level like ? or level like ?', "#{parent_level}._", "#{parent_level}.__").map { |prov| prov.level.split('.').last.to_i }.uniq).first.to_s
    end
  end
end
