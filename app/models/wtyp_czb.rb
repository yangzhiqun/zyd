#encoding: utf-8
class WtypCzb < ActiveRecord::Base

  def spdata
    SpHczSpdata.where(:wtyp_czb_id => self.id)
  end

  has_many :wtyp_czb_parts, :dependent => :destroy
  has_many :sp_hcz_spdatas, :dependent => :destroy

  # validates_uniqueness_of :wtyp_sp_bsbs_id

  def yyczjg
    @yydjb = SpYydjb.find_by_cjbh(self.cjbh)
    if @yydjb.blank?
      "-"
    else
      @yydjb.yyczjg
    end
  end

  def state_desc
    case self.current_state
      when ::WtypCzb::State::LOGGED
        "-"
      when ::WtypCzb::State::ASSIGNED
        "已安排"
      when ::WtypCzb::State::FILLED
        "已填报"
      when ::WtypCzb::State::PASSED
        "已通过"
      else
        "-"
    end
  end

  def czfzr_desc
    if self.czfzr.blank?
      ""
    else
      User.find(self.czfzr.to_i).tname
    end
  end

  def can_be_handled_by?(user)
    return false if user.hcz_admin == 1

    t = WtypCzbPart.where("(wtyp_czb_type = #{::WtypCzbPart::Type::LT} AND bcydw_sheng = ?) OR (wtyp_czb_type = #{::WtypCzbPart::Type::SC} AND bsscqy_sheng = ?)", user.user_s_province, user.user_s_province).last
    return true if !t.nil? and t.current_state == -1

    return true if WtypCzbPart.where('wtyp_czb_id = ?', self.id).count == 0
    @records = WtypCzbPart.where('(bcydw_sheng = ? or bsscqy_sheng = ?) and wtyp_czb_id = ?', user.user_s_province, user.user_s_province, self.id)

    if user.user_s_province.eql?(self.bcydw_sheng) or user.user_s_province.eql?(self.bsscqy_sheng)
      if user.hcz_czap == 1 and @records.where("current_state = ?", ::WtypCzb::State::LOGGED).count > 0
        return true
      end

      if user.hcz_czbl == 1 and @records.where("current_state = ?", ::WtypCzb::State::ASSIGNED).count > 0
        return true
      end

      if user.hcz_czsh == 1 and @records.where("current_state = ?", ::WtypCzb::State::FILLED).count > 0
        return true
      end
      return false
    else
      return false
    end
  end

  module State
    CANCEL = -1
    # 已保存
    LOGGED = 0
    # 已安排/已领取
    ASSIGNED = 1
    # 已填报
    FILLED = 2
    # 已审核
    PASSED = 3
  end
end
