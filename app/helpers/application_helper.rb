#encoding: utf-8
module ApplicationHelper
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def show_error(errors, field)
    if errors.has_key?(field)
      "&emsp;<span class='text-danger'>#{errors[field].first}</span>".html_safe
    end
  end

  def products_print_pager products, page_size, start_index
    return if products.nil? or products.length == 0
    page = (products.length / page_size.to_f).ceil
    page.times do |p|
      # @param 该页的产品
      # @param 起始编号
      # @param 是否最后一页
      yield products[(p*page_size)..((p + 1)*page_size - 1)], (start_index + (p * page_size) + 1), p, (p == page - 1), page if block_given?
    end
  end

  # 是否为二级站
  def is_ejz?
    SysConfig.get(SysConfig::Key::IS_EJZ, 0).to_i == 1
  end

  def beautify_field(v)
    return "-" if v.blank?
    return v
  end

  # 当前用户
  # @deprecated
  # def current_user
  #   if session[:user_id].blank?
  #     nil
  #   else
  #     if @current_user.nil?
  # 		@current_user = User.find(session[:user_id])
  # 	end
  # 	@current_user
  #   end
  # end

  def is_number?(str)
    true if Float(str) rescue false
  end

  def time_left(created_at, days)
    parts = []
    left_seconds = (days.days.to_i - (Time.now.to_i - created_at.to_i))

    if left_seconds < 0
      "<span class='label label-danger'>已超时，限时#{days}天</span>".html_safe
    else
      case (left_seconds.to_f / days.days.to_i)
        when 0..(0.3)
          lvl = 'danger'
        when (0.3)..(0.6)
          lvl = 'warning'
        when (0.6)..1
          lvl = 'info'
      end

      days_left = (left_seconds / 1.days.to_i).to_i

      parts.push "#{days_left}天" if days_left > 0

      hours_left = ((left_seconds - (days_left * 1.days.to_i)) / 1.hour.to_i).to_i

      parts.push "#{hours_left}小时" if hours_left > 0
      "<span class='label label-#{lvl}'>剩余时间：#{parts.join(',')}</span>".html_safe
    end
  end

  def auto_adjust_text_size text, max_length
    return "font-size: 12pt;" if not text
    max_length = max_length || "10"
    case text.length / max_length.to_f
      when 0..1
        return "font-size: 12pt;"
      when 1..1.5
        return "font-size: 10pt;"
      when 1.5..2
        return "font-size: 8pt;"
      else
        return "font-size: 6pt;"
    end
  end
	
	#是否是县级管理员
	def is_county_level?
		result = current_user.is_account_manager && current_user.user_i_js == 1 && current_user.admin_level == 3
		return result
	end

	#是否是市级管理员
	def is_city?
		result = current_user.is_account_manager && current_user.user_i_js == 1 && current_user.admin_level == 2
		return result
	end
  def is_sheng?
    result = current_user.is_account_manager && current_user.user_i_js == 1 && current_user.admin_level == 1
    return result
  end	

	#是否是省市县管理员
	def is_shengshi?
		result = current_user.is_account_manager && current_user.user_i_js == 1 && current_user.admin_level > 0
		return result
	end

  def is_shi_deploy?
   current_user.is_city? or ((!current_user.prov_city.blank? and !current_user.prov_city.include?('请选择')) and ( current_user.prov_country.include?('请选择') or current_user.prov_country.blank?))
  end

  def is_xian_deploy?
    current_user.is_county_level? or ((!current_user.prov_city.blank? and !current_user.prov_city.include?('请选择')) and (!current_user.prov_country.blank? and !current_user.prov_country.include?('请选择')))
  end
 def is_level?
     return "省级"  if  is_sheng?
     return "市级"  if  is_city?
     return "县级"  if is_county_level?                              
 end

  def generate_tab_params(tab)
    p = request.GET
    p[:page] = 1 if tab.to_i != p[:current_tab]
    p[:current_tab] = tab
    p.to_query
  end

  def sp_bsb_fields
    return {
        :bsb => {
            :sp_s_2_1 => true,
            :sp_s_70 => true,
            :sp_s_67 => true,
            :sp_s_1 => true,
            :sp_s_68 => true,
            :sp_s_2 => true,
            :sp_s_23 => true,
            :sp_s_215 => true,
            :sp_s_bsfl => true,
            :sp_s_201 => true,
            :sp_s_3 => true,
            :sp_s_4 => true,
            :sp_s_5 => true,
            :sp_s_7 => true,
            :sp_s_10 => true,
            :sp_s_8 => true,
            :sp_s_9 => true,
            :sp_s_11 => true,
            :sp_s_12 => true,
            :sp_s_14 => true,
            :sp_s_203 => true,
            :sp_n_15 => true,
            :sp_s_6 => true,
            :sp_s_16 => true,
            :sp_s_17 => true,
            :sp_s_18 => true,
            :sp_s_19 => true,
            :sp_s_20 => true,
            :sp_s_61 => true,
            :sp_s_62 => true,
            :sp_s_63 => true,
            :sp_s_21 => true,
            :sp_d_22 => true,
            :sp_s_24 => true,
            :sp_s_25 => true,
            :sp_s_26 => true,
            :sp_s_27 => true,
            :sp_d_28 => true,
            :sp_n_29 => true,
            :sp_s_66 => false,
            :sp_s_13 => true,
            :sp_s_72 => true,
            :sp_s_73 => true,
            :sp_s_74 => true,
            :sp_s_204 => true,
            :sp_s_205 => true,
            :sp_s_206 => true,
            :sp_s_207 => true,
            :sp_s_208 => true,
            :sp_s_64 => true,
            :sp_s_65 => true,
            :sp_s_202 => true,
            :sp_s_75 => true,
            :sp_s_76 => true,
            :sp_s_30 => true,
            :sp_n_31 => true,
            :sp_s_33 => true,
            :sp_n_32 => true,
            :sp_s_209 => true,
            :sp_s_210 => true,
            :sp_s_34 => true,
            :sp_s_35 => true,
            :sp_s_36 => true,
            :sp_s_52 => true,
            :sp_s_37 => true,
            :sp_d_38 => true,
            :sp_s_39 => true,
            :sp_s_40 => true,
            :sp_s_41 => true,
            :sp_s_42 => true,
            :sp_s_211 => true,
            :sp_s_212 => true,
            :sp_s_213 => true,
            :sp_s_43 => true,
            :sp_s_44 => true,
            :sp_s_45 => true,
            :sp_d_46 => true,
            :sp_d_47 => true,
            :sp_s_48 => true,
            :sp_s_49 => true,
            :sp_s_50 => true,
            :sp_s_51 => true,
            :sp_s_71 => true,
            :sp_s_214 => true,
            :sp_s_84 => true,
            :sp_s_85 => true,
            :sp_d_86 => true,
            :sp_s_87 => true,
            :sp_s_88 => true,
            :sp_xkz => true,
            :sp_xkz_id => true
        },
        :jcx => {
            :spdata_0 => true,
            :spdata_1 => true,
            :spdata_18 => true,
            :spdata_2 => true,
            :spdata_3 => true,
            :spdata_4 => true,
            :spdata_5 => true,
            :spdata_6 => true,
            :spdata_7 => true,
            :spdata_8 => true,
            :spdata_9 => true,
            :spdata_10 => true,
            :spdata_11 => true,
            :spdata_12 => true,
            :spdata_13 => true,
            :spdata_14 => true,
            :spdata_15 => true,
            :spdata_16 => true
        }
    }
  end
end
