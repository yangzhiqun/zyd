class StatisticsController < ApplicationController

  def statistics
  end

  #任务统计
  def task_statistics
    #大类任务数统计
    #item_counts = {}
    #ACategory.all.each do |acategory|
    #  item_count = SpBsb.where(sp_s_17: acategory.name).all.count
    #  item_counts[acategory.name] = item_count
    #end
    #@item_counts = Hash[item_counts.sort_by{ |key, value| value }.reverse]
    names = ACategory.where.not(name:nil).distinct.pluck(:name)
    @item_counts = SpBsb.where("sp_s_17 != ''").group(:sp_s_17).count.sort_by{ |key, value| value }.reverse.to_h
    names.each{ |a| @item_counts[a]=0 unless @item_counts.has_key?(a) }
  end

  #食品类别统计
  def food_statistics
    @a_categories = ACategory.all
  end

  #不合格项目统计
  def nonconformity_statistics
    #good = []
    #bad = []
    #checkout_no = []
    #SpBsb.all.each do |sp_bsb|
    #  sp_bsb.spdata.all.each do |spdata|
    #    if spdata.spdata_2 == "合格项"
    #      good << spdata.id
    #    elsif spdata.spdata_2 == "不合格项"
    #      bad << spdata.id
    #    elsif spdata.spdata_2 == "未检验"
    #      checkout_no << spdata.id
    #    end
    #  end
    #end
    #@good = good.count
    #@bad = bad.count
    #@checkout_no = checkout_no.count
    @good = Spdatum.where(spdata_2:"合格项").count
    @bad  = Spdatum.where(spdata_2:"不合格项").count
    @checkout_no = Spdatum.where(spdata_2:"未检验").count
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
    @company_counts = SpBsb.where("sp_s_64 not in (?)",["","、","/","无"]).distinct.group(:sp_s_64).count
    @company_counts = @company_counts.sort_by{ |key, value| value }.reverse.to_h
  end

  #不合格样品及问题样品预警
  def early_warning
  end

  #复合查询统计
  def composite_statistics
    @circulation = SpBsb.where(sp_s_68:'流通').count
    @production = SpBsb.where(sp_s_68:'生产').count
    @catering = SpBsb.where(sp_s_68:'餐饮').count
  end

end
