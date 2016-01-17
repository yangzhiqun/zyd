class ACategory < ActiveRecord::Base
  # attr_accessible :bgfl_id, :name, :note, :identifier

  has_many :b_categories, dependent: :delete_all
  has_many :c_categories, dependent: :delete_all
  has_many :d_categories, dependent: :delete_all
  has_many :check_items, dependent: :delete_all

  def rowspan
    DCategory.where('a_category_id = ?', self.id).count
  end

  Category24 = %w{
    粮食及粮食制品
    食用油、油脂及其制品
    肉及肉制品
    蛋及蛋制品
    蔬菜及其制品
    水果及其制品
    水产及水产制品
    饮料
    调味品
    食糖
    酒类
    焙烤食品
    茶叶及其相关制品、咖啡
    薯类及膨化食品
    糖果及可可制品
    炒货食品及坚果制品
    豆类及其制品
    蜂产品
    冷冻饮品
    罐头
    乳制品
    特殊膳食食品
    食品添加剂
    餐饮食品
  }
end
