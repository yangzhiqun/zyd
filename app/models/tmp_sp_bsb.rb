class TmpSpBsb < ActiveRecord::Base
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
    WtypCzb.count(:conditions => ["wtyp_sp_bsbs_id = ?", self.id]) > 0
  end
end
