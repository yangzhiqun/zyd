#encoding: utf-8
require "csv"
require "logger"
  
# JgBsb jg_province city country
# User  user_s_province prov_city prov_country
# SpBsb sp_s_3 sp_s_4 sp_s_5
#       sp_s_202 sp_s_220 sp_s_221
# WtypCzb bsscqy_sheng sp_s_220(bsscqy_shi) sp_s_221(bsscqy_xian)
#         bcydw_sheng  bcydw_shi(sp_s_4) bcydw_xian(sp_s_5)
# WtypCzbPart bsscqy_sheng sp_s_220(bsscqy_shi) sp_s_221(bsscqy_xian)
#         bcydw_sheng  bcydw_shi(sp_s_4) bcydw_xian(sp_s_5)
desc '刷新各表区域字段'
task :update_all_region, [:csv_file] => :environment do |t, args|
  unless File.exist?(args[:csv_file]) and File.extname(args[:csv_file]) == ".csv"
    p "没有该文件或者文件类型错误" and return
  end
  @logger = Logger.new("tmp/cache/tongji.log")
  @hash = {}
  @csv = CSV.open(args[:csv_file]).read
                 #原字段       新字段 编号
  @csv.each{ |c| @hash[c[0]] = [c[1],c[2]] }
  p "----------------------START---------------------"
  JgBsb.all.each do |jg_bsb|
    jg_bsb.jg_province = @hash[jg_bsb.jg_province][0] if result(0,@hash,jg_bsb.jg_province)
    jg_bsb.city = @hash[jg_bsb.city][0] if result(1,@hash,jg_bsb.city)
    jg_bsb.country = @hash[jg_bsb.country][0] if result(2,@hash,jg_bsb.country)
    if jg_bsb.changed?
      jg_bsb.save
      @logger.info { "JgBsb >>> id:#{jg_bsb.id},jg_province:#{jg_bsb.jg_province},city:#{jg_bsb.city},country:#{jg_bsb.country}" } 
    end
  end
  @logger.info { "1"*80 }
  p "****************机构更新结束****************"
  User.all.each do |user|
    user.user_s_province = @hash[user.user_s_province][0] if result(0,@hash,user.user_s_province)
    user.prov_city = @hash[user.prov_city][0] if result(1,@hash,user.prov_city)
    user.prov_country = @hash[user.prov_country][0] if result(2,@hash,user.prov_country)
    if user.changed?
      user.save
      @logger.info { "User >>> id:#{user.id},user_s_province:#{user.user_s_province},prov_city:#{user.prov_city}," } 
    end
  end
  @logger.info { "2"*80 }
  p "****************用户更新结束****************"
  SpBsb.all.each do |sp_bsb|
    sp_bsb.sp_s_3   = @hash[sp_bsb.sp_s_3][0] if result(0,@hash,sp_bsb.sp_s_3)
    sp_bsb.sp_s_4   = @hash[sp_bsb.sp_s_4][0] if result(1,@hash,sp_bsb.sp_s_4)
    sp_bsb.sp_s_5   = @hash[sp_bsb.sp_s_5][0] if result(2,@hash,sp_bsb.sp_s_5)
    sp_bsb.sp_s_202 = @hash[sp_bsb.sp_s_202][0] if result(0,@hash,sp_bsb.sp_s_202)
    sp_bsb.sp_s_220 = @hash[sp_bsb.sp_s_220][0] if result(1,@hash,sp_bsb.sp_s_220)
    sp_bsb.sp_s_221 = @hash[sp_bsb.sp_s_221][0] if result(2,@hash,sp_bsb.sp_s_221)
    if sp_bsb.changed?
      sp_bsb.save
      @logger.info { "SpBsb >>> id:#{sp_bsb.id},#{sp_bsb.sp_s_3},#{sp_bsb.sp_s_4},#{sp_bsb.sp_s_5},#{sp_bsb.sp_s_202},#{sp_bsb.sp_s_220},#{sp_bsb.sp_s_221}" } 
    end
  end
  @logger.info { "3"*80 }
  p "**************基本信息更新结束**************"
  arr = ["WtypCzb","WtypCzbPart"]  
  arr.each do |ar|
    ar.constantize.all.each do |wtyp_czb|
      wtyp_czb.bsscqy_sheng = @hash[wtyp_czb.bsscqy_sheng][0] if result(0,@hash,wtyp_czb.bsscqy_sheng)
      wtyp_czb.bsscqy_shi   = @hash[wtyp_czb.bsscqy_shi][0]   if result(1,@hash,wtyp_czb.bsscqy_shi)
      wtyp_czb.bsscqy_xian  = @hash[wtyp_czb.bsscqy_xian][0]  if result(2,@hash,wtyp_czb.bsscqy_xian)
      wtyp_czb.sp_s_220     = @hash[wtyp_czb.sp_s_220][0]     if result(1,@hash,wtyp_czb.sp_s_220)
      wtyp_czb.sp_s_221     = @hash[wtyp_czb.sp_s_221][0]     if result(2,@hash,wtyp_czb.sp_s_221)

      wtyp_czb.bcydw_sheng  = @hash[wtyp_czb.bcydw_sheng][0] if result(0,@hash,wtyp_czb.bcydw_sheng)
      wtyp_czb.bcydw_shi    = @hash[wtyp_czb.bcydw_shi][0]   if result(1,@hash,wtyp_czb.bcydw_shi)
      wtyp_czb.bcydw_xian   = @hash[wtyp_czb.bcydw_xian][0]  if result(2,@hash,wtyp_czb.bcydw_xian)
      wtyp_czb.sp_s_4       = @hash[wtyp_czb.sp_s_4][0]      if result(1,@hash,wtyp_czb.sp_s_4)
      wtyp_czb.sp_s_5       = @hash[wtyp_czb.sp_s_5][0]      if result(2,@hash,wtyp_czb.sp_s_5)
      if wtyp_czb.changed?
        wtyp_czb.save
        @logger.info { "#{ar} >>> id:#{wtyp_czb.id},#{wtyp_czb.bsscqy_sheng},#{wtyp_czb.bsscqy_shi},#{wtyp_czb.bsscqy_xian}" } 
      end
    end
  end
  @logger.info { "4"*80 }
  p "**************核查处置更新结束**************"
  p "-----------------------END----------------------"
