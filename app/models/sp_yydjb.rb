#encoding: utf-8
class SpYydjb < ActiveRecord::Base
  # attr_accessible :title, :body
  # attr_accessible :attachments, :attachment_file, :sp_bsb_id, :yyczqk, :yyczzt, :yyczjg, :fjzt, :fjsqqk, :bcydw, :bcydwsf, :cydw, :cydwsf, :bsscqy, :bsscqysf, :yysdsj, :yytcsj, :yyfl, :yyczbm, :yyczfzr, :cjbh, :ypmc, :ypgg, :ypph, :jyjl, :scrq, :yytcr, :yynr, :fjsqr, :fjsqsj, :fjslrq, :fjwcsj, :fjjg, :bljg, :djbm, :djr, :djsj, :blbm, :blr, :blsj, :tbbm, :tbr, :tbsj, :shbm, :shr, :shsj, :dj_delayed,:gzscqyrq,:gzbcydwrq
  attr_accessor :session
	validates_presence_of :cjbh, message: "抽样单号务必填写"

	validates_presence_of :cjbh, message: "抽样单号务必填写"

  module State
    # 问题样品处置流程结束，终止异议处置流程
    HALTED_1 = -2
    # 已取消
    CANCEL = -1
    # 已登记
    LOGGED = 0
    # 已安排
    ASSIGNED = 1
    # 已填报
    FILLED = 2
    # 已审核
    PASSED = 3
  end

  after_save :callback_when_saved

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

  def attachment_file=(file)
    self.attachment_path = handle_uploaded_file("yydjb", file) unless file.blank?
  end

  def attachment_file
    Rails.application.config.attachment_path + "/" + self.attachment_path unless self.attachment_path.blank?
  end

  # 异议成功 
  def yy_succeed?
    (self.yyczjg || "").eql? "异议认可"
  end

  # 异议处理中
  def yy_in_progress?
    (self.yyczjg || "").eql? "异议处置中"
  end

  # 异议失败
  def yy_failed?
    (self.yyczjg || "").eql? "异议不认可" or (self.yyczjg || "").eql? "逾期异议"
  end

  #TODO: 修正part_index 问题样品处置是否可以继续进行
  def wtypcz_enabled?(wtypcz)
    if wtypcz.new_record?
      if self.yy_failed?
        return true
      else
        return false
      end
    else
      if self.created_at.to_i <= wtypcz.created_at.to_i
        if self.yy_succeed? or self.yy_in_progress?
          return false
        else
          return true
        end
      else
        return true
      end
    end 
  end

  def fjqk_desc
    case self.fjsqqk
    when 0
      "未申请复检"
    when 1
      "已申请复检"
    end
  end

  def fjzt_to_s	
	  case self.fjzt
		when 0
		  "复检中"
		when 1
		  "复检合格"
		when -1
		  ""
    when 2
		  "复检不合格"
    end
	end

  def fj_desc
    case self.fjzt
    when 0
      "复检中"
    when 1
      "复检合格"
    when -1
      "未申请复检"
    when 2
      "复检不合格"
    end
  end

	# 是否逾20天仍未办理完成
	def is_overdue?(auto_commit=false)
		if Time.now.to_i - self.created_at.to_i > 20.days.to_i
			if auto_commit
				# 增加日志
				self.update_attributes(current_state: SpYydjb::State::PASSED)
			end

			return true
		else
			return false
		end
	end

	def self.auto_commit_overdue
		@djbs = SpYydjb.where("created_at < ? and current_state <> ?", Time.now - 20.days, ::SpYydjb::State::PASSED)
		if @djbs.update_all(current_state: ::SpYydjb::State::PASSED)
			@djbs.each do |djb|
				SpYydjbLogs.create(:sp_yydjb_id => djb.id, :content => "20天未办理完成，自动提交", :cjbh => djb.cjbh, :sp_yydjb_state => djb.current_state, :user_id => -999) 
			end
		end
	end

	def can_be_handled_by?(user)
		return false if user.yyadmin == 1
    case self.current_state
    when ::SpYydjb::State::HALTED_1
      return false
    when ::SpYydjb::State::LOGGED
      user.zhxt == 1
    when ::SpYydjb::State::ASSIGNED
      user.yybl == 1
    when ::SpYydjb::State::FILLED
      user.yysh == 1
    else
      false
    end
  end

  def fjzt_desc
    case self.fjsqqk
    when -1
      "未申请"
    when 0
      "复检中"
    end
  end
  
  def yyczfzr_desc
    if self.yyczfzr.blank?
      ""
    else
      User.find(self.yyczfzr.to_i).tname
    end
  end

  def tbr_desc
    if self.tbr.blank?
      ""
    else
      User.find(self.tbr.to_i).tname
    end
  end

  # 日志记录
  def callback_when_saved
    content_tmp = ''
    if self.changes.include?'created_at'
      content_tmp = '异议处理登记'
    end
    if self.changes.include?'attachments' and self.changes["attachments"][0].blank? and !self.changes["attachments"][1].blank?  
      content_tmp = '首次附件'
      SpYydjbLogs.create(
      [{  :sp_yydjb_id      => self.id,
          :content          => content_tmp,
          :cjbh             => self.cjbh,
          :sp_yydjb_state   => self.current_state,
          :user_id => current_user.id
      }]) 
    end
    if self.changes.include?'current_state'
      if self.changes["current_state"][1] == -1 and self.changes["current_state"][0] == 1
        content_tmp = '退回'
      end
      if self.changes["current_state"][1] == 1 and self.changes["current_state"][0] == 2
        content_tmp = '退回'
      end
      if self.changes["current_state"][1] == 2 and self.changes["current_state"][0] == 1
        content_tmp = '异议处理办理'
      end
      if self.changes["current_state"][1] == 2 and self.changes["current_state"][0] == 3
        content_tmp = '退回'
      end
      if self.changes["current_state"][1] == 3 and self.changes["current_state"][0] == 2
        content_tmp = '异议处理审核'
      end
    end
    if self.changed? && !content_tmp.blank?
			SpYydjbLogs.create(
          [{  :sp_yydjb_id      => self.id,
              :content          => content_tmp,
              :cjbh             => self.cjbh,
              :sp_yydjb_state   => self.current_state,
              :user_id => current_user.id
          }]) 
    end
  end

  YYFL = [["请选择", ""], ["采样操作异议", "采样操作异议"], ["检验过程异议", "检验过程异议"], ["检验结果异议", "检验结果异议"], ["假冒异议", "假冒异议"]]
  YYCZJG = [["请选择", ""], ["逾期未提异议", "逾期未提异议"], ["异议处理中", "异议处理中"], ["异议不认可", "异议不认可"], ["省局认可异议", "省局认可异议"]]
  FJZT = [["请选择", ""], ["逾期未提复检", "逾期未提复检"], ["复检中", "复检中"], ["复检合格", "复检合格"], ["复检不合格", "复检不合格"], ["最终检验结论", "最终检验结论"]]
end
