#encoding: utf-8
class WtypCzbPart < ActiveRecord::Base
  attr_accessor :tmp_save, :part_submit, :current_user, :reverting, :save_me
  belongs_to :sp_bsb
  belongs_to :wtyp_czb

  before_save :update_step, :if => Proc.new { |part| !part.current_user.blank? }

  # 更新问题样品处置的状态
  before_update :update_state_desc_from_current_state

  after_update :callback_when_updated

  def state_desc2
    case self.current_state
      when ::WtypCzb::State::LOGGED
        '未处置'
      when ::WtypCzb::State::ASSIGNED
        if self.part_submit_flag1 or self.part_submit_flag2 or self.part_submit_flag3 or self.part_submit_flag4 or self.part_submit_flag5 or self.part_submit_flag6 or self.part_submit_flag7
          return '处置中'
        else
          return '未处置'
        end
      when ::WtypCzb::State::FILLED
        '处置中'
      when ::WtypCzb::State::PASSED
        '处置完毕'
      else
        '-'
    end
  end

  has_many :published_wtyp_czbs, foreign_key: 'cjbh', primary_key: 'cjbh'

  def wtyp_czb_publication_status
    p = self.published_wtyp_czbs.where(wtyp_czb_type: self.wtyp_czb_type).first
    if p.nil?
      return '<i style="color: red;">未发布</i>'
    else
      return '<i style="color: green;">已发布</i>'
    end
  end

  def yydjb
    SpYydjb.find_by_cjbh(self.cjbh)
  end

  module Type
    SC = 1
    LT = 2
    CY = 3
  end

  def wtyp_czb_type_desc
    case self.wtyp_czb_type
      when Type::SC
        '生产'
      when Type::LT
        '流通'
      when Type::CY
        '餐饮'
    end
  end

  def czfzr_desc
    if self.czfzr.blank?
      ""
    else
      User.find(self.czfzr.to_i).tname
    end
  end

  def deadline_warning
    days_diff = Time.now - self.sp_bsb.updated_at

    if days_diff > 5 and !part_submit_flag1
      return 'danger'
    end

    if days_diff > 20 and !part_submit_flag2
      return 'danger'
    end

    if days_diff > 90 and !part_submit_flag3
      return 'danger'
    end
    ''
  end

  def visible_for_user?(user, type)
    return true
    return true if user.hcz_admin == 1
    case type
      when ::WtypCzbPart::Type::SC
        return false if self.bsscqy_sheng.blank?
        return self.bsscqy_sheng.eql?(user.user_s_province)
      when ::WtypCzbPart::Type::LT
        return false if self.bcydw_sheng.blank?
        return self.bcydw_sheng.eql?(user.user_s_province)
      else
        false
    end
  end

  # 问题原因
  def wtyy
    yy = []
    if self.wtyp_czb_type == ::WtypCzbPart::Type::SC
      yy.push "人为添加" if self.pczgfc_2 == 1
      yy.push "原料问题" if self.pczgfc_11 == 1
      yy.push "生产工艺" if self.pczgfc_12 == 1
      yy.push "过程控制不严" if self.pczgfc_13 == 1
      yy.push "储运不当" if self.pczgfc_14 == 1
      yy.push "包装迁移" if self.pczgfc_15 == 1
      yy.push "标签标识问题" if self.pczgfc_16 == 1
      yy.push "其他" if self.pczgfc_17 == 1

      yy.join("，")
    else
      yy.push "生产" if self.yypc_yylbsc == 1
      yy.push "运输" if self.yypc_yylbys == 1
      yy.push "销售" if self.yypc_yylbxs == 1
      yy.join("，")
    end
  end

  def scqy_info
    return '' if ['/', ''].include? self.bsscqymc
    count = WtypCzb.where('bsscqymc = ?', self.bsscqymc).count
    if count >= 3
      "<span class='text-danger'>同企: #{count}次</span>".html_safe
    else
      "<span>同企: #{count}次</span>".html_safe
    end
  end

  def bhg_item_info
    ul = []
    ul.push('<ol><li>同项：</li>')
    self.wtyp_czb.sp_hcz_spdatas.each do |hczdata|
      count = SpHczSpdata.where('spdata_0 = ?', hczdata.spdata_0).count
      ul.push("<li>&emsp;#{hczdata.spdata_0}: #{count}次</li>")
    end
    ul.push('</ol>')
    ul.join('').html_safe
  end

  def spxl_info
    count = WtypCzb.where('SPXL = ?', self.SPXL).count
    if count >= 3
      "<span class='text-danger'>同类: #{count}次</span>".html_safe
    else
      "<span>同类: #{count}次</span>".html_safe
    end
  end

  # 是否正在异议登记
  # TODO: 描述逻辑
  def is_prevented_by_yydj?
    yydjb = SpYydjb.find_by_cjbh(self.cjbh)
    return false if yydjb.nil? or self.new_record?

    if yydjb.created_at.to_i <= self.created_at.to_i
      if yydjb.yy_succeed? or yydjb.yy_in_progress?
        return false
      else
        return true
      end
    else
      return true
    end
  end

 # def enable_operation?(user)
  #  case self.current_state
   #   when ::WtypCzb::State::LOGGED
    #    return false
     # when ::WtypCzb::State::ASSIGNED
      #  user.hcz_admin != 1 and user.hcz_czbl == 1 \
			#and ((self.wtyp_czb_type == ::WtypCzbPart::Type::SC && self.bsscqy_sheng.eql?(user.user_s_province) && (self.bsscqy_shi.eql?(user.prov_city) || self.sp_s_220.eql?(user.prov_city)) && (self.bsscqy_xian.eql?(user.prov_country) || self.sp_s_221.eql?(user.prov_country))) or ([::WtypCzbPart::Type::LT, ::WtypCzbPart::Type::CY].include?(self.wtyp_czb_type) && self.bcydw_sheng.eql?(user.user_s_province) && (self.bcydw_shi.eql?(user.prov_city) || self.sp_s_4.eql?(user.prov_city)) && (self.bcydw_xian.eql?(user.prov_country) || self.sp_s_5.eql?(user.prov_country)))) \
			#and self.czfzr.to_i == user.id
      #  logger.error self.czfzr
       # logger.error user.id
      #when ::WtypCzb::State::FILLED
      #  user.hcz_admin != 1 and user.hcz_czsh == 1 \
			#and ((self.wtyp_czb_type == ::WtypCzbPart::Type::SC && self.bsscqy_sheng.eql?(user.user_s_province) && (self.sp_s_220.eql?(user.prov_city) or self.bsscqy_shi.eql?(user.prov_city)) && (self.sp_s_221.eql?(user.prov_country) or self.bsscqy_xian.eql?(user.prov_country))) or ([::WtypCzbPart::Type::LT, ::WtypCzbPart::Type::CY].include?(self.wtyp_czb_type) && self.bcydw_sheng.eql?(user.user_s_province) && (self.bcydw_shi.eql?(user.prov_city) || self.sp_s_4.eql?(user.prov_city)) && (self.bcydw_xian.eql?(user.prov_country) || self.sp_s_5.eql?(user.prov_country))))
      #when ::WtypCzb::State::PASSED
      #  return false
    #end
 # end

  def enable_operation?(user)
    case self.current_state
      when ::WtypCzb::State::LOGGED
        return false
      when ::WtypCzb::State::ASSIGNED
      info = ( user.hcz_admin != 1 and user.hcz_czbl == 1 \
      and self.czfzr.to_i == user.id \
			and ((self.wtyp_czb_type == ::WtypCzbPart::Type::SC && self.bsscqy_sheng.eql?(user.user_s_province)) or ([::WtypCzbPart::Type::LT, ::WtypCzbPart::Type::CY].include?(self.wtyp_czb_type) && self.bcydw_sheng.eql?(user.user_s_province))))
        if(info.class==FalseClass) then
          return false
        else
          return true
        end
      when ::WtypCzb::State::FILLED
       info = ( user.hcz_admin != 1 and user.hcz_czsh == 1 \
			and ((self.wtyp_czb_type == ::WtypCzbPart::Type::SC && self.bsscqy_sheng.eql?(user.user_s_province)) or ([::WtypCzbPart::Type::LT, ::WtypCzbPart::Type::CY].include?(self.wtyp_czb_type) && self.bcydw_sheng.eql?(user.user_s_province))))
        if(info.class==FalseClass) then
          return false
        else
          return true
        end
      when ::WtypCzb::State::PASSED
        return false
    end
  end

  def type_prov_enabled?(user)
    #logger.error self.sp_s_220
    #logger.error self.sp_s_4
    if user.hccz_level == User::HcczLevel::Sheng
      ((self.wtyp_czb_type == ::WtypCzbPart::Type::SC && self.bsscqy_sheng.eql?(user.user_s_province)) or ([::WtypCzbPart::Type::LT, ::WtypCzbPart::Type::CY].include?(self.wtyp_czb_type) && self.bcydw_sheng.eql?(user.user_s_province)))
    elsif user.hccz_level == User::HcczLevel::Shi
      ((self.wtyp_czb_type == ::WtypCzbPart::Type::SC && (self.sp_s_220.eql?(user.prov_city) || self.bsscqy_shi.eql?(user.prov_city))) or ([::WtypCzbPart::Type::LT, ::WtypCzbPart::Type::CY].include?(self.wtyp_czb_type) && (self.bcydw_shi.eql?(user.prov_city) || self.sp_s_4.eql?(user.prov_city))))
    elsif user.hccz_level == User::HcczLevel::Xian
      ((self.wtyp_czb_type == ::WtypCzbPart::Type::SC && (self.sp_s_221.eql?(user.prov_country)||self.bsscqy_xian.eql?(user.prov_country))) or ([::WtypCzbPart::Type::LT, ::WtypCzbPart::Type::CY].include?(self.wtyp_czb_type) && (self.bcydw_xian.eql?(user.prov_country) || self.sp_s_5.eql?(user.prov_country))))
    else
      false
    end
  end

  #attachments
  def attachments_dir(folder)
    "#{Rails.application.config.attachment_path}/#{folder}"
  end

  def handle_uploaded_file(folder_name, file)
    path = "#{folder_name}/#{Time.now.strftime("%Y/%m/%d")}"
    target_folder = self.attachments_dir("#{path}")
    ext = File.extname(file.original_filename)
    file_md5 = Digest::MD5.file(file.path).hexdigest.upcase
    FileUtils.mkdir_p "#{target_folder}" unless Dir.exists? "#{target_folder}"
    FileUtils.mv(file.path, "#{target_folder}/#{file_md5}#{ext}")
    return "#{path}/#{file_md5}#{ext}"
  end

  def xc_attachment_file=(file)
    self.xc_attachment_path = handle_uploaded_file('wtyp', file) unless file.blank?
  end

  def xc_attachment_file
    Rails.application.config.attachment_path + '/' + self.xc_attachment_path unless self.xc_attachment_path.blank?
  end

  def pc_attachment_file=(file)
    self.pc_attachment_path = handle_uploaded_file('wtyp', file) unless file.blank?
  end

  def pc_attachment_file
    Rails.application.config.attachment_path + '/' + self.pc_attachment_path unless self.pc_attachment_path.blank?
  end

  def xz_attachment_file=(file)
    self.xz_attachment_path = handle_uploaded_file('wtyp', file) unless file.blank?
  end

  def xz_attachment_file
    Rails.application.config.attachment_path + '/' + self.xz_attachment_path unless self.xz_attachment_path.blank?
  end

  def qd_attachment_file=(file)
    self.qd_attachment_path = handle_uploaded_file("wtyp", file) unless file.blank?
  end

  def qd_attachment_file
    Rails.application.config.attachment_path + "/" + self.qd_attachment_path unless self.qd_attachment_path.blank?
  end

  # 督办状态
  def duban_desc
    if self.wtyp_dbtype.to_i == 1
      '<span class="text-warning">该条目已被设置为: <span class="text-danger">督办</span></span>'.html_safe
    elsif self.wtyp_dbtype.to_i == 2
      '<span class="text-warning">该条目已被设置为: <span class="text-danger">重点督办</span></span>'.html_safe
    end
  end

  private
  def update_step
    if !self.new_record? and self.tmp_save.to_i == 0 and self.part_submit.to_i == 0 and !self.reverting

      case self.current_state
        when ::WtypCzb::State::LOGGED
          self.current_state = ::WtypCzb::State::ASSIGNED
          self.blr = current_user.tname
          self.blr_user_id = current_user.id
          self.tbr_dh = current_user.tel
          self.tbr_cz = current_user.jg_bsb.fax
          self.blbm = current_user.jg_bsb.jg_name
          self.blsj = Time.now

        when ::WtypCzb::State::ASSIGNED
          self.current_state = ::WtypCzb::State::FILLED

          self.blr = current_user.tname
          self.blr_user_id = current_user.id
          self.tbr_dh = current_user.tel
          self.tbr_cz = current_user.jg_bsb.fax
          self.blbm = current_user.jg_bsb.jg_name
          self.tbsj = Time.now

        when ::WtypCzb::State::FILLED
          self.current_state = ::WtypCzb::State::PASSED

          self.shr = current_user.tname
          self.shr_user_id = current_user.id
          self.shr_dh = current_user.tel
          self.shr_cz = current_user.jg_bsb.fax
          self.shbm = current_user.jg_bsb.jg_name
          self.shsj = Time.now

          # 问题样品处置流程结束，强制终止进行中的异议处置流程
          @yydjbs = SpYydjb.where("cjbh = ? and current_state <> ?", self.cjbh, SpYydjb::State::PASSED)
          @yydjbs.update_all(:current_state => SpYydjb::State::HALTED_1)
          @yydjbs.each do |yydjb|
            SpYydjbLogs.create(
                [{:sp_yydjb_id => yydjb.id,
                  :content => '终止',
                  :cjbh => self.cjbh,
                  :sp_yydjb_state => -2,
                  :user_id => current_user.id
                 }])
          end
        when ::WtypCzb::State::PASSED
        else
          if self.created_at.nil?
            self.current_state = ::WtypCzb::State::LOGGED
          end
      end
    end
  end

  def self.revert_enabled?(current_tab, state, current_user)
    if current_tab.eql?('CZWB')
      return true if current_user.hcz_admin == 1
    end
    case state
      when ::WtypCzb::State::LOGGED
        return false if %w{YSH BLZ.QT YBL CZWB YBJ}.include?(current_tab)
        return true
      when ::WtypCzb::State::ASSIGNED
        return false if %w{YSH BLZ.QT YBL CZWB YBJ}.include?(current_tab)
        return true
      when ::WtypCzb::State::FILLED
        return false if %w{YSH BLZ.QT YBL CZWB YBJ}.include?(current_tab)
        return true
    end
    return false
  end

  # 应中检院要求要求，更新中文状态
  def update_state_desc_from_current_state
    self.current_state_desc = state_desc2
  end

  # 日志记录
  def callback_when_updated
    content_tmp = ''
    if self.changes.include? 'part_submit_flag1'
      content_tmp = '启动情况'
    end
    if self.changes.include? 'part_submit_flag2'
      content_tmp = '产品控制'
    end
    if self.changes.include? 'part_submit_flag3'
      content_tmp = '原因排查'
    end
    if self.changes.include? 'part_submit_flag4'
      content_tmp = '行政处罚'
    end
    if self.changes.include? 'part_submit_flag5'
      content_tmp = '未行政处罚'
    end
    if self.changes.include? 'part_submit_flag6'
      content_tmp = '整改处罚'
    end
    if self.changes.include? 'part_submit_flag7'
      content_tmp = '通报移送'
    end
    if self.changes.include? 'current_state'
      if self.changes['current_state'][1] == 0 and self.changes['current_state'][0] == 1
        content_tmp = '退回'
      end
      if self.changes['current_state'][1] == 1 and self.changes['current_state'][0] == 0
        content_tmp = '核查处置安排'
      end
      if self.changes['current_state'][1] == 1 and self.changes['current_state'][0] == 2
        content_tmp = '退回'
      end
      if self.changes['current_state'][1] == 2 and self.changes['current_state'][0] == 1
        content_tmp = '核查处置办理'
      end
      if self.changes['current_state'][1] == 2 and self.changes['current_state'][0] == 3
        content_tmp = '退回'
      end
      if self.changes['current_state'][1] == 3 and self.changes['current_state'][0] == 2
        content_tmp = '核查处置审核'
      end
    end
    if self.changed? && !content_tmp.blank?
      WtypCzbPartLogs.create(sp_bsb_id: self.sp_bsb_id, content: content_tmp, wtyp_czb_part_id: self.id, wtyp_czb_state: self.current_state, wtyp_czb_type: self.wtyp_czb_type, user_id: current_user.id)
    end
  end

  def self.list_by(params, current_user)

    wtyp_czbs = WtypCzbPart.order('id, updated_at desc')
    params[:hccz_type] = 'QB' if params[:hccz_type].blank?
    # 如果不是管理员则进行省份区分 和 安排
    if current_user.hcz_admin != 1 and  !current_user.is_admin? and !current_user.is_sheng?
      # wtyp_czbs = wtyp_czbs.where("((wtyp_czb_type = #{::WtypCzbPart::Type::LT} OR wtyp_czb_type = #{::WtypCzbPart::Type::CY}) AND (bcydw_sheng = ? or shi or xian)) OR (wtyp_czb_type = #{::WtypCzbPart::Type::SC} AND bsscqy_sheng = ?)", current_user.user_s_province, current_user.user_s_province)

      # 筛选 流通/餐饮
      if params[:hccz_type].eql?('SC') #current_user.hccz_type == User::HcczType::SC
        wtyp_czbs = wtyp_czbs.where('wtyp_czb_type IN (?)', [::WtypCzbPart::Type::SC])
        # 筛选 省\市\县
        if current_user.hccz_level == User::HcczLevel::Sheng
          wtyp_czbs = wtyp_czbs.where('bsscqy_sheng = ?', current_user.user_s_province)
        elsif current_user.hccz_level == User::HcczLevel::Shi
          wtyp_czbs = wtyp_czbs.where('sp_s_220 = ? or sp_s_4 = ? or bsscqy_shi = ? or bcydw_shi = ?',current_user.prov_city, current_user.prov_city,current_user.prov_city,current_user.prov_city)
        elsif current_user.hccz_level == User::HcczLevel::Xian
           wtyp_czbs = wtyp_czbs.where('sp_s_221 = ? or sp_s_5 = ? or bcydw_xian = ? or bsscqy_xian=?',current_user.prov_country, current_user.prov_country,current_user.prov_country,current_user.prov_country)
        else
          wtyp_czbs = wtyp_czbs.where('1=3')
        end
      elsif params[:hccz_type].eql?('JY') #current_user.hccz_type == User::HcczType::CY
        wtyp_czbs = wtyp_czbs.where('wtyp_czb_type IN (?)', [::WtypCzbPart::Type::LT, ::WtypCzbPart::Type::CY])

        # 筛选 省\市\县
        if current_user.hccz_level == User::HcczLevel::Sheng
          wtyp_czbs = wtyp_czbs.where('bcydw_sheng = ?', current_user.user_s_province)
        elsif current_user.hccz_level == User::HcczLevel::Shi
          wtyp_czbs = wtyp_czbs.where('sp_s_220 = ? or sp_s_4 = ? or bsscqy_shi = ? or bcydw_shi = ?',current_user.prov_city, current_user.prov_city,current_user.prov_city,current_user.prov_city)
        elsif current_user.hccz_level == User::HcczLevel::Xian
          wtyp_czbs = wtyp_czbs.where('sp_s_221 = ? or sp_s_5 = ? or bcydw_xian = ? or bsscqy_xian=?',current_user.prov_country, current_user.prov_country,current_user.prov_country,current_user.prov_country)
       else
          wtyp_czbs = wtyp_czbs.where('1=4')
       end
     elsif params[:hccz_type].eql?('QB')
       if current_user.hccz_level == User::HcczLevel::Sheng
         wtyp_czbs = wtyp_czbs.where('bsscqy_sheng = ?', current_user.user_s_province)
       elsif current_user.hccz_level == User::HcczLevel::Shi
         wtyp_czbs = wtyp_czbs.where('sp_s_220 = ? or sp_s_4 = ? or bsscqy_shi = ? or bcydw_shi = ?',current_user.prov_city, current_user.prov_city,current_user.prov_city,current_user.prov_city)
       elsif current_user.hccz_level == User::HcczLevel::Xian
         wtyp_czbs = wtyp_czbs.where('sp_s_221 = ? or sp_s_5 = ? or bcydw_xian = ? or bsscqy_xian=?',current_user.prov_country, current_user.prov_country,current_user.prov_country,    current_user.prov_country)
       else
         wtyp_czbs = wtyp_czbs.where('1=5') 
       end
     end    
    end
