#encoding=UTF-8
class SpBsbInfoPublication < ActiveRecord::Base
  validates_presence_of :cjbh, message: '抽样编号不能为空'
  validates_uniqueness_of :cjbh, message: '抽样编号已存在'
  validates_presence_of :fl, message: '分类不能为空'
  validates_presence_of :ggh, message: '公告号不能为空'
  validates_presence_of :ggrq, message: '公告日期格式有误，或者为空'
  validates_presence_of :rwly, message: '任务来源不能为空'
  # validates_presence_of :jyjg, message: '检验机构不能为空'
end
