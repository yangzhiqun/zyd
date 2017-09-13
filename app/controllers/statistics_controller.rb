class StatisticsController < ApplicationController

  def statistics
  end

  #任务统计
  def task_statistics
    #大类任务数统计
    item_counts = {}
    ACategory.all.each do |acategory|
      item_count = SpBsb.where(sp_s_17: acategory.name).all.count
      item_counts[acategory.name] = item_count
    end
    @item_counts = Hash[item_counts.sort_by{ |key, value| value }.reverse]
  end

  #食品类别统计
  def food_statistics
    @a_categories = ACategory.all
  end

  #不合格项目统计
  def nonconformity_statistics
    good = []
    bad = []
    checkout_no = []
    SpBsb.all.each do |sp_bsb|
      sp_bsb.spdata.all.each do |spdata|
        if spdata.spdata_2 == "合格项"
          good << spdata.id
        elsif spdata.spdata_2 == "不合格项"
          bad << spdata.id
        elsif spdata.spdata_2 == "未检验"
          checkout_no << spdata.id
        end
      end
    end
    @good = good.count
    @bad = bad.count
    @checkout_no = checkout_no.count
  end

  #承检单位统计
  def unit_statistics

  end

  #抽样及检验超期统计
  def overtime_statistics
    @a_categories = ACategory.all
  end

  #核查处置统计
  def disposal_statistics
  end

  #企业覆盖率统计
  def enterprise_statistics
    companies = []
    company_counts = {}
    SpBsb.all.collect {|spbsb| companies << spbsb.sp_s_64}
    companies = (companies - [''] - ['/'] - ['、'] - ['无']).uniq
    companies.each do |company|
      company_counts[company] = SpBsb.where(sp_s_64: company).all.count
    end
    @company_counts = Hash[company_counts.sort_by{ |key, value| value }.reverse]
  end

  #不合格样品及问题样品预警
  def early_warning
  end

  #复合查询统计
  def composite_statistics
    @circulation = SpBsb.where(sp_s_68:'流通').all.count
    @production = SpBsb.where(sp_s_68:'生产').all.count
    @catering = SpBsb.where(sp_s_68:'餐饮').all.count
  end

end
