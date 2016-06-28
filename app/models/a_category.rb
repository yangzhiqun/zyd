class ACategory < ActiveRecord::Base
  acts_as_paranoid

  has_many :b_categories, dependent: :delete_all
  has_many :c_categories, dependent: :delete_all
  has_many :d_categories, dependent: :delete_all
  has_many :check_items, dependent: :delete_all

  def rowspan
    return @rowspan if @rowspan.present?
    @rowspan = DCategory.where('a_category_id = ?', self.id).count
  end

  Category24 = %w{
      粮食加工品
      食用油、油脂及其制品
      调味品
      肉制品
      乳制品
      饮料
      方便食品
      饼干
      罐头
      冷冻饮品
      速冻食品
      薯类和膨化食品
      糖果制品
      茶叶及相关制品
      酒类
      蔬菜制品
      水果制品
      炒货食品及坚果制品
      蛋制品
      可可及焙烤咖啡产品
      食糖
      水产制品
      淀粉及淀粉制品
      糕点
      豆制品
      蜂产品
      保健食品
      特殊医学用途配方食品
      婴幼儿配方食品
      特殊膳食食品
      餐饮食品
      食用农产品
      食品添加剂
  }
end