end

# 判断是否可以更改字段
# 0省 1市 2县
def result(num,hash,name)
  if hash.has_key?(name)  
    if hash[name][1].scan(/\./).length == num 
      return true
    end 
  end 
  return false
end

# csv 第一列：老数据;第二列：新数据;第三列：level
# 更名说明：红色的区划需要找到对应的市级政府，然后再更新。不能直接更新。
# 例如：高新区，可能在别的市是对的，但是在另一个市就是错的。
desc '更新不同市但县可能相同的数据'
task :update_repeat_xian, [:csv_file] => :environment do |t, args|
  unless File.exist?(args[:csv_file]) and File.extname(args[:csv_file]) == ".csv"
    p "没有该文件或者文件类型错误" and return
  end
  @logger = Logger.new("tmp/cache/update_completed.log")
  @hash = {}
  @csv = CSV.open(args[:csv_file]).read
                 #原字段       新字段 编号
  @csv.each { |c| @hash[c[0]] = [c[1],c[2]] }
  @keys = @hash.keys
  p "----------------------START---------------------"
  jg_bsbs   = JgBsb.where("country in (?)", @keys)  
  users     = User.where("prov_country in (?)", @keys)
  sp_bsbs   = SpBsb.where("sp_s_5 in (?) or sp_s_221 in (?)", @keys, @keys)
  wtyp_czbs = WtypCzb.where("bsscqy_xian in (?) or sp_s_221 in (?) or bcydw_xian in (?) or sp_s_5 in (?)", @keys, @keys,@keys, @keys)
  wtyp_czb_parts = WtypCzbPart.where("bsscqy_xian in (?) or sp_s_221 in (?) or bcydw_xian in (?) or sp_s_5 in (?)", @keys, @keys, @keys, @keys) 

  if jg_bsbs.present? 
    jg_bsbs.each do |jg_bsb| 
      if country_result(jg_bsb.jg_province,jg_bsb.city,@hash[jg_bsb.country][1])
        jg_bsb.country = @hash[jg_bsb.country][0]
        @logger.info { "JgBsb >>> id:#{jg_bsb.id}" } if jg_bsb.save
      end
    end
  end
  @logger.info { "1"*80 }
  p "****************机构更新结束****************"
  if users.present?
    users.each do |user| 
      if country_result(user.user_s_province,user.prov_city,@hash[user.prov_country][1])
        user.prov_country = @hash[user.prov_country][0]
        @logger.info { "User >>> id:#{user.id}" } if user.save
      end
    end
  end
  @logger.info { "2"*80 }
  p "****************用户更新结束****************"
  if sp_bsbs.present?
    sp_bsbs.each do |sp_bsb| 
      if @hash.has_key?(sp_bsb.sp_s_5)
        if country_result(sp_bsb.sp_s_3,sp_bsb.sp_s_4,@hash[sp_bsb.sp_s_5][1]) 
          sp_bsb.sp_s_5 = @hash[sp_bsb.sp_s_5][0]
        end
      end
      if @hash.has_key?(sp_bsb.sp_s_221)
        if country_result(sp_bsb.sp_s_202,sp_bsb.sp_s_220,@hash[sp_bsb.sp_s_221][1])
          sp_bsb.sp_s_221 = @hash[sp_bsb.sp_s_221][0] 
        end
      end
      if sp_bsb.changed?
        @logger.info { "SpBsb >>> id:#{sp_bsb.id}" } if sp_bsb.save
      end
    end
  end
  @logger.info { "3"*80 }
  p "**************基本信息更新结束**************"
  wtyp_arr = [wtyp_czbs,wtyp_czb_parts]
  wtyp_arr.each_with_index do |wtyp,index|
    if wtyp.present?
      wtyp.each do |w|
        if @hash.has_key?(w.bsscqy_xian)
          if country_result(w.bsscqy_sheng,w.bsscqy_shi,@hash[w.bsscqy_xian][1]) 
            w.bsscqy_xian = @hash[w.bsscqy_xian][0]
          end
        end
        if @hash.has_key?(w.sp_s_221)
          if country_result(w.cydwsf,w.sp_s_220,@hash[w.sp_s_221][1]) 
            w.sp_s_221 = @hash[w.sp_s_221][0]
          end
        end
        if @hash.has_key?(w.bcydw_xian)
          if country_result(w.bcydw_sheng,w.bcydw_shi,@hash[w.bcydw_xian][1]) 
            w.bcydw_xian = @hash[w.bcydw_xian][0]
          end
        end
        if @hash.has_key?(w.sp_s_5)
          if country_result(w.cydwsf,w.sp_s_4,@hash[w.sp_s_5][1]) 
            w.sp_s_5 = @hash[w.sp_s_5][0]
          end
        end
        if w.changed?
          @logger.info { "#{index == 0 ? 'WtypCzb':'WtypCzbPart'} >>> id:#{w.id}" } if w.save
        end
      end
    end
  end
  @logger.info { "4"*80 }
  p "**************核查处置更新结束**************"
  p "-----------------------END----------------------"
end

# 判断是否可以更改字段(针对县)
def country_result(province,city,level)
  arr = level.split(".")
  s_province = SysProvince.find_by_level(arr[0]).name
  s_city     = SysProvince.find_by_level(arr[0]+"."+arr[1]).name
  if province == s_province and city == s_city
    return true
  end
  return false
end