=begin     
     elsif current_user.is_city?
      wtyp_czbs = wtyp_czbs.where('sp_s_220 = ? or sp_s_4 = ? or bsscqy_shi = ? or bcydw_shi = ?',current_user.prov_city, current_user.prov_city,current_user.prov_city,current_user.prov_city)
    elsif current_user.is_county_level?
     wtyp_czbs = wtyp_czbs.where('sp_s_221 = ? or sp_s_5 = ? or bcydw_xian = ? or bsscqy_xian= ?',current_user.prov_country, current_user.prov_country,current_user.prov_country,current_user.prov_country)
    else
      wtyp_czbs = wtyp_czbs.where('1=2')
    end
=end
    if params[:hccz_type].eql?('SC')
      wtyp_czbs = wtyp_czbs.where('wtyp_czb_type IN (?)', [::WtypCzbPart::Type::SC])
    elsif params[:hccz_type].eql?('JY')
      wtyp_czbs = wtyp_czbs.where('wtyp_czb_type IN (?)', [::WtypCzbPart::Type::LT, ::WtypCzbPart::Type::CY])
    end
    # 时间范围筛选
    wtyp_czbs = wtyp_czbs.where('updated_at between ? and ?', params[:begin_at], params[:end_at])

    # 样品名称
    unless params[:ypmc].blank?
      wtyp_czbs = wtyp_czbs.where('ypmc like ?', "%#{params[:ypmc]}%")
    end

    # 被抽样单位名称
    unless params[:bcydwmc].blank?
      wtyp_czbs = wtyp_czbs.where('bcydwmc like ?', "%#{params[:bcydwmc]}%")
    end

    # 被抽样单位市区
    unless params[:bcydw_shi].blank?
      wtyp_czbs = wtyp_czbs.where('bcydw_shi = ? or sp_s_4=?',params[:bcydw_shi],params[:bcydw_shi])
    end

    # 表示生产企业名称
    unless params[:bsscqymc].blank?
      wtyp_czbs = wtyp_czbs.where('bsscqymc like ?', "%#{params[:bsscqymc]}%")
    end

    # 表示生产企业市区
    unless params[:bsscqy_shi].blank?
      wtyp_czbs = wtyp_czbs.where('bsscqy_shi = ? or sp_s_220 = ?' , params[:bsscqy_shi] ,params[:bsscqy_shi] )
    end

    unless params[:cjbh].blank?
      wtyp_czbs = wtyp_czbs.where('cjbh like ?', "%#{params[:cjbh]}%")
    end

    if !params[:rwly].blank? and  params[:rwly] !="全部"
      #case params[:rwly].to_i
      #  when 1
      #    wtyp_czbs = wtyp_czbs.where('cjbh LIKE ?', '____00%')
      #  when 2
      #    wtyp_czbs = wtyp_czbs.where('cjbh NOT LIKE ?', '____00%')
      #end
      cjbh_arr = SpBsb.where("sp_s_2_1 = ?",params[:rwly]).pluck(:sp_s_16)
      wtyp_czbs = wtyp_czbs.where("cjbh in (?)",cjbh_arr)
    end

    params[:bgfl] = 'QB' if params[:bgfl].blank?
    if params[:bgfl].eql?('24H')
      wtyp_czbs = wtyp_czbs.where("bgfl = '24小时限时报告'")
    elsif params[:bgfl].eql?('YBBHG')
      wtyp_czbs = wtyp_czbs.where("jyjl like '%不合格%'")
    elsif params[:bgfl].eql?('YBWTBG')
      wtyp_czbs = wtyp_czbs.where("jyjl like '%问题%'")
    elsif params[:bgfl].eql?('QB')
      wtyp_czbs = wtyp_czbs.where("jyjl like '%问题%' or jyjl like '%不合格%'")
    end

    wtyp_czbs = wtyp_czbs.paginate(:page => params[:page], :per_page => 30)

    case params[:state].to_i
      when WtypCzb::State::LOGGED # 待安排
        if params[:current_tab].eql?('DBL')
          wtyp_czbs = wtyp_czbs.where(current_state: WtypCzb::State::LOGGED)
        elsif params[:current_tab].eql?('YBL')
          wtyp_czbs = wtyp_czbs.where(current_state: WtypCzb::State::ASSIGNED)
        elsif params[:current_tab].eql?('DB')
          wtyp_czbs = wtyp_czbs.where(current_state: WtypCzb::State::LOGGED, wtyp_dbtype: 1)
        elsif params[:current_tab].eql?('ZDDB')
          wtyp_czbs = wtyp_czbs.where(current_state: WtypCzb::State::LOGGED, wtyp_dbtype: 2)
        elsif params[:current_tab].eql?('CZWB')
          wtyp_czbs = wtyp_czbs.where(current_state: WtypCzb::State::PASSED)
        end
      when WtypCzb::State::ASSIGNED #待处理
        # 待处理列表中仅显示属于自己的信息

        if params[:current_tab].eql?('DBL')
          wtyp_czbs = wtyp_czbs.where('czfzr = ?', current_user.id)
          wtyp_czbs = wtyp_czbs.where(current_state: WtypCzb::State::ASSIGNED)
        elsif params[:current_tab].eql?('BLZ')
          wtyp_czbs = wtyp_czbs.where('czfzr = ?', current_user.id)
          wtyp_czbs = wtyp_czbs.where(current_state: WtypCzb::State::ASSIGNED).where('part_submit_flag1 = 1 or part_submit_flag2 = 1 or part_submit_flag3 = 1 or part_submit_flag4=1 or part_submit_flag5=1 or part_submit_flag6=1 or part_submit_flag7=1')
        elsif params[:current_tab].eql?('BLZ.QT')
          wtyp_czbs = wtyp_czbs.where('czfzr <> ?', current_user.id)
          wtyp_czbs = wtyp_czbs.where(current_state: WtypCzb::State::ASSIGNED)
        elsif params[:current_tab].eql?('YBJ')
          wtyp_czbs = wtyp_czbs.where('czfzr = ?', current_user.id)
          wtyp_czbs = wtyp_czbs.where(current_state: WtypCzb::State::FILLED)
        elsif params[:current_tab].eql?('DB')
          wtyp_czbs = wtyp_czbs.where('czfzr = ?', current_user.id)
          wtyp_czbs = wtyp_czbs.where(current_state: WtypCzb::State::ASSIGNED, wtyp_dbtype: 1)
        elsif params[:current_tab].eql?('ZDDB')
          wtyp_czbs = wtyp_czbs.where('czfzr = ?', current_user.id)
          wtyp_czbs = wtyp_czbs.where(current_state: WtypCzb::State::ASSIGNED, wtyp_dbtype: 2)
        elsif params[:current_tab].eql?('CZWB')
          wtyp_czbs = wtyp_czbs.where(current_state: WtypCzb::State::PASSED)
        end
      when WtypCzb::State::FILLED # 待审核
        if params[:current_tab].eql?('DSH')
          wtyp_czbs = wtyp_czbs.where(current_state: WtypCzb::State::FILLED)
        elsif params[:current_tab].eql?('YSH')
          wtyp_czbs = wtyp_czbs.where(current_state: WtypCzb::State::PASSED)
        elsif params[:current_tab].eql?('DB')
          wtyp_czbs = wtyp_czbs.where(current_state: WtypCzb::State::FILLED, wtyp_dbtype: 1)
        elsif params[:current_tab].eql?('ZDDB')
          wtyp_czbs = wtyp_czbs.where(current_state: WtypCzb::State::FILLED, wtyp_dbtype: 2)
        elsif params[:current_tab].eql?('CZWB')
          wtyp_czbs = wtyp_czbs.where(current_state: WtypCzb::State::PASSED)
        end
    end
    return wtyp_czbs
  end
end
