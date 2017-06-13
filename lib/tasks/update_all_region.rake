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
    else
      @logger.info { "JgBsb >>> id:#{jg_bsb.id},jg_province:#{jg_bsb.jg_province},city:#{jg_bsb.city},country:#{jg_bsb.country}" } 
    end
  end
  @logger.info { "1"*80 }
  p "****************机构更新结束****************"
  User.all.each do |user|
    user.user_s_province = @hash[user.user_s_province][0] if result(0,@hash,user.user_s_province)
    user.prov_city = @hash[user.prov_city][0] if result(1,@hash,user.prov_city)
    user.prov_country = @hash[prov_country][0] if result(2,@hash,user.prov_country)
    if user.changed?
      user.save
    else
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
    else
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
      else
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
