class ACategory < ActiveRecord::Base
  # attr_accessible :bgfl_id, :name, :note, :identifier

  has_many :b_categories, dependent: :delete_all
  has_many :c_categories, dependent: :delete_all
  has_many :d_categories, dependent: :delete_all
  has_many :check_items, dependent: :delete_all

  def rowspan
    DCategory.count(:conditions => ["a_category_id = ?", self.id])
  end

  Category24 = %w{粮食及粮食制品
    食用油、油脂及其制品
    肉及肉制品
    蛋及蛋制品
    水产及水产制品
    蔬菜及其制品
    饮料
    调味品
    酒类
    茶叶及其相关制品、咖啡
    薯类及膨化食品
    糖果及可可制品
    炒货食品及坚果制品
    豆及豆制品
    蜂产品
    冷冻饮品
    乳制品
    特殊膳食食品
    食品添加剂
    焙烤食品
    罐头
    食糖
    水果及其制品
  }
end
