class SwitchController < ApplicationController
  def index
   @switchs = YAML.load_file("config/use_ca.yml")
   @hash = {"open_ca"=>"启用CA电子检验报告", "is_open"=>"开启样品数据录入", "is_user_jg"=>"对接统一登录", "is_open_to_wochacha"=>"对接抽样平台"}
   respond_to do |format|
     unless current_user.is_admin?
       format.html { render :text => "您没有该权限" }
     else
       format.html
       format.json { render json: @switchs }
     end
   end
  end

  def update_radio
    hash =  YAML.load_file("config/use_ca.yml")
    hash.each do |k,y|
      hash[k] = eval(params[k])
    end
    File.open(Rails.root.to_s + '/config/use_ca.yml', 'w') { |f| YAML.dump(hash, f) }
    respond_to do |format|
      format.html { redirect_to "/switch",notice: '更新成功！' }
    end
  end
end
