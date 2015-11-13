#encoding: utf-8
class PublishedSpBsb < ActiveRecord::Base
  attr_accessible :cjbh, :published_at, :user_id, :cfda_published_at

  validates_uniqueness_of :cjbh, message: '请勿重复发布'
end
