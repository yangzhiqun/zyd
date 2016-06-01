#encoding: utf-8
class WtypCzbPart < ActiveRecord::Base
  attr_accessor :tmp_save, :part_submit, :current_user, :reverting, :save_me
  belongs_to :sp_bsb

  before_save :update_step, :if => Proc.new { |part| !part.current_user.blank? }

  # 更新问题样品处置的状态
  before_update :update_state_desc_from_current_state

  after_update :callback_when_updated

  def state_desc2
    case self.current_state
    when ::WtypCzb::State::LOGGED
      "未处置"
    when ::WtypCzb::State::ASSIGNED
      if self.part_submit_flag1 or self.part_submit_flag2 or self.part_submit_flag3
				return "处置中"
			else
				return "未处置"
			end
    when ::WtypCzb::State::FILLED
      "处置中"
    when ::WtypCzb::State::PASSED
      "处置完毕"
    else
      "-"
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
      return "danger"
    end

    if days_diff > 20 and !part_submit_flag2
      return "danger"
    end

    if days_diff > 90 and !part_submit_flag3
      return "danger"
    end
    ""
  end

  def visible_for_user?(user, type)
    tmp = false
    return true if user.hcz_admin == 1
    case type
      when ::WtypCzbPart::Type::SC
        if  !self.bsscqy_sheng.blank? and self.bsscqy_sheng.eql?(user.user_s_province) and self.sp_s_220.eql?(user.prov_city)
          tmp =true
        end
        return tmp
      when ::WtypCzbPart::Type::LT
        if  !self.bcydw_sheng.blank? and self.bcydw_sheng.eql?(user.user_s_province) and self.sp_s_4.eql?(user.prov_city)
          tmp =true
        end
        return tmp
    else
      false
    end
  end

  # 问题原因
  def wtyy
    yy = []
    yy.push "人为添加" if self.pczgfc_2 == 1
    yy.push "原料问题" if self.pczgfc_11 == 1
    yy.push "生产工艺" if self.pczgfc_12 == 1
    yy.push "过程控制不严" if self.pczgfc_13 == 1
    yy.push "储运不当" if self.pczgfc_14 == 1
    yy.push "包装迁移" if self.pczgfc_15 == 1
    yy.push "标签标识问题" if self.pczgfc_16 == 1
    yy.push "其他" if self.pczgfc_17 == 1

    yy.join("，")
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

	def enable_operation?(user)
		case self.current_state
		when ::WtypCzb::State::LOGGED
			return false
		when ::WtypCzb::State::ASSIGNED
			user.hcz_admin != 1 and user.hcz_czbl == 1 \
			and ((self.wtyp_czb_type == ::WtypCzbPart::Type::SC && self.bsscqy_sheng.eql?(user.user_s_province)) or ([::WtypCzbPart::Type::LT, ::WtypCzbPart::Type::CY].include?(self.wtyp_czb_type) && self.bcydw_sheng.eql?(user.user_s_province))) \
			and self.czfzr.to_i == user.id
		when ::WtypCzb::State::FILLED
			user.hcz_admin != 1 and user.hcz_czsh == 1 \
			and ((self.wtyp_czb_type == ::WtypCzbPart::Type::SC && self.bsscqy_sheng.eql?(user.user_s_province)) or ([::WtypCzbPart::Type::LT, ::WtypCzbPart::Type::CY].include?(self.wtyp_czb_type) && self.bcydw_sheng.eql?(user.user_s_province)))
		when ::WtypCzb::State::PASSED
			return false
		end
	end

	def type_prov_enabled?(user)
		((self.wtyp_czb_type == ::WtypCzbPart::Type::SC && self.bsscqy_sheng.eql?(user.user_s_province)) or ([::WtypCzbPart::Type::LT, ::WtypCzbPart::Type::CY].include?(self.wtyp_czb_type) && self.bcydw_sheng.eql?(user.user_s_province)))
	end

  private
  def update_step
    if !self.new_record? and self.tmp_save.to_i == 0 and self.part_submit.to_i == 0 and !self.reverting

      case self.current_state
      when ::WtypCzb::State::LOGGED
        self.current_state = ::WtypCzb::State::ASSIGNED
        self.blr = current_user.tname
        self.blr_user_id = current_user.id
        self.blbm = current_user.jg_bsb.jg_name
        self.blsj = Time.now

      when ::WtypCzb::State::ASSIGNED
        self.current_state = ::WtypCzb::State::FILLED

        self.tbr = current_user.tname
        self.tbr_user_id = current_user.id
        self.tbbm = current_user.jg_bsb.jg_name
        self.tbsj = Time.now

      when ::WtypCzb::State::FILLED
        self.current_state = ::WtypCzb::State::PASSED

        self.shr = current_user.tname
        self.shr_user_id = current_user.id
        self.shbm = current_user.jg_bsb.jg_name
        self.shsj = Time.now

        # 问题样品处置流程结束，强制终止进行中的异议处置流程
        @yydjbs = SpYydjb.where("cjbh = ? and current_state <> ?", self.cjbh, SpYydjb::State::PASSED)
        @yydjbs.update_all(:current_state => SpYydjb::State::HALTED_1)
        @yydjbs.each do |yydjb|
          SpYydjbLogs.create(
          [{  :sp_yydjb_id      => yydjb.id,
              :content          => '终止',
              :cjbh             => self.cjbh,
              :sp_yydjb_state   => -2,
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
		case state
		when ::WtypCzb::State::LOGGED, ::WtypCzb::State::ASSIGNED
			return false if current_user.hcz_admin == 1
			return true if [0, 1, 4].include?(current_tab)
		when ::WtypCzb::State::FILLED
			if current_user.hcz_admin == 1 and current_tab == 1
				return true
			elsif current_tab == 0
				return false if current_user.hcz_admin == 1
				return true
			end
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
    if self.changes.include?'part_submit_flag1'
      content_tmp = '产品控制'
    end
    if self.changes.include?'part_submit_flag2'
      content_tmp = '排查整改'
    end
    if self.changes.include?'part_submit_flag3'
      content_tmp = '行政处罚'
    end
    if self.changes.include?'current_state'
      if self.changes["current_state"][1] == 0 and self.changes["current_state"][0] == 1
        content_tmp = '退回'
      end
      if self.changes["current_state"][1] == 1 and self.changes["current_state"][0] == 0
        content_tmp = '核查处置安排'
      end
      if self.changes["current_state"][1] == 1 and self.changes["current_state"][0] == 2
        content_tmp = '退回'
      end
      if self.changes["current_state"][1] == 2 and self.changes["current_state"][0] == 1
        content_tmp = '核查处置办理'
      end
      if self.changes["current_state"][1] == 2 and self.changes["current_state"][0] == 3
        content_tmp = '退回'
      end
      if self.changes["current_state"][1] == 3 and self.changes["current_state"][0] == 2
        content_tmp = '核查处置审核'
      end
    end
    if self.changed? && !content_tmp.blank?
      WtypCzbPartLogs.create({
        :sp_bsb_id => self.sp_bsb_id, 
        :content => content_tmp, 
        :wtyp_czb_part_id => self.id, 
        :wtyp_czb_state   => self.current_state,
        :wtyp_czb_type => self.wtyp_czb_type,
        :user_id => current_user.id})
    end
  end
end
