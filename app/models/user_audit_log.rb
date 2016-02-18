class UserAuditLog < ActiveRecord::Base
  validates_presence_of :user_id, message: '对象用户ID不可为空'
  validates_presence_of :operator_id, message: '操作用户ID不可为空'
  validates_presence_of :action, message: '动作标识代码不可为空'

  belongs_to :operator, class_name: User, foreign_key: :operator_id

  module Action
    JgPass = 0x00000001
    JgFail = 0x00000002
    SjPass = 0x00000003
    SjFail = 0x00000004
    UserReq = 0x00000005
  end
end
