module SampleMembersHelper
  def action_obtain_name(action_name,key,value,t_name)
    case action_name
      when "update"
        "修改#{I18n.t("table_name.#{t_name}")}"
      when "create"
        "创建 #{I18n.t("table_name.#{t_name}")}"
      when "destroy"
         "删除 #{I18n.t("table_name.#{t_name}")}"
      end
  end

end
