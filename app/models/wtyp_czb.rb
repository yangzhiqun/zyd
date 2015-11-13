#encoding: utf-8
class WtypCzb < ActiveRecord::Base
  attr_accessible :wtyp_contacts, 
	:wtyp_date, 
	:wtyp_deal_detail, 
	:wtyp_deal_jg, 
	:wtyp_deal_way, 
	:wtyp_email, 
	:wtyp_fax, 
	:wtyp_jg, 
	:wtyp_remark, 
	:wtyp_state, 
	:wtyp_tel, 
	:wtyp_verify,
	:wtyp_sp_bsbs_id,
	:wtyp_no,
	:wtyp_deal_segment,
	:wtyp_deal_affirm,
	:wtyp_deal_site,
	:wtyp_deal_result,
  :wtyp_deal_fix1way,
  :wtyp_deal_fix2way,
  :wtyp_deal_fix3way,
  :wtyp_result_fix1way,
  :wtyp_result_fix2way,
  :wtyp_result_fix3way,
  :wtyp_result_fix4way,
  :wtyp_result_fix5way,
  :wtyp_result_fix6way,
  :wtyp_result_fix7way,
  :wtyp_result_fix8way,
  :current_state,
  :czb_type,
  :bcydw_sheng,
  :bsscqy_sheng,
  :yyzt,
  :yyfl,
  :yyczjg,
  :fjzt,
  :fjsqr,
  :fjsqsj,
  :fjslrq,
  :fjwcsj,
  :fjjgou,
  :blbm,
  :blr,
  :blsj,
  :tbbm,
  :tbr,
  :tbsj,
  :shbm,
  :shr,
  :shsj,
  :cjbh,
  :ypmc,
  :ypgg,
  :ypph,
  :jyjl,
  :bcydwmc,
  :cydwmc,
  :cydwsf,
  :bsscqymc,
  :scrq,
  :yytcr,
  :yytcsj,
  :yysdsj,
  :yynr,
  :djbm,
  :djr,
  :djsj,
  :fjsqzk,
  :bgfl,
  :yyczqk,
  :thyy,
  :czbm, 
  :czfzr,
  :bgsbh,
	:cydd,
	:bcydwdz,
	:bsscqydz,
	:cyjs,
	:jymd,
	:jyjgzt,
	:bgfl,
	:qdhcczrq,
	:shbm,
	:czwbrq,
	:fxpj_1,
	:fxpj_2,
	:fxpj_3,
	:cpkzqk_1,
	:cpkzqk_2,
	:cpkzqk_3,
	:cpkzqk_4,
	:cpkzqk_5,
	:cpkzqk_6,
	:cpkzqk_7,
	:cpkzqk_8,
	:cpkzqk_9,
	:cpkzqk_10,
	:cpkzqk_11,
	:cpkzqk_12,
	:cpkzqk_13,
	:cpkzqk_14,
	:cpkzqk_15,
	:cpkzqk_16,
	:cpkzqk_17,
	:cpkzqk_18,
	:cpkzqk_19,
  :cpkzqk_20,
  :cpkzqk_21,
  :cpkzqk_22,
  :cpkzqk_23,
	:pczgfc_1,
	:pczgfc_2,
	:pczgfc_3,
	:pczgfc_4,
	:pczgfc_5,
	:pczgfc_6,
	:pczgfc_7,
	:pczgfc_8,
	:pczgfc_9,
	:xzcfqk_1,
	:xzcfqk_2,
	:xzcfqk_3,
	:xzcfqk_4,
	:xzcfqk_5,
	:xzcfqk_6,
	:xzcfqk_7,
	:xzcfqk_8,
	:xzcfqk_9,
	:xzcfqk_10,
	:xzcfqk_11,
	:xzcfqk_12,
	:xzcfqk_13,
	:xzcfqk_14,
	:xzcfqk_15,
	:xzcfqk_16,
	:xzcfqk_17,
	:xzcfqk_18,
	:xzcfqk_19,
	:xzcfqk_20,
	:xzcfqk_21,
	:hccz_type,
	:part_submit_flag1,
	:part_submit_flag2,
	:part_submit_flag3,
	:part_submit_flag4,
	:wtyp_czb_type

  def spdata
    SpHczSpdata.where(:wtyp_czb_id => self.id)
  end

  has_many :wtyp_czb_parts, :dependent => :destroy

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
    Rails.logger.error "cccccccccccccccccccccccccc...................tick1"

		t = WtypCzbPart.where("(wtyp_czb_type = #{::WtypCzbPart::Type::LT} AND bcydw_sheng = ?) OR (wtyp_czb_type = #{::WtypCzbPart::Type::SC} AND bsscqy_sheng = ?)", user.user_s_province, user.user_s_province).last
    return true if !t.nil? and t.current_state == -1
    Rails.logger.error "cccccccccccccccccccccccccc...................tick2"

    return true if WtypCzbPart.count(:conditions => ["wtyp_czb_id = ?", self.id]) == 0
    @records = WtypCzbPart.where("(bcydw_sheng = ? or bsscqy_sheng = ?) and wtyp_czb_id = ?", user.user_s_province, user.user_s_province, self.id)

    if user.user_s_province.eql?(self.bcydw_sheng) or user.user_s_province.eql?(self.bsscqy_sheng)
      if user.hcz_czap == 1 and @records.where("current_state = ?", ::WtypCzb::State::LOGGED).count > 0
        Rails.logger.error "cccccccccccccccccccccccccc...................tick3"
        return true
      end

      if user.hcz_czbl == 1 and @records.where("current_state = ?", ::WtypCzb::State::ASSIGNED).count > 0
        Rails.logger.error "cccccccccccccccccccccccccc...................tick4"
        return true
      end

      if user.hcz_czsh == 1 and @records.where("current_state = ?", ::WtypCzb::State::FILLED).count > 0
        Rails.logger.error "cccccccccccccccccccccccccc...................tick5"
        return true
      end
      Rails.logger.error "cccccccccccccccccccccccccc...................tick6"
      return false
    else
      Rails.logger.error "cccccccccccccccccccccccccc...................tick7"
      return false
    end
  end

  module State
    CANCEL = -1
    # 已保存
    LOGGED = 0
    # 已安排
    ASSIGNED = 1
    # 已填报
    FILLED = 2
    # 已审核
    PASSED = 3
  end
end
