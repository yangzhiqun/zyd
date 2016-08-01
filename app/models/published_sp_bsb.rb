#encoding: utf-8
class PublishedSpBsb < ActiveRecord::Base
  validates_uniqueness_of :cjbh, message: '请勿重复发布'
end
