class TmpSpBsb < ActiveRecord::Base
  belongs_to :sp_bsbs, class_name: "SpBsb", foreign_key: "id"
	def is_bad_report?
  	result = sp_s_71 || ''
  	result.include?('问题样品') or result.include?('不合格样品')
	end

  # 用户是否有生产问题样品处置权限
  def sc_wtypcz_enabled?(user_prov)
    return false if user_prov.nil?
    self.sp_s_202.eql?(user_prov)
  end

  # 用户是否有经营问题样品处置权限
  def lt_wtypcz_enabled?(user_prov)
    return false if user_prov.nil?
    self.sp_s_3.eql?(user_prov)
  end

  def yydjb
    SpYydjb.find_by_cjbh(self.sp_s_16)
  end

  # 是否已经存在问题样品处理
  def wtyp_cz_present?
    WtypCzb.where('wtyp_sp_bsbs_id = ?', self.id).count > 0
  end

  # 核查处置完成情况
  def status_desc
    parts = WtypCzbPart.where(sp_bsb_id: self.id).select("wtyp_czb_type, current_state, id").as_json
    if parts.empty?
      return "未开始"
    end 

    parts.each do |part|
      if part['wtyp_czb_type'] == ::WtypCzbPart::Type::SC
        @sc_state = part['current_state']   
      elsif part['wtyp_czb_type'] == ::WtypCzbPart::Type::LT
        @lt_state = part['current_state']   
      end
    end

    if @sc_state == ::WtypCzb::State::PASSED and @lt_state == ::WtypCzb::State::PASSED
      "已完成"
    elsif @sc_state == ::WtypCzb::State::PASSED and @lt_state != ::WtypCzb::State::PASSED 
      "已完成-生产"
    elsif @sc_state != ::WtypCzb::State::PASSED and @lt_state == ::WtypCzb::State::PASSED 
      "已完成-流通"
    elsif @sc_state != ::WtypCzb::State::PASSED and @lt_state != ::WtypCzb::State::PASSED 
      "进行中"
    else
      "未知"
    end
  end
end
