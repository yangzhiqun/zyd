#encoding: utf-8
class JgBsbName < ActiveRecord::Base
  # attr_accessible :creator_user_id, :jg_bsb_id, :name, :note

  validates_uniqueness_of :name, :message => '此名称已存在'
  validates_presence_of :name, :message => '请提供名称'
  validates_presence_of :jg_bsb_id, :message => '机构id不可为空'

  belongs_to :jg_bsb

  after_save :doing_after_update

  def doing_after_update
    `/bin/bash -l -c 'cd #{Rails.root.to_s} && bin/rake tmp:cache:clear RAILS_ENV=production'`
  end
end
