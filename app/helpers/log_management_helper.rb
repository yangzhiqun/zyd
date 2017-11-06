#encoding: utf-8
module LogManagementHelper
  #Action = {"create" => "新增", "destroy" => "删除", "update" => "修改"}
  
  def obtain_name(action_name,key,value,t_name) 
    case action_name
      when "update"
        "修改#{I18n.t("table_name.#{t_name}")}  #{I18n.t("#{t_name}.#{key}")} 为 #{value}"
      when "create"
        "创建 #{I18n.t("table_name.#{t_name}")}"
      when "destroy"
        "删除 #{I18n.t("table_name.#{t_name}")}"
    end
  end
end
