module SampleMembersHelper
  def action_obtain_name(i)
    case i.action
      when "update"
        "修改: #{i.user.tname},数据状态: #{SpBsb.state_type(i.audited_changes["sp_i_state"][1])}"
      when "create"
        "创建: #{i.user.tname}, 抽样编号: #{i.audited_changes["sp_s_16"]},数据状态: #{SpBsb.state_type(i.audited_changes["sp_i_state"])} "
      when "destroy"
         "删除：#{i.user.tname}, 抽样编号: #{i.audited_changes["sp_s_16"]},数据状态: #{SpBsb.state_type(i.audited_changes["sp_i_state"])}"
      end
  end

end
